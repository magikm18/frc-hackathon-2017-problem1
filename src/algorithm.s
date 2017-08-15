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
    lea (,%r12,2), %rdi
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
algorithm.loop1:
    movw $-1, (%r13,%rax,2)
    inc %rax
    cmp %r12, %rax
    jl algorithm.loop1

    /* find start position */
    mov $0, %rax
algorithm.loop2:
    mov (%r15,%rax), %dl
    cmp $0x53, %dl
    je algorithm.break2
    inc %rax
    jmp algorithm.loop2
algorithm.break2:

    /* create first node and initialize lead vector */
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
    cmp $-1, %r11
    je algorithm.loop4
    test %r11, %r11
    je algorithm.break4

    /* lead is active - check if at end */
    mov 8(%r11), %eax
    and $-1, %rax
    mov (%r15,%rax), %bl
    cmp $0x58, %bl
    je algorithm.ret

    /* decode coodrinates */
    call decode
    mov 8(%r11), %esi
    and $-1, %rsi

    /* try to go left */
    push $0
    test %rdx, %rdx
    je algorithm.skip1
    dec %rsi
    dec %rdx
    call addmaybe
    inc %rdx
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
    dec %rax
    call addmaybe
    inc %rax
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
