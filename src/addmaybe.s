    .text
    .globl addmaybe
    .type addmaybe, @function
addmaybe:
    /* check if already visited */
    cmpw $-1, (%r13,%rsi,2)
    jne addmaybe.ret

    /* load target character and analyze */
    mov (%r15,%rsi), %bl
    shl $8, %bx
    cmp $0x23, %bh
    je addmaybe.ret
    cmp $0x7A, %bh
    jne addmaybe.skip1
    mov $4, %bl
    jmp addmaybe.skip3
addmaybe.skip1:
    cmp $0x5A, %bh
    jne addmaybe.skip2
    mov $5, %bl
    jmp addmaybe.skip3
addmaybe.skip2:
    cmp $0x20, %bh
    je addmaybe.skip3
    cmp $0x58, %bh
    jne addmaybe.ret

    /* normal target; update data buffer */
addmaybe.skip3:
    mov 24(%rsp), %di
    mov %di, (%r13,%rsi,2)

    /* add new node */
    mov %r11, (%rbp)
    mov %esi, 8(%rbp)
    mov 8(%rsp), %edi
    mov %edi, 12(%rbp)

    /* add another node if this is a level transfer tile */
    test %bl, %bl
    je addmaybe.skip8
    push %r10
    push %rdx
    push %rax
    mov 32(%rsp), %r10
addmaybe.loop1:
    mov %rbp, 16(%rbp)
    lea 16(%rbp), %rbp
    movzb %bl, %eax
    mov %eax, 12(%rbp)

    /* calculate new offset */
    test $0x1, %bl
    je addmaybe.skip4
    inc %r10
    jmp addmaybe.skip5
addmaybe.skip4:
    dec %r10
addmaybe.skip5:
    push %r10
    call encode
    mov %eax, 8(%rbp)
    mov 48(%rsp), %di
    mov %di, (%r13,%rsi,2)
    lea 8(%rsp), %rsp
    shl $8, %bx
    mov (%r15,%rax), %bl
    xchg %bl, %bh
    test $0x1, %bl
    je addmaybe.skip6
    cmp $0x5A, %bh
    je addmaybe.loop1
    jmp addmaybe.skip7
addmaybe.skip6:
    cmp $0x7A, %bh
    je addmaybe.loop1
addmaybe.skip7:
    pop %rax
    pop %rdx
    pop %r10
    call pushlead
    jmp addmaybe.ret

    /* push lead before returning */
addmaybe.skip8:
    call pushlead

    /* return */
addmaybe.ret:
    ret
