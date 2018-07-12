org 0x7c00
bits 16

mov ax, 0x00
mov ds, ax 
cli

inicio:
 mov al, 0x13
 int 0x10

 mov ax, 0xA000; endereço de memoria do modo grafico inciado em 0x13
 mov es, ax

 mov ax, 2
 mov bx, 0

.loop:
 mov di, bx
 mov [es:di], al

 inc bx
 cmp bx, 64000
 jne .loop

 cmp bx, 64001
 jne .mudarcor

 hlt

.mudarcor:
 cmp ax, 255
 je .limitecor

 inc ax
 mov bx, 0
 jmp .loop

.limitecor:
 mov ax, 0
 jmp .loop

times 510 - ($-$$) db 0
dw 0xaa55
