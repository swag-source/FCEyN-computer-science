extern sumar_c
extern restar_c
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS

global alternate_sum_4
global alternate_sum_4_using_c
global alternate_sum_4_using_c_alternative
global alternate_sum_8
global product_2_f
global product_9_f

;########### DEFINICION DE FUNCIONES
; uint32_t alternate_sum_4(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4:
  sub EDI, ESI
  add EDI, EDX
  sub EDI, ECX

  mov EAX, EDI
  ret

; uint32_t alternate_sum_4_using_c(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4_using_c:
  ;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado
  push R12
  push R13	; preservo no volatiles, al ser 2 la pila queda alineada

  mov R12D, EDX ; guardo los parámetros x3 y x4 ya que están en registros volátiles
  mov R13D, ECX ; y tienen que sobrevivir al llamado a función

  call restar_c 
  ;recibe los parámetros por EDI y ESI, de acuerdo a la convención, y resulta que ya tenemos los valores en esos registros
  
  mov EDI, EAX ;tomamos el resultado del llamado anterior y lo pasamos como primer parámetro
  mov ESI, R12D
  call sumar_c

  mov EDI, EAX
  mov ESI, R13D
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  pop R13 ;restauramos los registros no volátiles
  pop R12
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret


alternate_sum_4_using_c_alternative:
  ;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado
  sub RSP, 16 ; muevo el tope de la pila 8 bytes para guardar x4, y 8 bytes para que quede alineada

  mov [RBP-8], RCX ; guardo x4 en la pila

  push RDX  ;preservo x3 en la pila, desalineandola
  sub RSP, 8 ;alineo
  call restar_c 
  add RSP, 8 ;restauro tope
  pop RDX ;recupero x3
  
  mov EDI, EAX
  mov ESI, EDX
  call sumar_c

  mov EDI, EAX
  mov ESI, [RBP - 8] ;leo x4 de la pila
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  add RSP, 16 ;restauro tope de pila
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret


; uint32_t alternate_sum_8(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4, uint32_t x5, uint32_t x6, uint32_t x7, uint32_t x8);
; (x1 - x2) + (x3 - x4) + (x5 - x6) + (x7 - x8)
; -- Registers --
; EDI: x1,
; ESI: x2,
; EDX: x3,
; ECX: x4,
; R8D: x5,
; R9D: x6,
; -- Stack --
; [RBP + 8]: RIP (caller)
; [RBP + 16]: x7
; [RBP + 24]: x8
alternate_sum_8:
	;prologo
  push RBP ; Pila alineada
  mov RBP, RSP

  xor R10D, R10D ; Limpio los registros R10D y R11D para usarlos como auxiliares
  xor R11D, R11D 

  mov dword R10D, [RBP + 16] ; R10D = x7
  mov dword R11D, [RBP + 24] ; R11D = x8

  sub EDI, ESI ; EDI = (x1 - x2)
  sub EDX, ECX ; EDX = (x3 - x4)
  sub R8D, R9D ; R8D = (x5 - x6)
  sub R10D, R11D ; R10D = (x7 - x8)

  mov EAX, EDI ; EAX = (x1 - x2)
  add EAX, EDX ; EAX = (x1 - x2) + (x3 - x4)
  add EAX, R8D ; EAX = (x1 - x2) + (x3 - x4) + (x5 - x6)
  add EAX, R10D ; EAX = (x1 - x2) + (x3 - x4) + (x5 - x6) + (x7 - x8)
  
	;epilogo
  pop RBP ; Pila desalineada
	ret ; Pila alineada


; SUGERENCIA: investigar uso de instrucciones para convertir enteros a floats y viceversa
;void product_2_f(uint32_t * destination, uint32_t x1, float f1);
; EDI: destination
; ESI: x1
; XMM0: f1
product_2_f:
  ;prologo
  push RBP ; Pila alineada
  mov RBP, RSP

  mov EAX, ESI ; EAX = x1
  pxor XMM1, XMM2 ; Limpio registro
  
  cvtsi2sd XMM1, RAX ; XMM1 = (double)x1 
  
  cvtss2sd XMM0, XMM0 ; XMM0 = (double)f1

  mulsd XMM0, XMM1 ; XMM0 = (double)f1 * x1

  cvttsd2si RAX, XMM0 ; RAX = (uint32_t)(f1 * x1)

  mov dword [RDI], EAX ; *destination = f1 * x1
  
  ;epilogo
  pop RBP
  ret


;extern void product_9_f(double * destination
;, uint32_t x1, float f1, uint32_t x2, float f2, uint32_t x3, float f3, uint32_t x4, float f4
;, uint32_t x5, float f5, uint32_t x6, float f6, uint32_t x7, float f7, uint32_t x8, float f8
;, uint32_t x9, float f9);
; -- Registros enteros --
; RDI: destination
; ESI: x1
; EDX: x2
; ECX: x3
; R8D: x4
; R9D: x5
; -- Registros XMM --
; XMM0: f1
; XMM1: f2
; XMM2: f3
; XMM3: f4
; XMM4: f5
; XMM5: f6
; XMM6: f7
; XMM7: f8
; -- Stack --
; [RBP + 8]:  RIP (caller)
; [RBP + 16]: x6
; [RBP + 24]: x7
; [RBP + 32]: x8
; [RBP + 40]: x9
; [RBP + 48]: f9

product_9_f:
	;prologo
	push rbp
	mov rbp, rsp

  ; Limpio registros donde voy a guardar el entero
  pxor XMM9, XMM9
  pxor XMM10, XMM10
  pxor XMM11, XMM11
  pxor XMM12, XMM12
  pxor XMM13, XMM13
  pxor XMM14, XMM14
  pxor XMM15, XMM15

  ; Convierto a double los enteros
  cvtsi2sd XMM9, ESI ; XMM9 = | 00000000..... |  x1 (double) |
  cvtsi2sd XMM10, EDX ; XMM10 = | 00000000..... |  x2 (double) |
  cvtsi2sd XMM11, ECX ; XMM11 = | 00000000..... |  x3 (double) |
  cvtsi2sd XMM12, R8D ; XMM12 = | 00000000..... |  x4 (double) |
  cvtsi2sd XMM13, R9D ; XMM13 = | 00000000..... |  x5 (double) |
  cvtsi2sd XMM14, [RBP + 16] ; XMM14 = | 00000000..... |  x6 (double) |
  cvtsi2sd XMM15, [RBP + 24] ; XMM15 = | 00000000..... |  x7 (double) |

  ; Convierto a double precision los float (single precision)
  cvtss2sd XMM0, XMM0 ; XMM0 = | 00000000..... |  f1 (double) |
  cvtss2sd XMM1, XMM1 ; XMM1 = | 00000000..... |  f2 (double) |
  cvtss2sd XMM2, XMM2 ; XMM2 = | 00000000..... |  f3 (double) |
  cvtss2sd XMM3, XMM3 ; XMM3 = | 00000000..... |  f4 (double) |
  cvtss2sd XMM4, XMM4 ; XMM4 = | 00000000..... |  f5 (double) |
  cvtss2sd XMM5, XMM5 ; XMM5 = | 00000000..... |  f6 (double) |
  cvtss2sd XMM6, XMM6 ; XMM6 = | 00000000..... |  f7 (double) |
  cvtss2sd XMM7, XMM7 ; XMM7 = | 00000000..... |  f8 (double) |
  cvtss2sd XMM8, [RBP + 48] ; XMM8 = | 00000000..... |  f9 (double) |

  ; Multiplico (f[i] * f[i+1]) i = {1...8}
  mulpd XMM0, XMM1 ; XMM0 <- (f1 * f2)
  mulpd XMM0, XMM2 ; XMM0 <- (f1 * f2) * f3
  mulpd XMM0, XMM3 ; XMM0 <- (f1 * f2 * f3) * f4
  mulpd XMM0, XMM4 ; XMM0 <- (f1 * f2 * f3 * f4) * f5
  mulpd XMM0, XMM5 ; XMM0 <- (f1 * f2 * f3 * f4 * f5) * f5
  mulpd XMM0, XMM6 ; XMM0 <- (f1 * f2 * f3 * f4 * f5 * f6) * f7
  mulpd XMM0, XMM7 ; XMM0 <- (f1 * f2 * f3 * f4 * f5 * f6 * f7) * f8
  mulpd XMM0, XMM8 ; XMM0 <- (f1 * f2 * f3 * f4 * f5 * f6 * f7 * f8) * f9
  ; XMM0 <- (f1 * f2 * f3 * f4 * f5 * f6 * f7 * f8 * f9)
  
  ; Multiplico (f1 * f2 * f3 * f4 * f5 * f6 * f7 * f8 * f9) * x[i] * x[i+1] {1...8}
  ; Sea S = (f1 * f2 * f3 * f4 * f5 * f6 * f7 * f8 * f9) 
  mulpd XMM0, XMM9 ; XMM0 <- S * x1
  mulpd XMM0, XMM10 ; XMM0 <- (S * x1) * x2
  mulpd XMM0, XMM11 ; XMM0 <- (S * x1 * x2) * x3
  mulpd XMM0, XMM12 ; XMM0 <- (S * x1 * x2 * x3) * x4
  mulpd XMM0, XMM13 ; XMM0 <- (S * x1 * x2 * x3 * x4) * x5
  mulpd XMM0, XMM14 ; XMM0 <- (S * x1 * x2 * x3 * x4 * x5) * x6
  mulpd XMM0, XMM15 ; XMM0 <- (S * x1 * x2 * x3 * x4 * x5 * x6) * x7
  mulpd XMM0, XMM8 ; XMM0 <- (S * x1 * x2 * x3 * x4 * x5 * x6 * x7) 

  ; Me falta multiplicar * x8 * x9
  ; Podemos usar registros que nos sobran nuevamente
  pxor xmm1, xmm1
  pxor xmm2, xmm2

  mov dword RDI, [EBP + 32]
  mov dword RDX, [EBP + 40]

  cvtsi2sd XMM1, RDI ; XMM1 = x8
  cvtsi2sd XMM2, RDX ; XMM2 = x9

  mulpd XMM0, XMM1 ; XMM1 <- (S * x1 * x2 * x3 * x4 * x5 * x6 * x7) * x8
  mulpd XMM0, XMM2 ; XMM0 <- (S * x1 * x2 * x3 * x4 * x5 * x6 * x7 * x8) * x9

  ; Extraigo los 64 bits más altos del XMM0 (pudo haber tenido residuo de los registros no limpiados)

  pextrq [RAX], XMM0, 0x01

  ; Almaceno en destino
  movlpd [RAX], xmm0

  ; epilogo
	pop rbp
	ret

