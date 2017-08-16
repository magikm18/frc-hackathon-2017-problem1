    .text
    .globl main
    .type main, @function
main:
    /* function prologue */
    pushq %rbx
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    pushq %rbp
    movq %rsp, %rbp

    /* check number of arguments */
    cmpq $3, %rdi
    jge main.valid1
    leaq main.invalid1(%rip), %rdi
    callq puts
    movq $1, %rax
    jmp main.ret
main.valid1:

    /* open input file */
    movq $2, %rax
    movq 8(%rsi), %rdi
    pushq %rsi
    movq $2, %rsi
    syscall
    testq %rax, %rax
    jne main.valid2
    movq %rax, %r11
    leaq main.invalid2(%rip), %rdi
    callq puts
    movq %r11, %rax
    jmp main.ret
main.valid2:
    movq %rax, %rbx

    /* open output file */
    popq %rsi
    movq $2, %rax
    movq 16(%rsi), %rdi
    movq $2, %rsi
    syscall
    testq %rax, %rax
    jne main.valid3
    movq %rax, %r11
    leaq main.invalid3(%rip), %rdi
    callq puts
    movq %r11, %rax
    jmp main.ret
main.valid3:
    pushq %rax

    /* get length */
    movq %rbx, %rdi
    movq $5, %rax
    leaq -144(%rsp), %rsi
    syscall
    movq -96(%rsp), %r12

    /* read file */
    callq readall
    testq %rax, %rax
    jne main.ret

    /* close file */
    movq $3, %rax
    movq %rbx, %rdi
    syscall

    /* get metadata */
    callq metadata

    /* print info */
    callq info

    /* run algorithm */
    callq algorithm

    /* print result */
    popq %rsi
    pushq %r11
    movq 16(%rsi), %rdi
    movq $2, %rax
    movq $2, %rsi
    syscall
    movq %rax, %rbp
    popq %r11
    callq result

    /* return zero */
    xorq %rax, %rax

main.ret:
    movq %rbp, %rsp
    popq %rbp
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %rbx
    retq

main.end:
    .size main, .-main

    /* constants */
    .section .rodata
main.invalid1:
    .string "Expected 2 arguments!"
main.invalid2:
    .string "Unable to open input file!"
main.invalid3:
    .string "Unable to open output file!"
