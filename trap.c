#include <x86.h>
#include <util.h>
#include <pmap.h>
#include <console.h>
#include <monitor.h>
#include <stdio.h>
#include <trap.h>
#include <env.h>
#include <sched.h>
#include <spinlock.h>
#include <string.h>

static struct Taskstate ts;

/* For debugging, so print_trapframe can distinguish between printing
 * a saved trapframe and printing the current trapframe and print some
 * additional information in the latter case.
 */
static struct Trapframe *last_tf;

/* Interrupt descriptor table.  (Must be built at run time because
 * shifted function addresses can't be represented in relocation records.)
 */
struct Gatedesc idt[256] = { { 0 } };
struct Pseudodesc idt_pd = {
	sizeof(idt) - 1, (uint32_t) idt
};

int32_t syscall(uint32_t num, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5);



static const char *trapname(int trapno)
{
	static const char * const excnames[] = {
		"Divide error",
		"Debug",
		"Non-Maskable Interrupt",
		"Breakpoint",
		"Overflow",
		"BOUND Range Exceeded",
		"Invalid Opcode",
		"Device Not Available",
		"Double Fault",
		"Coprocessor Segment Overrun",
		"Invalid TSS",
		"Segment Not Present",
		"Stack Fault",
		"General Protection",
		"Page Fault",
		"(unknown trap)",
		"x87 FPU Floating-Point Error",
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
		return excnames[trapno];
	if (trapno == T_SYSCALL)
		return "System call";
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
		return "Hardware Interrupt";
	return "(unknown trap)";
}

void trap_handle0();
void trap_handle1();
void trap_handle2();
void trap_handle3();
void trap_handle4();
void trap_handle5();
void trap_handle6();
void trap_handle7();
void trap_handle8();
void trap_handle10();
void trap_handle11();
void trap_handle12();
void trap_handle13();
void trap_handle14();
void trap_handle16();
void trap_handle17();
void trap_handle18();
void trap_handle19();
void trap_handle_syscall();

void trap_handle_timer();

void
trap_init(void)
{
	extern struct Segdesc gdt[];


	SETGATE(idt[0], 0, GD_KT, trap_handle0, 0);
	SETGATE(idt[1], 0, GD_KT, trap_handle1, 0);
	SETGATE(idt[2], 0, GD_KT, trap_handle2, 0);
	SETGATE(idt[3], 0, GD_KT, trap_handle3, 3);
	SETGATE(idt[4], 0, GD_KT, trap_handle4, 0);
	SETGATE(idt[5], 0, GD_KT, trap_handle5, 0);
	SETGATE(idt[6], 0, GD_KT, trap_handle6, 0);
	SETGATE(idt[7], 0, GD_KT, trap_handle7, 0);
	SETGATE(idt[8], 0, GD_KT, trap_handle8, 0);
	SETGATE(idt[10], 0, GD_KT, trap_handle10, 0);
	SETGATE(idt[11], 0, GD_KT, trap_handle11, 0);
	SETGATE(idt[12], 0, GD_KT, trap_handle12, 0);
	SETGATE(idt[13], 0, GD_KT, trap_handle13, 0);
	SETGATE(idt[14], 0, GD_KT, trap_handle14, 0);
	SETGATE(idt[16], 0, GD_KT, trap_handle16, 0);
	SETGATE(idt[17], 0, GD_KT, trap_handle17, 0);
	SETGATE(idt[18], 0, GD_KT, trap_handle18, 0);
	SETGATE(idt[19], 0, GD_KT, trap_handle19, 0);

	SETGATE(idt[T_SYSCALL], 1, GD_KT, trap_handle_syscall, 3);

	SETGATE(idt[IRQ_OFFSET + IRQ_TIMER], 0, GD_KT, trap_handle_timer, 0);
	// Per-CPU setup
	trap_init_percpu();
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	ts.ts_esp0 = KSTACKTOP;
	ts.ts_ss0 = GD_KD;

	// Initialize the TSS slot of the gdt.
	gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
					sizeof(struct Taskstate), 0);
	gdt[GD_TSS0 >> 3].sd_s = 0;

	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0);

	// Load the IDT
	lidt(&idt_pd);
}

