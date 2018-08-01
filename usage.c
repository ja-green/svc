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
#include <stdarg.h>

#include "usage.h"

static void report(const char *prefix, const char *err, va_list params) {
  fputs(prefix, stderr);
  vfprintf(stderr, err, params);
  fputs("\n", stderr);
}

void die(const char *err, ...) {
  va_list params;

  va_start(params, err);
  report("fatal: ", err, params);
  va_end(params);

  exit(EXIT_FAILURE);
}

void error(const char *err, ...) {
  va_list params;

  va_start(params, err);
  report("error: ", err, params);
  va_end(params);

  exit(EXIT_FAILURE);
}

void warn(const char *err, ...) {
  va_list params;

  va_start(params, err);
  report("error: ", err, params);
  va_end(params);
}
