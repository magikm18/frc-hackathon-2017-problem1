    .text
    .globl info
    .type info, @function
info:
    /* save registers */
    pushq %r9
    pushq %r8
    pushq %rcx

    /* print info */
    leaq info.format1(%rip), %rdi
    movq %rcx, %rsi
    movq %r8, %rdx
    movq %r9, %rcx
    xorl %eax, %eax
    callq printf

    /* restore registers */
    popq %rcx
    popq %r8
    popq %r9
    retq

    .section .rodata
info.format1:
    .string "Width: %llu\nHeight: %llu\nDepth: %llu\n"