void
print_trapframe(struct Trapframe *tf)
{
	cprintf("TRAP frame at %p\n", tf);
	print_regs(&tf->tf_regs);
	cprintf("  es   0x----%04x\n", tf->tf_es);
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
	// If this trap was a page fault that just happened
	// (so %cr2 is meaningful), print the faulting linear address.
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
		cprintf("  cr2  0x%08x\n", rcr2());
	cprintf("  err  0x%08x", tf->tf_err);
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
		cprintf(" [%s, %s, %s]\n",
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
	else
		cprintf("\n");
	cprintf("  eip  0x%08x\n", tf->tf_eip);
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
	if ((tf->tf_cs & 3) != 0) {
		cprintf("  esp  0x%08x\n", tf->tf_esp);
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
	}
}

void
print_regs(struct PushRegs *regs)
{
	cprintf("  edi  0x%08x\n", regs->reg_edi);
	cprintf("  esi  0x%08x\n", regs->reg_esi);
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
	cprintf("  edx  0x%08x\n", regs->reg_edx);
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
	cprintf("  eax  0x%08x\n", regs->reg_eax);
}

static void
trap_dispatch(struct Trapframe *tf)
{
	// Handle processor exceptions.
	if(tf->tf_trapno == T_PGFLT)
	{
		page_fault_handler(tf);
		return;
	}
	if(tf->tf_trapno == T_BRKPT)
	{
		monitor(tf);
		return;
	}
	if(tf->tf_trapno == T_SYSCALL)
	{
		//cprintf("----Syscall No: 0x%u\n", tf->tf_regs.reg_eax);
		int32_t temp_ret = syscall(tf->tf_regs.reg_eax,
			tf->tf_regs.reg_edx, tf->tf_regs.reg_ecx, tf->tf_regs.reg_ebx,
			tf->tf_regs.reg_edi, tf->tf_regs.reg_esi);
		tf->tf_regs.reg_eax = temp_ret;
		return;
	}

	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
		cprintf("Spurious interrupt on irq 7\n");
		print_trapframe(tf);
		return;
	}

    // Handle clock interrupts. Don't forget to acknowledge the
	// interrupt using lapic_eoi() before calling the scheduler!
	if(tf->tf_trapno == IRQ_OFFSET + IRQ_TIMER)
	{
		//lapic_eoi();
		sched_yield();
		return;
	}

	// Handle keyboard and serial interrupts.
	if(tf->tf_trapno == IRQ_OFFSET + IRQ_KBD)
	{
		kbd_intr();
		return;
	}
	if(tf->tf_trapno == IRQ_OFFSET + IRQ_SERIAL)
	{
		serial_intr();
		return;
	}

	// Unexpected trap: The user process or the kernel has a bug.
	print_trapframe(tf);
	if (tf->tf_cs == GD_KT)
		panic("unhandled trap in kernel");
	else {
		env_destroy(curenv);
		return;
	}
}




void
trap(struct Trapframe *tf)
{
	// The environment may have set DF and some versions
	// of GCC rely on DF being clear
	asm volatile("cld" ::: "cc");


	if ((tf->tf_cs & 3) == 3) {
		// Trapped from user mode.
		// Acquire the big kernel lock before doing any
		// serious kernel work.
		lock_kernel();

		// Garbage collect if current enviroment is a zombie
		if (curenv->env_status == ENV_DYING) {
			env_free(curenv);
			curenv = NULL;
			sched_yield();
		}

		// Copy trap frame (which is currently on the stack)
		// into 'curenv->env_tf', so that running the environment
		// will restart at the trap point.
		curenv->env_tf = *tf;
		// The trapframe on the stack should be ignored from here on.
		tf = &curenv->env_tf;
	}
	// Record that tf is the last real trapframe so
	// print_trapframe can print some additional information.
	last_tf = tf;

	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);

	// If we made it to this point, then no other environment was
	// scheduled, so we should return to the current environment
	// if doing so makes sense.
	if (curenv && curenv->env_status == ENV_RUNNING)
		env_run(curenv);
	else
		sched_yield();
}


