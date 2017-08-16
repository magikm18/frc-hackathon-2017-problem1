    .text
    .globl metadata
    .type metadata, @function
metadata:
    /* count columns */
    movq $0, %rax
metadata.loop1:
    movb (%r15,%rax), %dl
    cmpb $0x0A, %dl
    je metadata.break1
    incq %rax
    jmp metadata.loop1
metadata.break1:

    /* count rows */
    incq %rax
    movq %rax, %rcx
    movq $1, %r8
metadata.loop2:
    movb (%r15,%rax), %dl
    cmpb $0x0A, %dl
    je metadata.break2
    cmpq %r12, %rax
    jl metadata.continue2
    movq $1, %r9
    retq
metadata.continue2:
    incq %r8
    addq %rcx, %rax
    jmp metadata.loop2
metadata.break2:
    decq %rcx

    /* count levels */
    incq %rax
    movq $0, %rdx
    movq %rax, %rsi
    movq %r12, %rax
    divq %rsi
    movq %rax, %r9
    subq %rdx, %rsi
    cmpq $2, %rsi
    jg metadata.skip1
    cmpq $0, %rsi
    je metadata.skip1
    incq %r9
metadata.skip1:
    retq

    .section .rodata
format:
    .string "%llx\n"
