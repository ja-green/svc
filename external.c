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

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

int fexists(const char *f, int pbits) {
  if (access(f, pbits) == 0) {
    return EXIT_SUCCESS;
  } else {
    return EXIT_FAILURE;
  }
}

int get_from_path(const char *buf, const char *f) {
  char *dir, *path = getenv("PATH");
  
  for (dir = strtok(path, ":"); dir; dir = strtok(NULL, ":")) {
    printf("%s\n", dir);
  }

  return 0;
}

int execv_external(const char *f, const char *argv) {
  int pid, status;

  pid = fork();

  if (pid == 0) {
    execvp(f, argv);
    return EXIT_FAILURE;

  } else if (pid == -1) {
    return EXIT_FAILURE;
    
  } else {
    wait(&status);

    return status;
  }
}
