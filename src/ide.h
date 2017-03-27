#ifndef __IDE
#define __IDE
#include <x86.h>

#define IDE_BSY		0x80
#define IDE_DRDY	0x40
#define IDE_DF		0x20
#define IDE_ERR		0x01


bool ide_probe_disk1(void);

void ide_set_disk(int d);

int ide_read(uint32_t secno, void *dst, size_t nsecs);

int ide_write(uint32_t secno, const void *src, size_t nsecs);


#endif
