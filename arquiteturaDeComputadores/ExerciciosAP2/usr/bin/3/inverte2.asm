		org 0x7c00
		bits 16

		cli

		push 0; para parar o loop
		

loop1:	mov ah, 0
		int 0x16
		
		cmp al, 13
		je print

		mov ah, 0x0e
		int 0x10
		push ax
		
		jmp loop1	

print:
		mov dh, 1; para printar na linha 1
		mov ah, 0x02
		int 0x10

loop2:
		pop ax
		mov ah, 0x0e
		int 0x10
		or al, al
		jz fim
		jmp loop2

fim:	hlt

		times 510 - ($-$$) db 0
		dw 0xaa55