void
page_fault_handler(struct Trapframe *tf)
{
	uint32_t fault_va;

	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();

	// Handle kernel-mode page faults.

	if((tf->tf_cs & 0x3) == 0)
		panic("kernel-mode page faults");


	// We've already handled kernel-mode exceptions, so if we get here,
	// the page fault happened in user mode.

	// Call the environment's page fault upcall, if one exists.  Set up a
	// page fault stack frame on the user exception stack (below
	// UXSTACKTOP), then branch to curenv->env_pgfault_upcall.
	//
	// The page fault upcall might cause another page fault, in which case
	// we branch to the page fault upcall recursively, pushing another
	// page fault stack frame on top of the user exception stack.
	//
	// The trap handler needs one word of scratch space at the top of the
	// trap-time stack in order to return.  In the non-recursive case, we
	// don't have to worry about this because the top of the regular user
	// stack is free.  In the recursive case, this means we have to leave
	// an extra word between the current top of the exception stack and
	// the new stack frame because the exception stack _is_ the trap-time
	// stack.
	//
	// If there's no page fault upcall, the environment didn't allocate a
	// page for its exception stack or can't write to it, or the exception
	// stack overflows, then destroy the environment that caused the fault.
	// Note that the grade script assumes you will first check for the page
	// fault upcall and print the "user fault va" message below if there is
	// none.  The remaining three checks can be combined into a single test.
	//
	// Hints:
	//   user_mem_assert() and env_run() are useful here.
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	if(curenv->env_pgfault_upcall)
	{
		// set up a page fault stack frame
		uintptr_t utf_addr;
		if(tf->tf_esp >= UXSTACKTOP - PGSIZE &&
			tf->tf_esp <= UXSTACKTOP - 1)
			utf_addr = tf->tf_esp - sizeof(struct UTrapframe) - 4;
		else
			utf_addr = UXSTACKTOP - sizeof(struct UTrapframe);

		struct UTrapframe * utf = (struct UTrapframe *)utf_addr;

		utf->utf_fault_va 	= fault_va;
		utf->utf_err 		= tf->tf_err;
		utf->utf_regs 		= tf->tf_regs;
		utf->utf_eip 		= tf->tf_eip;
		utf->utf_eflags 	= tf->tf_eflags;
		utf->utf_esp		= tf->tf_esp;

		curenv->env_tf.tf_eip = (uintptr_t)(curenv->env_pgfault_upcall);
		curenv->env_tf.tf_esp = utf_addr;
		env_run(curenv);
	}

	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
		curenv->env_id, fault_va, tf->tf_eip);
	print_trapframe(tf);
	env_destroy(curenv);
}

// Print a string to the system console.
// The string is exactly 'len' characters long.
// Destroys the environment on memory errors.
static void
sys_cputs(const char *s, size_t len)
{

	cprintf("%.*s", len, s);
}

// Read a character from the system console without blocking.
// Returns the character, or 0 if there is no input waiting.
static int
sys_cgetc(void)
{
	return cons_getc();
}

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
	return curenv->env_id;
}

// Destroy a given environment (possibly the currently running environment).
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_destroy(envid_t envid)
{
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
		return r;
	env_destroy(e);
	return 0;
}

// Deschedule current environment and pick a different one to run.
static void
sys_yield(void)
{
	sched_yield();
}

