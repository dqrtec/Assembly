org 0x7c00
	bits 16
	mov ax, 0
	mov ds, ax

inicio:
	cli
	mov cx, 0
	mov si, msg
	mov bx, 0xB800
	call print
	hlt

print:
	push ax
	push bx
	push dx
	mov es, bx

	mov dl, 5

.loop:
	lodsb
	cmp al,0
	je .retorno

	mov di, cx
	mov [es:di], al
	inc cx
	mov di,cx
	mov [es:di], dl

	add cx, 161
	inc dl
	
	jmp .loop	

.retorno:
	pop bx
	pop ax
	ret

msg: db "hello world", 0

times 510 - ($ - $$) db 0
dw 0xaa55
