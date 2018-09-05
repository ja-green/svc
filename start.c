/* 
 * Copyright (C) 2018 Jack Green (ja-green)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <unistd.h>
#include <string.h>
#include <sys/stat.h>

#include "command.h"
#include "external.h"
#include "socket.h"
#include "usage.h"

#define GITHUB_URI    "https://api.github.com/repos/hmrc/"
#define HMRC_BINT_URI "https://dl.bintray.com/hmrc/releases/uk/gov/hmrc/"

#define TEMP_DIR      "/tmp/svc/"
#define FIFO_DIR      "/dev/shm/svc/"

static const char *start_usage =
  "svc start [options] \
 \nsvc start [microservice] [options]";

static struct option long_options[] = {
  {"all",      no_argument, 	      NULL, 	'a' },
  {"help",     no_argument, 	      NULL, 	'h' },
  {"version",  required_argument, 	NULL, 	'v' },
};

static int verify_exists(const char *service) {
  char url[strlen(GITHUB_URI) + strlen(service) + 1];
  int response;

  snprintf(url, sizeof url, "%s%s", GITHUB_URI, service);

  response = socket_writef(url, NULL);

  switch (response) {
    case HTTP_OK:   return EXIT_SUCCESS;
    default:        return response;
  }
}

static int download_tgz(const char *service, const char *version) {
  char url[strlen(HMRC_BINT_URI) + strlen(service) + strlen(service) + strlen(version) + strlen(version) + 18];
  char tgz[strlen(TEMP_DIR) + strlen(service) + strlen(version) + 2];
  int response;
  FILE *fp;

  snprintf(tgz, sizeof tgz, "%s%s%s%s",           TEMP_DIR,      service, "-",      version);
  snprintf(url, sizeof url, "%s%s%s%s%s%s%s%s%s", HMRC_BINT_URI, service, "_2.11/", version, "/", service, "_2.11-", version, ".tgz");

  mkdir(TEMP_DIR,  0755);

  // finish rest of creating tgz file

  fp = fopen(tgz, "w");

  if (socket_writef(url, fp) != 200) {
    return EXIT_FAILURE;
  }

  fclose(fp);

  char *tarargs[] = {"tar", "-xzf", tgz, "-C", TEMP_DIR, (char *) NULL};
  execvs("tar", tarargs);

  return EXIT_SUCCESS;
}

static int run_service(const char *service) {
  char svc_fifo[strlen(FIFO_DIR) + strlen(service) + 1];

  mkdir(FIFO_DIR,  0666);
  mkfifo(svc_fifo, 0666);

  // finish rest of fifo creation
  
  return 0;
}

int cmd_start(int argc, const char **argv) {
  int c, show_hlp;
  char version[8];
  const char *services[argc - optind];

  while ((c = getopt_long(argc, argv, "hv:", long_options, NULL)) != -1) {
    switch (c) {
      case 'h':	show_hlp = 1;     break;
      case 'v': snprintf(version, 16, "%s", optarg); break;
  	}	
  }

  if (show_hlp == 1) {
    puts(start_usage);
  }

  for (int i = optind; i < argc; i++) {
    services[i - optind] = argv[i];
  }

  for (int i = 0; i < argc - optind; i++) {
    if (version == NULL) {
      die("no version specified");
    }

    if (download_tgz(services[i], version) != 0) {
      if (verify_exists(services[i]) != 0) {
        die("'%s' does not exist", services[i]);
      } else {
        die("failed to download source for '%s'", services[i]);
      }
    }

    char bin[strlen(TEMP_DIR) + strlen(services[i]) + strlen(services[i]) + strlen(version) + 7];
    snprintf(bin, sizeof(bin), "%s%s%s%s%s%s", TEMP_DIR, services[i], "-", version, "/bin/", services[i]);

    char *bashargs[] = {"bash", bin, (char *) NULL};
    execvb("bash", bashargs, services[i]);
  }

  return EXIT_SUCCESS;
}
