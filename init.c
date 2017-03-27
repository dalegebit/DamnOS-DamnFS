#include <x86.h>
#include <util.h>
#include <string.h>
#include <stdio.h>

#include <console.h>
#include <pmap.h>
#include <monitor.h>
#include <trap.h>
#include <env.h>
#include <picirq.h>
#include <sched.h>
#include <spinlock.h>


void
i386_init(void)
{
	extern char edata[], end[];

	memset(edata, 0, end - edata);

	cons_init();

	mem_init();

	env_init();
	trap_init();

	pic_init();

	ENV_CREATE(damnfs, ENV_TYPE_FS);
	ENV_CREATE(sh, ENV_TYPE_USER);

	sched_yield();

	halt();
}
