    .text
    .globl addmaybe
    .type addmaybe, @function
addmaybe:
    /* check if already visited */
    btsq %rsi, (%r13)
    jc addmaybe.ret

    /* load target character and analyze */
    movb (%r15,%rsi), %bl
    shlw $8, %bx
    movb 8(%rsp), %bl
    cmpb $0x23, %bh
    je addmaybe.ret
    cmpb $0x20, %bh
    je addmaybe.skip1
    cmpb $0x7A, %bh
    je addmaybe.skip1
    cmpb $0x5A, %bh
    je addmaybe.skip1
    cmpb $0x58, %bh
    jne addmaybe.ret

    /* found the exit, set a flag */
    orb $0x80, %bl

    /* normal target; add new node */
addmaybe.skip1:
    movq %r11, (%rbp)
    movl %esi, 8(%rbp)
    movzbl %bl, %edi
    movl %edi, 12(%rbp)

    /* check if exit flag set */
    testb %bl, %bl
    jns addmaybe.skip2

    /* this is the exit; remove exit flag from node and print results */
    movq %rbp, %r11
    andq $0x7F, 12(%rbp)
    movq 56(%rsp), %rbp
    jmp result
addmaybe.skip2:

    /* push lead and return */
    callq pushlead
addmaybe.ret:
    retq
