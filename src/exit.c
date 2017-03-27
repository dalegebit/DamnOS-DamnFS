
#include <syslib.h>

void
exit(void)
{
	close_all();
	sys_env_destroy(0);
}

