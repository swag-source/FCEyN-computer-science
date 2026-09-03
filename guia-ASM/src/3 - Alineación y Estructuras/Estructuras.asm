; --- ALLIGNED STRUCT ---
NODO_OFFSET_NEXT EQU 0
NODO_OFFSET_CATEGORIA EQU 8
NODO_OFFSET_ARREGLO EQU 16
NODO_OFFSET_LONGITUD EQU 24
NODO_SIZE EQU 28
; ---------------------

; --- PACKED STRUCT ---
PACKED_NODO_OFFSET_NEXT EQU 0
PACKED_NODO_OFFSET_CATEGORIA EQU 8
PACKED_NODO_OFFSET_ARREGLO EQU 9
PACKED_NODO_OFFSET_LONGITUD EQU 17
PACKED_NODO_SIZE EQU 21

; -- ALLIGNED REFERENCE POINTER 
LISTA_OFFSET_HEAD EQU 0
LISTA_SIZE EQU 8
; ---------------------

; -- PACKED REFERENCE POINTER -- 
PACKED_LISTA_OFFSET_HEAD EQU 8
PACKED_LISTA_SIZE EQU 8
; ---------------------

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS
global cantidad_total_de_elementos
global cantidad_total_de_elementos_packed


;extern uint32_t cantidad_total_de_elementos(lista_t* lista);
; RDI: lista_t* lista
cantidad_total_de_elementos:
	; Prologo
	PUSH RBP
	MOV RBP, RSP

	; R8D <- i = 0;
	XOR R8D, R8D
	; RAX <- res = 0;
	XOR RAX, RAX
		
	; RSI <- HEAD(lista)
	MOV RSI, [RDI + LISTA_OFFSET_HEAD]
	
	.check:
		CMP RSI, 0
		JZ .done

	.ciclo:
		; RCX <- longitud(nodo_i)
		MOV ECX, dword [RSI + NODO_OFFSET_LONGITUD]
		
		; RAX <- RAX + |arreglo|
		ADD EAX, ECX

		; RCX <- nodo_i+1
		MOV RSI, [RSI + NODO_OFFSET_NEXT]

		JMP .check

	.done:
	; Epilogo
	POP RBP
	ret

; Human Resource Machine

;extern uint32_t cantidad_total_de_elementos_packed(packed_lista_t* lista);
; RDI <- lista_t* lista
cantidad_total_de_elementos_packed:
		; Prologo
	PUSH RBP
	MOV RBP, RSP

	; R8D <- i = 0;
	XOR R8D, R8D
	; RAX <- res = 0;
	XOR RAX, RAX
		
	; RSI <- HEAD(lista)
	MOV RSI, [RDI + PACKED_LISTA_OFFSET_HEAD]
	
	.check:
		CMP RSI, 0
		JZ .done

	.ciclo:
		; RCX <- longitud(nodo_i)
		MOV ECX, dword [RSI + PACKED_NODO_OFFSET_LONGITUD]
		
		; RAX <- RAX + |arreglo|
		ADD EAX, ECX

		; RCX <- nodo_i+1
		MOV RSI, [RSI + PACKED_NODO_OFFSET_NEXT]

		JMP .check

	.done:
	; Epilogo
	POP RBP
	ret