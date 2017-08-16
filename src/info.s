    .text
    .globl info
    .type info, @function
info:
    /* save registers */
    push %r9
    push %r8
    push %rcx

    /* print info */
    lea info.format1(%rip), %rdi
    mov %rcx, %rsi
    mov %r8, %rdx
    mov %r9, %rcx
    xor %eax, %eax
    call printf

    /* restore registers */
    pop %rcx
    pop %r8
    pop %r9
    ret

    .section .rodata
info.format1:
    .string "Width: %llu\nHeight: %llu\nDepth: %llu\n"
