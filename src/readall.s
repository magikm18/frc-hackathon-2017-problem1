    .text
    .globl readall
    .type readall, @function
readall:
    /* read entire file onto heap */
    mov %r12, %rdi
    call malloc
    mov %rax, %r15
    mov %rbx, %rdi
    mov %r12, %rdx
    mov %r15, %rsi
readall.loop1:
    mov $0, %rax
    syscall
    cmp $-4095, %rax
    jnae readall.valid1
    push %rax
    lea readall.invalid1(%rip), %rdi
    call puts
    pop %rax
    neg %rax
    ret
readall.valid1:
    add %rax, %rsi
    sub %rax, %rdx
    jg readall.loop1
    mov $0, %rax
    ret

    .section .rodata
readall.invalid1:
    .string "Unable to read from input file!"
