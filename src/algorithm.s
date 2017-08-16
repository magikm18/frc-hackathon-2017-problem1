    .text
    .globl algorithm
    .type algorithm, @function
algorithm:
    /* save registers */
    pushq %rax
    pushq %r9
    pushq %r8
    pushq %rcx

    /* allocate data buffer */
    movq %r12, %rdi
    shrq $3, %rdi
    incq %rdi
    callq malloc
    movq %rax, %r13

    /* calculate maximum number of leads */
    movq (%rsp), %rax
    mulq 8(%rsp)
    mulq 16(%rsp)

    /* allocate lead pointer buffers */
    leaq (,%rax,8), %rdi
    movq %rdi, %rbx
    callq malloc
    movq $0, (%rax)
    movq %rax, 24(%rsp)
    movq %rbx, %rdi
    callq malloc
    movq %rax, %r14

    /* allocate lead linked list node buffer */
    leaq (,%rbx,8), %rdi
    leaq (,%rdi,8), %rdi
    callq malloc
    movq %rax, %rbp

    /* restore registers */
    popq %rcx
    popq %r8
    popq %r9

    /* initialize data buffer */
    pushq (%rsp)
    movq $0, %rax
    movq %r12, %rdx
    shrq $3, %rdx
algorithm.loop1:
    movb $0, (%r13,%rax)
    incq %rax
    cmpq %rdx, %rax
    jle algorithm.loop1

    /* find start position */
    movq $0, %rax
algorithm.loop2:
    cmpb $0x53, (%r15,%rax)
    je algorithm.break2
    incq %rax
    jmp algorithm.loop2
algorithm.break2:

    /* create first node and initialize lead vector */
    btsq %rax, (%r13)
    movq $0, (%rbp)
    movl %eax, 8(%rbp)
    movl $6, 12(%rbp)
    movq %rbp, (%r14)
    movq $0, 8(%r14)
    leaq 16(%rbp), %rbp

    /* main loop */
    pushq $0
algorithm.loop3:
    incq (%rsp)

    /* loop through leads */
    mov $0, %r10
algorithm.loop4:
    movq (%r14,%r10,8), %r11
    incq %r10
    testq %r11, %r11
    je algorithm.break4

    /* lead is active; get character and decode coordinates */
    movl 8(%r11), %eax
    andq $-1, %rax
    callq decode
    movl 8(%r11), %esi
    andq $-1, %rsi

    /* try to go left */
    pushq $0
    testq %rdx, %rdx
    je algorithm.skip1
    decq %rsi
    callq addmaybe
    incq %rsi
algorithm.skip1:

    /* try to go right */
    incq %rdx
    cmpq %rcx, %rdx
    jge algorithm.skip2
    movq $1, (%rsp)
    incq %rsi
    callq addmaybe
    decq %rsi
algorithm.skip2:
    decq %rdx

    /* try to go up */
    testq %rax, %rax
    je algorithm.skip3
    movq $2, (%rsp)
    subq %rcx, %rsi
    decq %rsi
    callq addmaybe
    leaq 1(%rsi,%rcx), %rsi
algorithm.skip3:

    /* try to go down */
    incq %rax
    cmpq %r8, %rax
    jge algorithm.skip4
    movq $3, (%rsp)
    leaq 1(%rsi,%rcx), %rsi
    callq addmaybe
    decq %rsi
    subq %rcx, %rsi
algorithm.skip4:
    decq %rax

    /* try to level down */
    cmpb $0x7A, (%r15,%rsi)
    jne algorithm.skip5
    movq $4,(%rsp)
    pushq %rdx
    pushq %rax
    movq 24(%rsp), %rax
    decq %rax
    pushq %rax
    callq encode
    movq %rax, %rsi
    leaq 8(%rsp), %rsp
    popq %rax
    popq %rdx
    callq addmaybe
    pushq %rdx
    pushq %rax
    pushq 24(%rsp)
    callq encode
    movq %rax, %rsi
    leaq 8(%rsp), %rsp
    popq %rax
    popq %rdx
algorithm.skip5:

    /* try to level up */
    cmpb $0x5A, (%r15,%rsi)
    jne algorithm.skip6
    movq $5,(%rsp)
    pushq %rdx
    pushq %rax
    movq 24(%rsp), %rax
    incq %rax
    pushq %rax
    callq encode
    movq %rax, %rsi
    leaq 8(%rsp), %rsp
    popq %rax
    popq %rdx
    callq addmaybe
    pushq %rdx
    pushq %rax
    pushq 24(%rsp)
    callq encode
    movq %rax, %rsi
    leaq 8(%rsp), %rsp
    popq %rax
    popq %rdx
algorithm.skip6:

    /* back to the top */
    leaq 16(%rsp), %rsp
    jmp algorithm.loop4

    /* swap lead pointer buffers and restart main loop */
algorithm.break4:
    movq $0, (%r14)
    movq %r14, 8(%rsp)
    xchgq 16(%rsp), %r14
    jmp algorithm.loop3

    /* reset stack pointer and return */
algorithm.ret:
    leaq 24(%rsp), %rsp
    retq

    .section .rodata
algorithm.format1:
    .string "%llu\n"
