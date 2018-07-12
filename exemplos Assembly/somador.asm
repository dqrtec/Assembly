	org 0x7C00
	bits 16

	mov ax, 0
	mov ds, ax
	cli

inicio:
	call geti
	mov ax, [0x7E00]
	push ax

	mov ah, 0x02
	mov bh, 0
	mov dh, 1
	int 0x10

	call geti
	mov ax, [0x7E00]
	push ax

	mov ah, 0x02
	mov bh, 0
	mov dh, 2
	int 0x10

	pop cx
	pop ax
	add ax, cx

	call printi
	hlt

geti:
	push ax
	push bx
	push cx
	push dx
	
	mov ax, 0
	push ax
	mov ah, 0
.lernum:
	int 0x16
	mov ah, 0x0E
	int 0x10
	cmp al, '+'
	je .int
	cmp al, '='
	je .int
	mov ah, 0
	push ax
	jmp .lernum
.int:
	mov cx, 1
	mov bx, 0
.calc:
	pop ax
	cmp ax, 0
	je .grava
	sub ax, 48
	mul cx
	add bx, ax
	mov ax, 10
	mul cx
	mov cx, ax
	jmp .calc
.grava:
	mov [0x7E00], bx

	pop dx
	pop cx
	pop bx
	pop ax
	ret

printi:
	push ax
	push bx
	push cx
	push dx

	mov cx, 0
	push cx
	mov cx, 10
.divs:
	mov dx, 0
	div cx
	add dx, 48
	push dx
	cmp ax, 0
	je .exibe
	jmp .divs
.exibe:
	pop ax
	cmp ax, 0
	je .term
	mov ah, 0x0E
	int 0x10
	jmp .exibe	
.term:
	pop dx
	pop cx
	pop bx
	pop ax
	ret

	times 510-($-$$) db 0
	dw 0xaa55