// Allocate a new environment.
// Returns envid of new environment, or < 0 on error.  Errors are:
//	-E_NO_FREE_ENV if no free environment is available.
//	-E_NO_MEM on memory exhaustion.
static envid_t
sys_exofork(void)
{
	// Create the new environment with env_alloc(), from kern/env.c.
	// It should be left as env_alloc created it, except that
	// status is set to ENV_NOT_RUNNABLE, and the register set is copied
	// from the current environment -- but tweaked so sys_exofork
	// will appear to return 0.

	struct Env * new_env;

	int ret_value = env_alloc(&new_env, curenv->env_id);
	if(ret_value < 0)
		return ret_value;

	new_env->env_status = ENV_NOT_RUNNABLE;
	memcpy(&new_env->env_tf, &curenv->env_tf, sizeof(struct Trapframe));
	new_env->env_tf.tf_regs.reg_eax = 0;

	return new_env->env_id;
	// panic("sys_exofork not implemented");
}

// Set envid's env_status to status, which must be ENV_RUNNABLE
// or ENV_NOT_RUNNABLE.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if status is not a valid status for an environment.
static int
sys_env_set_status(envid_t envid, int status)
{
	if(status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE)
		return -E_INVAL;

	struct Env * env_store;
	if(envid2env(envid, &env_store, 1) < 0)
		return -E_BAD_ENV;

	env_store->env_status = status;
	return 0;

}

// Set envid's trap frame to 'tf'.
// tf is modified to make sure that user environments always run at code
// protection level 3 (CPL 3) with interrupts enabled.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	struct Env * env_store;
	if(envid2env(envid, &env_store, 1) < 0)
		return -E_BAD_ENV;
	env_store->env_tf = *tf;
	env_store->env_tf.tf_eflags |= FL_IF;
	return 0;
}

// Set the page fault upcall for 'envid' by modifying the corresponding struct
// Env's 'env_pgfault_upcall' field.  When 'envid' causes a page fault, the
// kernel will push a fault record onto the exception stack, then branch to
// 'func'.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_set_pgfault_upcall(envid_t envid, void *func)
{
	struct Env * env_store;
	if(envid2env(envid, &env_store, 1) < 0)
		return -E_BAD_ENV;
	if (!func)
		return -E_INVAL;

	env_store->env_pgfault_upcall = func;
	//cprintf("[%x] env_pgfault_upcall: 0x%08x\n", env_store->env_id, func);
	return 0;
}

// Allocate a page of memory and map it at 'va' with permission
// 'perm' in the address space of 'envid'.
// The page's contents are set to 0.
// If a page is already mapped at 'va', that page is unmapped as a
// side effect.
//
// perm -- PTE_U | PTE_P must be set, PTE_AVAIL | PTE_W may or may not be set,
//         but no other bits may be set.  See PTE_SYSCALL in inc/mmu.h.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if va >= UTOP, or va is not page-aligned.
//	-E_INVAL if perm is inappropriate (see above).
//	-E_NO_MEM if there's no memory to allocate the new page,
//		or to allocate any necessary page tables.
static int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	struct Env * env_store;

	if(envid2env(envid, &env_store, 1) < 0)
		return -E_BAD_ENV;
	if((uint32_t)va >= UTOP || ((uint32_t)va % PGSIZE != 0))
		return -E_INVAL;

	// check perm
	if(!(perm & PTE_U) || !(perm & PTE_P))
		return -E_INVAL;
	if(perm & ~(PTE_P | PTE_U | PTE_W | PTE_AVAIL))
		return -E_INVAL;

	struct PageInfo * pp = page_alloc(ALLOC_ZERO);
	if(!pp || page_insert(env_store->env_pgdir, pp, va, perm) < 0) {
		page_free(pp);
		return -E_NO_MEM;
	}

	return 0;
}

