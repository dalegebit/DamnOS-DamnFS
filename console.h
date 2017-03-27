#ifndef __CONSOLE
#define __CONSOLE

#define MONO_BASE	0x3B4
#define MONO_BUF	0xB0000
#define CGA_BASE	0x3D4
#define CGA_BUF		0xB8000

#define CRT_ROWS	25
#define CRT_COLS	80
#define CRT_SIZE	(CRT_ROWS * CRT_COLS)

void cons_init(void);
int cons_getc(void);
void printstr(char * str);

void kbd_intr(void);
void serial_intr(void);

int iscons(int fdnum);

#endif
