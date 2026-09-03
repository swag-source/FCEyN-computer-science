extern print_uint64
section	.data
    FIRST_VALUE EQU 256, ; This case will overflow for byte 
    SECOND_VALUE EQU 256 ; This case will 
section	.text
	global _start
_start:
    mov BYTE al, FIRST_VALUE ; AL (8 bits) = FIRST_VALUE (8 bits)
    mov BYTE bl, SECOND_VALUE ; BL (8 bits) = SECOND_VALUE (8 bits)
    ADD al, bl ; AL <- AL + BL
    mov dil, al ; DIL (8 bits) = AL
    call print_uint64
    mov	eax, 1 
	int	0x80
    syscall sys_exit