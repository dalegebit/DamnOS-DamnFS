#ifndef __STDIO
#define __STDIO

typedef __builtin_va_list va_list;

#define va_start(ap, last) __builtin_va_start(ap, last)

#define va_arg(ap, type) __builtin_va_arg(ap, type)

#define va_end(ap) __builtin_va_end(ap)

#ifndef NULL
#define NULL	((void *) 0)
#endif /* !NULL */


void	cputchar(int c);
int	getchar(void);
int	iscons(int fd);

void	printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);
void	vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list);
int	snprintf(char *str, int size, const char *fmt, ...);
int	vsnprintf(char *str, int size, const char *fmt, va_list);

int	cprintf(const char *fmt, ...);
int	vcprintf(const char *fmt, va_list);

int	printf(const char *fmt, ...);
int	fprintf(int fd, const char *fmt, ...);
int	vfprintf(int fd, const char *fmt, va_list);

char*	readline(const char *prompt);

void _panic(const char *, int, const char*, ...) __attribute__((noreturn));
#define panic(...) _panic(__FILE__, __LINE__, __VA_ARGS__)

#endif
