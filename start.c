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

#include "command.h"
#include "external.h"

static const char *start_usage =
  "svc start [options] \
 \nsvc start [microservice] [options]";

static struct option long_options[] = {
  {"all",  no_argument, 	NULL, 	'a' },
  {"help", no_argument, 	NULL, 	'h' },
  {"man",  no_argument, 	NULL, 	'm' },
};

int cmd_start(int argc, const char **argv) {
  int c, show_all, show_hlp, show_man;

  while ((c = getopt_long(argc, argv, "ahm", long_options, NULL)) != -1) {
    switch (c) {
      case 'a':	show_all = 1; break;
      case 'h':	show_hlp = 1; break;
      case 'm':	show_man = 1;	break;
  	}	
  }

  const char *services[argc - optind];
  for (int i = optind; i < argc; i++) {
    services[i - optind] = argv[i];
  }

  for (int i = 0; i < argc - optind; i++) {
    printf("service[%d] = %s\n", i, services[i]);
  }

  return EXIT_SUCCESS;
}
