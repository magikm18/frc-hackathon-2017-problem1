    .text
    .globl result
    .type result, @function
result:
    /* accumulate steps on the stack */
    push $7
    mov $0, %rdx
result.loop1:
    mov 12(%r11), %eax
    push %rax
    mov (%r11), %r11
    inc %rdx
    test %r11, %r11
    jne result.loop1

    /* truncate file */
    mov $77, %rax
    mov %rbp, %rdi
    mov %rdx, %rsi
    syscall

    /* diplay steps in order */
result.loop2:
    pop %r10
    lea result.chars(%rip), %rdx
    movzb (%rdx,%r10), %rsi
    mov %rsi, -8(%rsp)
    lea -8(%rsp), %rsi
    mov %rbp, %rdi
    mov $1, %rdx
    mov $1, %rax
    syscall
    cmp $7, %r10
    jne result.loop2

    /* print newline, close file, and exit */
    mov $1, %rax
    mov %rbp, %rdi
    mov $1, %rdx
    movq $0x0A, -8(%rsp)
    lea -8(%rsp), %rsi
    syscall
    mov $3, %rax
    mov %rbp, %rdi
    syscall
    mov $60, %rax
    mov $0, %rdi
    syscall

    .section .rodata
result.chars:
    .ascii "<>^vzZSX"
