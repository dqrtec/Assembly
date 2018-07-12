    org 0x7c00
    bits 16

    mov ax, 0x00
    mov ds, ax 

start:
    cli

    mov cx, 0

    ;INSERINDO 0 NA PILHA
    mov ax, 0
    push ax
    call printi ;IMPRIMINDO 0
    call space ;DANDO ESPAÇO
    
    ;INSERINDO 1 NA PILHA
    mov ax, 1
    push ax 
    call printi
    call space

    ;PROGRAMA DE FIBONNACI: AS DUAS PRIMEIRAS INSTRUÇÕES FAREI AQUI PARA ENTENDEREM, APÓS FAREI DENTRO DA FUNÇÃO.
    ;UTILIZAREMOS MAIS UM REGISTRADOR
    ;PILHA ATUAL [0,1]
    pop ax ;PEGA O TOPO DA PILHA (1) E COLOCA NO AX
    pop bx ;PEGA O TOPO DA PILHA (0) E COLOCA NO BX
    ; pilha vazia

    push ax  ;INSERE 1 NA PILHA
    add ax,bx ; soma o val de ax e bx (1+0); resultado vai pro primeiro operando
    push ax ;[1, 1] NA PILHA
    
    call printi ;MANDAMOS IMPRIMIR O QUE ESTÁ EM AX
    call space  ;MANDAMOS A TELA PULAR UMA LINHA


    pop ax ;PEGA O TOPO DA PILHA(1) E COLOCA NO AX
    pop bx ;PEGA O TOPO DA PILHA(1) E COLOCA NO BX
    ; pilha vazia

    push ax  ;INSERE 1 NA PILHA
    add ax,bx ; soma o val de ax e bx (1+1); resultado vai pro primeiro operando
    push ax ;[1, 2] NA PILHA
    
    call printi 
    call space


    pop ax ;PEGA O TOPO DA PILHA(2) E COLOCA NO AX
    pop bx ;PEGA O TOPO DA PILHA(1) E COLOCA NO BX
    ; pilha vazia

    push ax  ;INSERE 2 NA PILHA
    add ax,bx ; soma o val de ax e bx (2+1); resultado vai pro primeiro operando
    push ax ;[2, 3] NA PILHA
    
    call printi 
    call space

;AGORA USAREMOS A FUNÇÃO PARA EXECUTAR A PILHA QUE O NUMERO DE FIBONNACCI=2584
.fibonnaci:
    pop ax
    pop bx
    
    push ax
    add ax,bx ; soma o val de ax e bx; resultado no primeiro operando
    push ax

    cmp ax,2584 ;COMPARAMOS O VALOR ARMAZENADO EM AX COM 2584
    jg halt ;PULE PARA 'halt' SE AX FOR MAIOR QUE 2584
    
    ;SE NAO FOR, MANDAMOS IMPRIMIR E VOLTAMOS NOVAMENTE PARA FIBONNACI
    call printi
    call space
    
    jmp .fibonnaci        


;FUNÇÃO PARA IMPRIMIR NUMERO INTEIRO
printi:          ;procedimento de escrita de nÃºmeros inteiros (nÃºmero deve estar em ax)
    push cx      ;guarda cx - nÃºmero de caracteres jÃ¡ impressos
    push ax      ;guarda ax - valor a ser impresso

    mov ax, cx   ;calcula em bx (com ajuda de ax) o deslocamento de memÃ³ria a partir da quantidade de caracteres jÃ¡ impressos (cx guarda esse valor)
    mov cx, 2    ;cada caractere tem dois bytes. Byte mais significativo: cor. Byte menos significativo: caractere propriamente dito.
    mul cx
    mov bx, ax

    pop ax            ;recupera em ax o seu valor original (valor a ser impresso)
    push ax           ;guarda ax - valor a ser impresso

    mov cx, 0         ;contador de caracteres impressos na atual chamada

    mov dx, 0xB800    ;determina endereÃ§o inicial da memÃ³ria de vÃ­deo para caracteres
    mov es, dx