// Map the page of memory at 'srcva' in srcenvid's address space
// at 'dstva' in dstenvid's address space with permission 'perm'.
// Perm has the same restrictions as in sys_page_alloc, except
// that it also must not grant write access to a read-only
// page.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if srcenvid and/or dstenvid doesn't currently exist,
//		or the caller doesn't have permission to change one of them.
//	-E_INVAL if srcva >= UTOP or srcva is not page-aligned,
//		or dstva >= UTOP or dstva is not page-aligned.
//	-E_INVAL is srcva is not mapped in srcenvid's address space.
//	-E_INVAL if perm is inappropriate (see sys_page_alloc).
//	-E_INVAL if (perm & PTE_W), but srcva is read-only in srcenvid's
//		address space.
//	-E_NO_MEM if there's no memory to allocate any necessary page tables.
static int
sys_page_map(envid_t srcenvid, void *srcva,
	     envid_t dstenvid, void *dstva, int perm)
{
	struct Env * srcenv_store;
	if(envid2env(srcenvid, &srcenv_store, 1) < 0)
		return -E_BAD_ENV;
	struct Env * dstenv_store;
	if(envid2env(dstenvid, &dstenv_store, 1) < 0)
		return -E_BAD_ENV;

	if((uint32_t)srcva >= UTOP || ((uint32_t)srcva % PGSIZE != 0) ||
		(uint32_t)dstva >= UTOP || ((uint32_t)dstva % PGSIZE != 0))
		return -E_INVAL;

	// check perm
	if(!(perm & PTE_U) || !(perm & PTE_P))
		return -E_INVAL;
	if(perm & ~(PTE_P | PTE_U | PTE_W | PTE_AVAIL))
		return -E_INVAL;

	pte_t * pte_store;
	struct PageInfo * pp = page_lookup(srcenv_store->env_pgdir,
		srcva, &pte_store);
	if(!pp)	// srcva is not mapped in srcenvid's address space.
		return -E_INVAL;

	if((perm & PTE_W) && ((int)pte_store & PTE_W))
		return -E_INVAL;

	if(page_insert(dstenv_store->env_pgdir, pp, dstva, perm) < 0)
		return -E_NO_MEM;

	return 0;
}

// Unmap the page of memory at 'va' in the address space of 'envid'.
// If no page is mapped, the function silently succeeds.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if va >= UTOP, or va is not page-aligned.
static int
sys_page_unmap(envid_t envid, void *va)
{
	struct Env * env_store;
	if(envid2env(envid, &env_store, 1) < 0)
		return -E_BAD_ENV;
	if((uint32_t)va >= UTOP || ((uint32_t)va % PGSIZE != 0))
		return -E_INVAL;

	page_remove(env_store->env_pgdir, va);
	return 0;

}


// Try to send 'value' to the target env 'envid'.
// If srcva < UTOP, then also send page currently mapped at 'srcva',
// so that receiver gets a duplicate mapping of the same page.
//
// The send fails with a return value of -E_IPC_NOT_RECV if the
// target is not blocked, waiting for an IPC.
//
// The send also can fail for the other reasons listed below.
//
// Otherwise, the send succeeds, and the target's ipc fields are
// updated as follows:
//    env_ipc_recving is set to 0 to block future sends;
//    env_ipc_from is set to the sending envid;
//    env_ipc_value is set to the 'value' parameter;
//    env_ipc_perm is set to 'perm' if a page was transferred, 0 otherwise.
// The target environment is marked runnable again, returning 0
// from the paused sys_ipc_recv system call.  (Hint: does the
// sys_ipc_recv function ever actually return?)
//
// If the sender wants to send a page but the receiver isn't asking for one,
// then no page mapping is transferred, but no error occurs.
// The ipc only happens when no errors occur.
//
// Returns 0 on success, < 0 on error.
// Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist.
//		(No need to check permissions.)
//	-E_IPC_NOT_RECV if envid is not currently blocked in sys_ipc_recv,
//		or another environment managed to send first.
//	-E_INVAL if srcva < UTOP but srcva is not page-aligned.
//	-E_INVAL if srcva < UTOP and perm is inappropriate
//		(see sys_page_alloc).
//	-E_INVAL if srcva < UTOP but srcva is not mapped in the caller's
//		address space.
//	-E_INVAL if (perm & PTE_W), but srcva is read-only in the
//		current environment's address space.
//	-E_NO_MEM if there's not enough memory to map srcva in envid's
//		address space.
static int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, unsigned perm)
{
	int r;
	struct Env * env_store;
	if((r = envid2env(envid, &env_store, 0)) < 0)
		return r;
	if(env_store->env_ipc_recving == 0)
		return -E_IPC_NOT_RECV;
	env_store->env_ipc_recving = 0;

	if((uint32_t)srcva < UTOP)
	{
		// not page align
		if(srcva != ROUNDDOWN(srcva, PGSIZE))
			return -E_INVAL;
		// check perm
		if(!(perm & PTE_U) || !(perm & PTE_P))
			return -E_INVAL;
		if(perm & ~(PTE_P | PTE_U | PTE_W | PTE_AVAIL))
			return -E_INVAL;

		pte_t * pte;
		struct PageInfo * pp = page_lookup(curenv->env_pgdir, srcva, &pte);
		// not mapped in the caller's address space
		if(!pp)
			return -E_INVAL;
		// PTE_W  but srcav is read-only
		if((perm & PTE_W) && !(*pte & PTE_W))
			return -E_INVAL;
		if((uint32_t)env_store->env_ipc_dstva < UTOP)
		{
			if((r = page_insert(env_store->env_pgdir, pp,
				env_store->env_ipc_dstva, perm)) < 0)
			{	// there's no enough memory
				env_store->env_ipc_perm = 0;
				return r;
			}
			env_store->env_ipc_perm = perm;
		}
	}

	env_store->env_ipc_from = curenv->env_id;
	env_store->env_ipc_value = value;
	env_store->env_status = ENV_RUNNABLE;
	env_store->env_tf.tf_regs.reg_eax = 0;
	return 0;

}

