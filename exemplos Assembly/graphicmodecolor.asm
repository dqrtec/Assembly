org 0x7c00 ;(indica para o montador onde o programa ficará na memória quando executado)
	bits 16 ;(indica ao montador quais os tamanhos dos registradores)

	mov ax,0 ;(podemos mexer nos registradores ax, bx, cx,dx. Definimos um valor para o registrador ax)
	mov ds,ax ;(informamos pra bios em qual segmento estamos trabalhando, no caso 0. Usamos essa instrução pois não podemos jogar um valor diretamente em um 			registrador S)
	cli ;(limpa todas as interrupcoes que tenham sido chamadas no processador)

inicio:
	mov al, 0x13 ;(quando movemos esse byte para o registrador 'al' e executamos a interrupcao 10, inicializamos o modo grafico)
	int 0x10

	mov bx, 0xA000 ;(MEMORIA DE VIDEO NO MODO GRAFICO)
	mov es, bx

	mov cx,0 ;(posicao)
	mov dx,0

.laco:
	mov di,cx 
	mov [es:di],dl ;(exibirá no primeiro pixel o byte 4)

	inc cx
	inc dx

	cmp cx, 64000
	jne .laco

fim:	hlt
	times 510 - ($-$$) db 0 ;(comando do nasmi para contar quantos bytes ja foram colocados no programa até agora, serve para completarmos os 512 bytes)
	dw 0xaa55