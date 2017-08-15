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

    /* diplay steps in order */
result.loop2:
    pop %rax
    cmp $7, %rax
    je result.break2
    lea result.chars(%rip), %rdx
    movzb (%rdx,%rax), %rsi
    mov %rsi, -8(%rsp)
    lea -8(%rsp), %rsi
    mov %rbp, %rdi
    mov $1, %rdx
    mov $1, %rax
    syscall
    jmp result.loop2
result.break2:

    /* print newline and exit */
    mov $1, %rax
    mov %rbp, %rdi
    mov $1, %rdx
    movq $0x0A, -8(%rsp)
    lea -8(%rsp), %rsi
    syscall
    ret

    .section .rodata
result.chars:
    .ascii "<>^vzZS"
