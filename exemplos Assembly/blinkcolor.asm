	org 0X7C00
	bits 16

	mov ax, 0
	mov ds, ax

start:
	mov al, 0x13
	int 0x10
	mov bl, 10
	mov cl, 5
cor:
	mov al, 0
	mov dx, 0x3c8	
	out dx, al
	mov dx, 0x3c9
	add al, bl	
	inc bl
	
	out dx, al

	add al, bl
	inc bl

	out dx, al

	add al, bl
	inc bl

	out dx, al

	inc bl

	jmp cor

halt:
	hlt

msg:
	db "hello word !",0

	times 510 - ($-$$) db 0
	dw 0xaa55