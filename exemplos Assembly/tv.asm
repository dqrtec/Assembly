    org 0x7c00
    bits 16

    mov ax, 0x00
    mov ds, ax 
    cli

start:
    mov al, 0x13	;modo gráfico VGA = 320x200, 256 cores (1 byte determina a cor)
    int 0x10		; interrup�ao de video

    mov ax, 0xA000	;memória de vídeo no modo grafico
    mov es, ax
	mov dx, 0

    mov ax, 1		;Preenche a tela com a paleta de cores repetidamente, com 1 cor por pixel
    mov bx, 0		; contador para pixel da tela;
.laco:			
    mov di, bx
    mov [es:di], al

    inc ax
    add bx, 161
    
    cmp bx, 64000
    je .troca
    jmp .laco

.troca:
	add ax, 3
	jmp .laco

fim:
    hlt

    times 510 - ($-$$) db 0
    dw 0xaa55