.loop:
    inc cx            ;novo caractere serÃ¡ impresso. Incrementar contador de caracteres impressos na atual chamada
    
    push bx           ;guarda valor de bx (deslocamento a partir da quantidade de caracteres jÃ¡ escritos na tela)

    mov dx, 0         ;calcula nÃºmero a ser exibido (decimal menos significativo)
    mov bx, 10        ;dividindo por 10
    div bx            ;dx = resto e ax = quociente

    mov bx, ax        ;guarda em bx o quociente (ax)

    mov ax, 48        ;DefiniÃ§Ã£o em ax do caractere correspondente ao decimal menos significativo
    add ax, dx        ;ax = '0' (byte 48) + resto (dx)
    
    mov dx, bx        ;guarda bx (quociente) em dx
    pop bx            ;devolve para bx o deslocamento de memÃ³ria
    
    push ax           ;empilha caractere correspondente (ax)

    mov ax, dx        ;move quociente para ax, isto Ã©, o nÃºmero sem o decimal menos significativo

    cmp ax, 0         ;compara o nÃºmero com 0
    jnz .loop         ;se for diferente de 0, repita o processo de identificaÃ§Ã£o do decimal menos significativo (atÃ© zerar o nÃºmero)

    mov dx, 0         ;zera dx para utilizar como auxiliar no processo de exibiÃ§Ã£o da pilha (caracteres do nÃºmero a ser exibido)
.write:
    pop ax            ;desempilha caractere em ax
    mov di, bx        ;di (destination index) - Ã­ndice da memÃ³ria, a partir do segmento es, onde o caractere serÃ¡ gravado
    mov [es:di], al   ;al contÃ©m o caractere (byte baixo de ax). Move para a posiÃ§Ã£o de memÃ³ria es:di (memÃ³ria de vÃ­deo de texto)
    dec cx            ;cx contÃ©m o nÃºmero de carateres na pilha. Se colocou na memÃ³ria de vÃ­deo um caractere, entÃ£o desempilha.
    inc dx            ;dx passa a contar o nÃºmero de caracteres escritos
    add bx, 2         ;deslocamento de memÃ³ria de vÃ­deo: 2 bytes por caractere
    cmp cx, 0         ;compara cx com 0
    jne .write        ;se a comparaÃ§Ã£o anterior nÃ£o for zero, nem todos os caracteres foram passados para o vÃ­deo. Pula para repetir processo.

    pop ax            ;Quando todos os caracteres estÃ£o escritos, restam na pilha apenas os valores de ax e cx gravados no inÃ­cio do procedimento. 
    pop cx            ;Devolve para os respectivos registradores seus valores originais

    add cx, dx        ;Acrescenta ao contador de caracteres (cx) os caracteres impressos na chamada atual (dx)
    ret               ;retorna



;FUNÇÃO PARA IMPRIMIR UM " "
space:
    mov si,espaco
    call prints
    ret



;FUNÇÃO PARA IMPRIMIR QUALQUER STRING
prints:               ;procedimento de escrita de string (endereÃ§o do caractere inicial deve estar em si. String deve terminar com o byte 0.)
    push cx           ;guarda na pilha quantidade de caracteres jÃ¡ escritos (cx)
    push ax           ;guarda valor de ax na pilha para nÃ£o alterar com a execuÃ§Ã£o do procedimento

    mov ax, cx        ;calcula em dx o deslocamento de memÃ³ria a ser feito na memÃ³ria de vÃ­deo baseado no nÃºmero de caracteres jÃ¡ escritos
    mov cx, 2         ;cada caractere tem dois bytes (byte alto = cor e byte baixo = caractere)
    mul cx
    mov dx, ax

    mov bx, 0xB800    ;posiÃ§Ã£o inicial da memÃ³ria de vÃ­deo de texto Ã© passada para o registrador de segmento
    mov es, bx

    mov bx, 0         ;contador de caracteres escritos na execuÃ§Ã£o atual (bx)
.loops:
    lodsb             ;carrega no registrador ax o caractere no endereÃ§o apontado pelo registrador si. Incrementa o valor de si (prÃ³ximo caractere)
    or al, al         ;verifica se o caractere Ã© o byte 0 (marcaÃ§Ã£o de fim de string)
    jz .return        ;se for zero, pula para retornar do procedimento
    mov di, dx        ;carrega no registrador di (destination index) o deslocamento de memÃ³ria baseado no nÃºmero de caracteres (dx)
    mov [es:di], al   ;coloca caractere no endereÃ§o correspondente na memÃ³ria de vÃ­deo
    add dx, 2         ;deslocamento Ã© incrementado de 2 (cada caractere gasta dois bytes)
    inc bx            ;conta caracteres escritos
    jmp .loops        ;repete processo de escrita de caractere

.return:
    pop ax            ;devolve o valor original de ax, guardado no inÃ­cio do procedimento na pilha
    pop cx            ;devolve valor original de cx (caracteres escritos antes da chamada), guardado no inÃ­cio do procedimento na pilha
    add cx, bx        ;adiciona ao contador de caracteres escritos os caracteres da atual execuÃ§Ã£o do procedimento
    ret               ;retorna





halt:
    hlt

msg:
    db " Hello world!", 0

espaco:
    db " ", 0

    times 510 - ($-$$) db 0
    dw 0xaa55