    .text
    .globl addmaybe
    .type addmaybe, @function
addmaybe:
    /* check if already visited */
    bts %rsi, (%r13)
    jc addmaybe.ret

    /* load target character and analyze */
    mov (%r15,%rsi), %bl
    shl $8, %bx
    mov 8(%rsp), %bl
    cmp $0x23, %bh
    je addmaybe.ret
    cmp $0x20, %bh
    je addmaybe.skip1
    cmp $0x7A, %bh
    je addmaybe.skip1
    cmp $0x5A, %bh
    je addmaybe.skip1
    cmp $0x58, %bh
    jne addmaybe.ret

    /* found the exit, set a flag */
    or $0x80, %bl

    /* normal target; add new node */
addmaybe.skip1:
    mov %r11, (%rbp)
    mov %esi, 8(%rbp)
    movzb %bl, %edi
    mov %edi, 12(%rbp)

    /* check if exit flag set */
    test %bl, %bl
    jns addmaybe.skip2

    /* this is the exit; remove exit flag from node and print results */
    mov %rbp, %r11
    and $0x7F, 12(%rbp)
    mov 56(%rsp), %rbp
    jmp result
addmaybe.skip2:

    /* push lead and return */
    call pushlead
addmaybe.ret:
    ret
