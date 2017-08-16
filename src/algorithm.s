    .text
    .globl algorithm
    .type algorithm, @function
algorithm:
    /* save registers */
    push %rax
    push %r9
    push %r8
    push %rcx

    /* allocate data buffer */
    mov %r12, %rdi
    shr $3, %rdi
    inc %rdi
    call malloc
    mov %rax, %r13

    /* calculate maximum number of leads */
    mov (%rsp), %rax
    mulq 8(%rsp)
    mulq 16(%rsp)

    /* allocate lead pointer buffers */
    lea (,%rax,8), %rdi
    mov %rdi, %rbx
    call malloc
    movq $0, (%rax)
    mov %rax, 24(%rsp)
    mov %rbx, %rdi
    call malloc
    mov %rax, %r14

    /* allocate lead linked list node buffer */
    lea (,%rbx,8), %rdi
    lea (,%rdi,8), %rdi
    call malloc
    mov %rax, %rbp

    /* restore registers */
    pop %rcx
    pop %r8
    pop %r9

    /* initialize data buffer */
    push (%rsp)
    mov $0, %rax
    mov %r12, %rdx
    shr $3, %rdx
algorithm.loop1:
    movb $0, (%r13,%rax)
    inc %rax
    cmp %rdx, %rax
    jle algorithm.loop1

    /* find start position */
    mov $0, %rax
algorithm.loop2:
    cmpb $0x53, (%r15,%rax)
    je algorithm.break2
    inc %rax
    jmp algorithm.loop2
algorithm.break2:

    /* create first node and initialize lead vector */
    bts %rax, (%r13)
    movq $0, (%rbp)
    mov %eax, 8(%rbp)
    movl $6, 12(%rbp)
    mov %rbp, (%r14)
    movq $0, 8(%r14)
    lea 16(%rbp), %rbp

    /* main loop */
    push $0
algorithm.loop3:
    incq (%rsp)

    /* loop through leads */
    mov $0, %r10
algorithm.loop4:
    mov (%r14,%r10,8), %r11
    inc %r10
    test %r11, %r11
    je algorithm.break4

    /* lead is active; get character and decode coordinates */
    mov 8(%r11), %eax
    and $-1, %rax
    call decode
    mov 8(%r11), %esi
    and $-1, %rsi

    /* try to go left */
    push $0
    test %rdx, %rdx
    je algorithm.skip1
    dec %rsi
    call addmaybe
    inc %rsi
algorithm.skip1:

    /* try to go right */
    inc %rdx
    cmp %rcx, %rdx
    jge algorithm.skip2
    movq $1, (%rsp)
    inc %rsi
    call addmaybe
    dec %rsi
algorithm.skip2:
    dec %rdx

    /* try to go up */
    test %rax, %rax
    je algorithm.skip3
    movq $2, (%rsp)
    sub %rcx, %rsi
    dec %rsi
    call addmaybe
    lea 1(%rsi,%rcx), %rsi
algorithm.skip3:

    /* try to go down */
    inc %rax
    cmp %r8, %rax
    jge algorithm.skip4
    movq $3, (%rsp)
    lea 1(%rsi,%rcx), %rsi
    call addmaybe
    dec %rsi
    sub %rcx, %rsi
algorithm.skip4:
    dec %rax

    /* try to level down */
    cmpb $0x7A, (%r15,%rsi)
    jne algorithm.skip5
    movq $4,(%rsp)
    push %rdx
    push %rax
    mov 24(%rsp), %rax
    dec %rax
    push %rax
    call encode
    mov %rax, %rsi
    lea 8(%rsp), %rsp
    pop %rax
    pop %rdx
    call addmaybe
    push %rdx
    push %rax
    push 24(%rsp)
    call encode
    mov %rax, %rsi
    lea 8(%rsp), %rsp
    pop %rax
    pop %rdx
algorithm.skip5:

    /* try to level up */
    cmpb $0x5A, (%r15,%rsi)
    jne algorithm.skip6
    movq $5,(%rsp)
    push %rdx
    push %rax
    mov 24(%rsp), %rax
    inc %rax
    push %rax
    call encode
    mov %rax, %rsi
    lea 8(%rsp), %rsp
    pop %rax
    pop %rdx
    call addmaybe
    push %rdx
    push %rax
    push 24(%rsp)
    call encode
    mov %rax, %rsi
    lea 8(%rsp), %rsp
    pop %rax
    pop %rdx
algorithm.skip6:

    /* back to the top */
    lea 16(%rsp), %rsp
    jmp algorithm.loop4

    /* swap lead pointer buffers and restart main loop */
algorithm.break4:
    movq $0, (%r14)
    mov %r14, 8(%rsp)
    xchg 16(%rsp), %r14
    jmp algorithm.loop3

    /* reset stack pointer and return */
algorithm.ret:
    lea 24(%rsp), %rsp
    ret

    .section .rodata
algorithm.format1:
    .string "%llu\n"
