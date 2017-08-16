    .text
    .globl result
    .type result, @function
result:
    /* accumulate steps on the stack */
    pushq $7
    xorq %rdx, %rdx
result.loop1:
    movl 12(%r11), %eax
    pushq %rax
    movq (%r11), %r11
    incq %rdx
    testq %r11, %r11
    jne result.loop1

    /* truncate file */
    movq $77, %rax
    movq %rbp, %rdi
    movq %rdx, %rsi
    syscall

    /* diplay steps in order */
result.loop2:
    popq %r10
    leaq result.chars(%rip), %rdx
    movzbq (%rdx,%r10), %rsi
    movq %rsi, -8(%rsp)
    leaq -8(%rsp), %rsi
    movq %rbp, %rdi
    movq $1, %rdx
    movq $1, %rax
    syscall
    cmpq $7, %r10
    jne result.loop2

    /* print newline, close file, and exit */
    movq $1, %rax
    movq %rbp, %rdi
    movq $1, %rdx
    movq $0x0A, -8(%rsp)
    leaq -8(%rsp), %rsi
    syscall
    movq $3, %rax
    movq %rbp, %rdi
    syscall
    movq $60, %rax
    xorq %rdi, %rdi
    syscall

    .section .rodata
result.chars:
    .ascii "<>^vzZSX"
