lui $10, 0x0800	# 26th bit
ori $1, $0, 0	# counter

ori $20, $0, 0x001d	# up press (W)
ori $21, $0, 0x001b	# down press (S)
ori $22, $0, 0x001c	# left press (A)
ori $23, $0, 0x0023	# right press (D)
ori $24, $0, 0x0015	# zoom in (Q)
ori $25, $0, 0x0024	# zoom out (E)

main_loop:
	lw $1, 0x6000	#0110 0000 0000 0000 # get keyboard input
	beq $1, $20, panUp
	beq $1, $21, panDown
	beq $1, $22, panLeft
	beq $1, $23, panRight
	beq $1, $24, zoomIn
	beq $1, $25, zoomOut
	j main_loop

panUp:
	ori $10, $0, 0x201e	# panY
	ori $11, $0, 0xf01d	# release up
	addi $12, $0, 1	# dec panY
	ori $13, $0, 16	# counter == 0x0001
	j buttonWait

panDown:
	ori $10, $0, 0x201e	# panY
	ori $11, $0, 0xf01b	# release down
	addi $12, $0, -1	# inc panY
	ori $13, $0, 16	# counter == 0x0001
	j buttonWait

panLeft:
	ori $10, $0, 0x201f	# panX
	ori $11, $0, 0xf01c	# release left
	addi $12, $0, 1	# dec panX
	ori $13, $0, 16	# counter == 0x0001
	j buttonWait

panRight:
	ori $10, $0, 0x201f	# panX
	ori $11, $0, 0xf023	# release right
	addi $12, $0, -1	# inc panX
	ori $13, $0, 16	# counter == 0x0001
	j buttonWait

zoomIn:
	ori $10, $0, 0x201f
	lw $1, 0($10)	# load and store param
	sll $1, $1, 1
	sw $1, 0($10)
	
	ori $10, $0, 0x201e
	lw $1, 0($10)	# load and store param
	sll $1, $1, 1
	sw $1, 0($10)
	
	ori $10, $0, 0x201d	# zoom
	ori $11, $0, 0xf015	# release zoom in
	addi $12, $0, 1 # inc zoom
	ori $13, $0, 21	# counter == 0x0008
	
	j buttonWait

zoomOut:

	ori $10, $0, 0x201f
	lw $1, 0($10)	# load and store param
	sra $1, $1, 1
	sw $1, 0($10)
	
	ori $10, $0, 0x201e
	lw $1, 0($10)	# load and store param
	sra $1, $1, 1
	sw $1, 0($10)
	
	ori $10, $0, 0x201d	# zoom
	ori $11, $0, 0xf024	# release zoom out
	addi $12, $0, -1	# dec zoom
	ori $13, $0, 21	# counter == 0x0008
	j buttonWait

# $10: data mem addr
# $11: key to release up
# $12: dec or inc data
# $13: button wait time
buttonWait:
	lw $1, 0($10)	# load and store param
	add $1, $1, $12
	sw $1, 0($10)
	
	ori $8, $0, 1
	#ori $9, $0, 16
	sllv $4, $8, $13
	#lui $4, 0x0004	# counter max
	ori $3, $0, 0	# counter var
	buttonWaitLoop:	# busy wait loop
	addi $3, $3, 1
	lw $1, 0x6000	# try to get out of loop
	beq $1, $11, main_loop
	bne $3, $4, buttonWaitLoop
	j buttonWait