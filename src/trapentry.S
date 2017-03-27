/* See COPYRIGHT for copyright information. */

#include <util.h>
#include <trap.h>

#include <picirq.h>


###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(trap_handle0, 0)
TRAPHANDLER_NOEC(trap_handle1, 1)
TRAPHANDLER_NOEC(trap_handle2, 2)
TRAPHANDLER_NOEC(trap_handle3, 3)
TRAPHANDLER_NOEC(trap_handle4, 4)
TRAPHANDLER_NOEC(trap_handle5, 5)
TRAPHANDLER_NOEC(trap_handle6, 6)
TRAPHANDLER_NOEC(trap_handle7, 7)
TRAPHANDLER(trap_handle8, 8)
TRAPHANDLER(trap_handle10, 10)
TRAPHANDLER(trap_handle11, 11)
TRAPHANDLER(trap_handle12, 12)
TRAPHANDLER(trap_handle13, 13)
TRAPHANDLER(trap_handle14, 14)
TRAPHANDLER_NOEC(trap_handle16, 16)
TRAPHANDLER(trap_handle17, 17)
TRAPHANDLER_NOEC(trap_handle18, 18)
TRAPHANDLER_NOEC(trap_handle19, 19)

TRAPHANDLER_NOEC(trap_handle_syscall, T_SYSCALL)

TRAPHANDLER_NOEC(trap_handle_timer, IRQ_OFFSET + IRQ_TIMER)



_alltraps:
	pushl %ds
	pushl %es
	pushal

	movw $(GD_KD), %ax
	movw %ax, %ds
	movw %ax, %es

	pushl %esp
	call trap
