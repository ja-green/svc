#ifndef COMMAND_H 
#define COMMAND_H

/* builtin declarations */
extern int cmd_help(int argc, const char **argv);
extern int cmd_version(int argc, const char **argv);
extern int cmd_start(int argc, const char **argv);

struct builtin {
  const char *cmd;
  int (*fn)(int, const char **);
  const char *desc;
};

extern struct builtin builtins[];

void ls_commands(void);

struct builtin *get_builtin(const char *c);

int is_builtin(const char *c);

int exec_builtin(const char *c, int argc, const char **argv);

#endif /* COMMAND_H */
