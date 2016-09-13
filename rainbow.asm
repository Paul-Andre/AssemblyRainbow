;*********************************************
;	rainbow.asm
;		- A Simple Bootloader
;
;	Operating Systems Development Tutorial
;*********************************************
 
 
  
%define W 80
%define H 26

 
;-----------------------------------------------------------------------------

%define ORG 0x00007C00

org ORG ; binary image loaded by BIOS at 07C0:0000

bits 16 ; startup is done in real mode

;-----------------------------------------------------------------------------
 					; We are still in 16 bit Real Mode


boot:



	mov ah,05h
	mov al,02h
	int 10h
	
	
	mov ah,02h ;interupt
	mov bh,02h ;page
	mov dh,00h ;position x
	mov dl,00h ;position y
	int 10h
	
	mov WORD [index], colorsArray
.l1 






	mov bx,[index] ;
	mov bl, [bx]
	
	mov ah,09h ;fonction int pour aff car
	mov al, [letter] ;car a aff	
	mov bh,02h ;page
	;mov bl,[index] ;
	mov cx, W ;rep
	int 0x10  ; int bios 
	
	
	mov ah,02h ;interupt
	mov bh,02h ;page
	mov dh, [position];position y
	mov dl,0 ;position x
	int 10h
	
	
	inc BYTE [position]
	cmp BYTE [position], H
	jl .continue
	
		;wait
		mov ah, 86h
		mov cx, 0     ; higher word 
		mov dx, 0x6000  ;lower word (number of microseconds)
		int 15h;
	
	
		mov BYTE [position],0;
	
		inc WORD [rainbowStartColor];
	
		mov WORD ax, [rainbowStartColor]
		mov WORD [index], ax
	
		cmp WORD [rainbowStartColor],colorsEnd	
	
		jl .continue
		
			mov WORD [rainbowStartColor], colorsArray
	
			mov WORD ax, [rainbowStartColor]
			mov WORD [index], ax
	
	.continue
	
	
	
	
	inc WORD [index];
	cmp WORD [index],colorsEnd
	jl .l1
	
	mov WORD [index], colorsArray
	
	jmp .l1

end:	
	cli
	hlt
	
	
data:	
	colorsArray db 0x44,0x4c,0x6c,0xce,0xee,0xea,0xaa,0xbb,0x9b,0x99,0x19,0x59,0x55 ;,0x54
	colorsEnd:  equ $
	
	rainbowStartColor dw colorsArray;
	
	letter db 0xb1
	position db 0
	index dw 0


	
;-----------------------------------------------------------------------------
	times 510-($-$$) db 0	; the boot sector (512 bytes) must end with
	db 0x55, 0xAA		; 55 AA to be loaded by BIOS
;-----------------------------------------------------------------------------
