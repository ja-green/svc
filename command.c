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
#include <string.h>

#include "command.h"

struct builtin builtins[] = {
  {"help",    cmd_help,    "show help information"},
  {"version", cmd_version, "show version information"},
  {"start",   cmd_start,   "start running a microservice"},
};

void ls_commands(void) {
  int cmd_amt = sizeof(builtins) / sizeof((builtins)[0]);

  puts("builtin commands:");
  for (int i = 0; i < cmd_amt; i++) {
    struct builtin *b = builtins + i;

    printf("  %-10s %s\n", b->cmd, b->desc);
  }
}

struct builtin *get_builtin(const char *c) {
  int cmd_amt = sizeof(builtins) / sizeof((builtins)[0]);

  for (int i = 0; i < cmd_amt; i++) {
    struct builtin *b = builtins + i;
    
    if (!strcmp(c, b->cmd)) {
      return b;
    }
  }

  return NULL;
}

int is_builtin(const char *c) {
  if (get_builtin(c) != NULL) {
    return EXIT_SUCCESS;
  } else {
    return EXIT_FAILURE;
  }
}

int exec_builtin(const char *c, int argc, const char **argv) {
  struct builtin *b = get_builtin(c);

  int exit_stat = b->fn(argc, argv);

  return exit_stat;
}
