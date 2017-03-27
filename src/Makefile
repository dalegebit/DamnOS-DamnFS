
CC = gcc
AS = gas
LD = ld
OBJCOPY = $(TOOLPREFIX)objcopy
OBJDUMP = $(TOOLPREFIX)objdump
#CFLAGS = -fno-pic -static -fno-builtin -fno-strict-aliasing -O2 -Wall -MD -ggdb -m32 -Werror -fno-omit-frame-pointer
CFLAGS = -fno-pic -static -fno-builtin -fno-strict-aliasing -w -Wall  -MD -m32 -fno-omit-frame-pointer -I.
CFLAGS += $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)
#CFLAGS += -g -gdwarf-2
CFLAGS += -Os
ASFLAGS = -m32 -gdwarf-2 -I. -Wa,-divide
# FreeBSD ld wants ``elf_i386_fbsd''
LDFLAGS := -m elf_i386


KERN_SRCFILES :=	entry.S \
					entrypgdir.c \
					pmap.c \
					init.c \
					console.c \
					monitor.c \
					trapentry.S \
					trap.c \
					sched.c \
					picirq.c \
					env.c \
					spinlock.c \
					stdio.c \
					string.c


HEAD_SRCFILES :=	uentry.S \


LIB_SRCFILES := 	string.c \
					libmain.c \
					syscall.c \
					uconsole.c \
					fd.c \
					file.c \
					pipe.c \
					ipc.c \
					fork.c \
					wait.c \
					spawn.c \
					exit.c \
					pageref.c \
					args.c \
					pfentry.S \
					pgfault.c

FS_SRCFILES :=		damnfs.c \
					ide.c \
					serv.c


KERN_SRCFILES := $(wildcard $(KERN_SRCFILES))
USER_SRCFILES := $(wildcard $(USER_SRCFILES))
HEAD_SRCFILES := $(wildcard $(HEAD_SRCFILES))
LIB_SRCFILES  := $(wildcard $(LIB_SRCFILES))



KERN_OBJFILES := $(patsubst %.c, %.o, $(KERN_SRCFILES))
KERN_OBJFILES := $(patsubst %.S, %.o, $(KERN_OBJFILES))



HEAD_OBJFILES := $(patsubst %.c, %.o, $(HEAD_SRCFILES))
HEAD_OBJFILES := $(patsubst %.S, %.o, $(HEAD_OBJFILES))

LIB_OBJFILES := $(patsubst %.c, %.o, $(LIB_SRCFILES))
LIB_OBJFILES := $(patsubst %.S, %.o, $(LIB_OBJFILES))
LIB_OBJFILES += ustdio.o

FS_OBJFILES := $(patsubst %.c, %.o, $(FS_SRCFILES))

damn.img: bootblock kernel
	dd if=/dev/zero of=damn.img count=6144
	dd if=bootblock of=damn.img conv=notrunc
	dd if=kernel of=damn.img seek=1 conv=notrunc
	cloc .

bootblock: boot.S main.c
	$(CC) $(CFLAGS) -fno-pic -O -nostdinc -I. -c main.c
	$(CC) $(CFLAGS) -fno-pic -nostdinc -I. -c boot.S
	$(LD) $(LDFLAGS) -N -e start -Ttext 0x7C00 -o bootblock.o boot.o  main.o
	$(OBJCOPY) -S -O binary -j .text bootblock.o bootblock
	$(OBJDUMP) -S bootblock.o > bootblock.asm
	./sign.pl bootblock

kernel: $(KERN_OBJFILES) kernel.ld damnfs sh
	$(LD) $(LDFLAGS) -T kernel.ld -I. -o kernel $(KERN_OBJFILES) -b binary damnfs sh
	$(OBJDUMP) -S kernel > kernel.asm

$(LIB_OBJFILES): $(LIB_SRCFILES) stdio.c
	$(CC) $(CFLAGS) -O -nostdinc -I. -D__FOR_USER__ -c $(LIB_SRCFILES)
	$(CC) $(CFLAGS) -O -nostdinc -I. -D__FOR_USER__ -c stdio.c -o ustdio.o

libdamn.a:	$(LIB_OBJFILES)
	ar r libdamn.a $(LIB_OBJFILES)

$(FS_OBJFILES): $(FS_SRCFILES)
	$(CC) $(CFLAGS) -O -nostdinc -nostdlib -I. -L. -D__FOR_USER__ -c $(FS_SRCFILES) -ldamn


$(HEAD_OBJFILES): $(HEAD_SRCFILES)
	$(CC) $(CFLAGS) -O -nostdinc -I. -D__FOR_USER__ -c $(HEAD_SRCFILES)

damnfs: $(HEAD_OBJFILES) $(FS_OBJFILES) libdamn.a user.ld
	$(LD) $(LD_FLAGS) -T user.ld -I. -L. -o damnfs $(HEAD_OBJFILES) $(FS_OBJFILES) -ldamn
	$(OBJDUMP) -S damnfs > damnfs.asm

sh: $(HEAD_OBJFILES) sh.c libdamn.a
	$(CC) $(CFLAGS) -O -nostdinc -I. -D__FOR_USER__ -c sh.c
	$(LD) $(LD_FLAGS) -T user.ld -nostdlib -I. -L. -o sh $(HEAD_OBJFILES) sh.o -ldamn


fs.img:
	dd if=/dev/zero of=fs.img count=32784
	./dmkfs


clean:
	rm *.o *.d
	rm bootblock kernel damnfs sh
	rm damn.img

all: damn.img fs.img

ifndef QEMU
QEMU = $(shell if which qemu > /dev/null; \
	then echo qemu; exit; \
	elif which qemu-system-i386 > /dev/null; \
	then echo qemu-system-i386; exit; \
	else \
	qemu=/Applications/Q.app/Contents/MacOS/i386-softmmu.app/Contents/MacOS/i386-softmmu; \
	if test -x $$qemu; then echo $$qemu; exit; fi; fi; \
	echo "***" 1>&2; \
	echo "*** Error: Couldn't find a working QEMU executable." 1>&2; \
	echo "*** Is the directory containing the qemu binary in your PATH" 1>&2; \
	echo "*** or have you tried setting the QEMU variable in Makefile?" 1>&2; \
	echo "***" 1>&2; exit 1)
endif

QEMUOPTS = -hda damn.img -hdb fs.img -m 8 $(QEMUEXTRA)
GDBPORT = $(shell expr `id -u` % 5000 + 25000)
QEMUGDB = $(shell if $(QEMU) -help | grep -q '^-gdb'; \
	then echo "-gdb tcp::$(GDBPORT)"; \
	else echo "-s -p $(GDBPORT)"; fi)

qemu: damn.img fs.img
	$(QEMU) -nographic -serial mon:stdio $(QEMUOPTS)
qemu-gdb: damn.img .gdbinit
	@echo "*** Now run 'gdb'." 1>&2
	$(QEMU) -nographic -serial mon:stdio $(QEMUOPTS) -S $(QEMUGDB)
gdb:
	gdb -x .gdbinit
