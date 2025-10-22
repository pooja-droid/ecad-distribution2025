    .macro DEBUG_PRINT reg
    csrw 0x800, \reg
    .endm
        
    .text
    .global div
    .type div, @function
div:
    addi sp, sp, -32
    sw   ra, 28(sp)
    sw   s0, 24(sp)

    # --- division algorithm ---
    mv      t0, a0
    mv      t1, a1
    beq     t1, x0, .Ldiv_by_zero

    li      a0, 0
    li      t2, 0
    li      t4, 31

.Lloop:
    slli    t2, t2, 1
    srl     t5, t0, t4
    andi    t5, t5, 1
    or      t2, t2, t5
    sltu    t6, t2, t1
    bne     t6, x0, .Lskip
    sub     t2, t2, t1
    li      t3, 1
    sll     t3, t3, t4
    or      a0, a0, t3
.Lskip:
    addi    t4, t4, -1
    bge     t4, x0, .Lloop

    mv      a1, t2
    j       .Ldone

.Ldiv_by_zero:
    li      a0, 0
    mv      a1, t0

.Ldone:
    lw   ra, 28(sp)
    lw   s0, 24(sp)
    addi sp, sp, 32
    ret