// Block until a value is ready.  Record that you want to receive
// using the env_ipc_recving and env_ipc_dstva fields of struct Env,
// mark yourself not runnable, and then give up the CPU.
//
// If 'dstva' is < UTOP, then you are willing to receive a page of data.
// 'dstva' is the virtual address at which the sent page should be mapped.
//
// This function only returns on error, but the system call will eventually
// return 0 on success.
// Return < 0 on error.  Errors are:
//	-E_INVAL if dstva < UTOP but dstva is not page-aligned.
static int
sys_ipc_recv(void *dstva)
{
	if((uint32_t)dstva < UTOP &&
		(uint32_t)dstva % PGSIZE)
		return -E_INVAL;

	curenv->env_ipc_recving = 1;
	curenv->env_ipc_dstva = dstva;
	curenv->env_status = ENV_NOT_RUNNABLE;
	sched_yield();
	return 0;
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2,
	uint32_t a3, uint32_t a4, uint32_t a5)
{
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.

	// panic("syscall not implemented");

	switch (syscallno) {
	default:
// <<<<<<< HEAD
		return -E_INVAL;
// =======
		// return -E_NO_SYS;
	case SYS_cputs:
		sys_cputs((const char *)a1, (size_t)a2);
		return 0;
	case SYS_cgetc:
		return sys_cgetc();
	case SYS_getenvid:
		return (int32_t)sys_getenvid();
	case SYS_env_destroy:
		return sys_env_destroy((envid_t)a1);
	case SYS_yield:
		sys_yield();
		return 0;
	case SYS_exofork:
		return sys_exofork();
	case SYS_env_set_status:
		return sys_env_set_status((envid_t)a1, (int)a2);
	case SYS_page_alloc:
		return sys_page_alloc((envid_t)a1, (void *)a2, (int)a3);
	case SYS_page_map:
		return sys_page_map((envid_t)a1, (void *)a2,
			(envid_t)a3, (void *)a4, (int)a5);
	case SYS_page_unmap:
		return sys_page_unmap((envid_t)a1, (void *)a2);
	case SYS_env_set_pgfault_upcall:
		return sys_env_set_pgfault_upcall((envid_t)a1, (void *)a2);
	case SYS_ipc_try_send:
		return sys_ipc_try_send((envid_t)a1, (uint32_t)a2,
			(void *)a3, (unsigned)a4);
	case SYS_ipc_recv:
		return sys_ipc_recv((void *)a1);
	case SYS_env_set_trapframe:
		return sys_env_set_trapframe((envid_t)a1, (struct Trapframe *)a2);
	}
}
