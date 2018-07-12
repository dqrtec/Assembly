org 0x7c00
bits 16
mov ax,0
mov ds,ax

inicio:
	cli
	mov al, 0x13 ;escreve string em modo grafico (320X200)
	int 0x10 ;interrupçao 
	mov bx, 0xA000 ;endereço da memória de video
	mov es, bx ;move para es o endereço de bx

	mov ax, 0 ;move para ax 0
	mov bx, 0 ;move para bx 0
	mov al, 0 ;move para al 0, cor
	mov cx, 0 ;move para cx 0
	
.loop:
	mov di, bx
	mov[es:di], al ;move para es no indice di o valor de al(cor)
	add bx, 321 ;adiciona ao registrador bx 321 (lembre a tela é 320x200, aqui ele anda para o lado)
	inc cx ;incrementa o contador cx(aqui anda para baixo)
	mov al, 101101b
	cmp cx, 199 ;e compara cx com 199(para achegar ate o fim da tela)
	jne .loop ;se nao for igual recomeça o loop

times 510 - ($ - $$) db 0
dw 0xaa55
