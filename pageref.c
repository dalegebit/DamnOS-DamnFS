#include <syslib.h>

int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
		return 0;
	pte = uvpt[PGNUM(v)];
	// cprintf("pageref pte:0x%08x\n", pte);
	if (!(pte & PTE_P))
		return 0;
	// cprintf("pageref 0x%08x: %d\n", v, pages[PGNUM(pte)].pp_ref);
	return pages[PGNUM(pte)].pp_ref;
}
