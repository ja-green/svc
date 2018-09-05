#ifndef EXTERNAL_H
#define EXTERNAL_H

int fexists(const char *f, int pbits);

int get_from_path(const char *buf, const char *f);

int execvs(const char *f, const char *argv);
int execvb(const char *f, const char *argv, const char *service);

#endif /* EXTERNAL_H */
