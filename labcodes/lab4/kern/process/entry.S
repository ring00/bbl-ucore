.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
	jalr s0

	jal do_exit
    // pushl %edx              # push arg
    // call *%ebx              # call fn

    // pushl %eax              # save the return value of fn(arg)
    // call do_exit            # call do_exit to terminate current thread

