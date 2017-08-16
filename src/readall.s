    .text
    .globl readall
    .type readall, @function
readall:
    /* read entire file onto heap */
    movq %r12, %rdi
    callq malloc
    movq %rax, %r15
    movq %rbx, %rdi
    movq %r12, %rdx
    movq %r15, %rsi
readall.loop1:
    movq $0, %rax
    syscall
    cmpq $-4095, %rax
    jb readall.valid1
    pushq %rax
    leaq readall.invalid1(%rip), %rdi
    callq puts
    popq %rax
    negq %rax
    retq
readall.valid1:
    addq %rax, %rsi
    subq %rax, %rdx
    jg readall.loop1
    xorq %rax, %rax
    retq

    .section .rodata
readall.invalid1:
    .string "Unable to read from input file!"
