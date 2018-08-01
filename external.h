#ifndef EXTERNAL_H
#define EXTERNAL_H

int fexists(const char *f, int pbits);

int get_from_path(const char *buf, const char *f);

int execv_external(const char *f, const char *argv);

#endif /* EXTERNAL_H */
