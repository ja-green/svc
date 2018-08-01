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

static const char *main_usage =
  "svc [<command>] [subcommand] [options]";

static const char *help_usage =
  "svc help [<subcommand>] [options]";

static struct option long_options[] = {
  {"all",  no_argument, 	NULL, 	'a' },
  {"help", no_argument, 	NULL, 	'h' },
  {"man",  no_argument, 	NULL, 	'm' },
};

int cmd_help(int argc, const char **argv) {
  int c, show_all, show_hlp, show_man;

  while ((c = getopt_long(argc, argv, "ahm", long_options, NULL)) != -1) {
    switch (c) {
      case 'a':	show_all = 1; break;
      case 'h':	show_hlp = 1; break;
      case 'm':	show_man = 1;	break;
  	}	
  }

  if (argc == 1) {
    puts(main_usage);

  } else if (show_all == 1) {
    ls_commands();
    puts("\nsee 'svc help' for help with a specific command or concept");

  } else if (show_hlp == 1) {
    puts(help_usage);

  } else if (show_man == 1) {
    char *manargs[] = {"man", "svc", (char *) NULL};
    execv_external("man", manargs);
  }

  return EXIT_SUCCESS;
}
