	;.NOLIST
	;.NOLISTMACRO

	;.586
	;.model flat, stdcall
	;option casemap : none
	include console.inc
	
	.code
	
;---------------POD_CROSS1------------------------------
	PUBLIC	MODL_$$_POD_CROSS1$LONGINT$LONGINT
	MODL_$$_POD_CROSS1$LONGINT$LONGINT proc
		push 	ebp
		mov 	ebp, esp
		push 	eax
		push 	ebx
		push 	ecx
		push 	edx
		push 	esi
		
		mov 	eax, [ebp + 8]
		mov 	ebx, [ebp + 12]
		mov 	eax, [eax]
		mov 	ebx, [ebx]
		
		cmp 	eax, ebx
		jg 		C10
		mov 	ecx, eax
		mov 	eax, ebx
		mov 	ebx, ecx
		mov 	ecx, [ebp + 8]
		mov 	edx, [ebp + 12]
		mov 	[ecx], eax
		mov 	[edx], ebx
C10:	
		mov 	edx, eax

		;Trunc 
		push 	ecx
		mov		ecx, 31
T00:
		shl 	eax, 1
		jc 		T01
		dec 	ecx
		jnz 	T00
T01:		
		mov 	eax, ecx
		pop 	ecx
		;здесь нужно присвоить eax := Random(eax);
		;Exp
		push 	ecx
		mov 	ecx, eax
		mov 	eax, 1
		shl 	eax, cl
		pop 	ecx
		
		mov 	ecx, 1
		mov 	esi, 1
		
		test 	edx, eax
		jnz 	C11
		xor 	ecx, ecx
C11:
		test 	ebx, eax
		jnz 	C12
		xor 	esi, esi
C12:
		xor 	ecx, esi
		jz 		C13
		xor 	edx, eax
		xor 	ebx, eax
		
		mov 	eax, [ebp + 8]
		mov 	ecx, [ebp + 12]
		mov 	[eax], edx
		mov 	[ecx], ebx
C13:
		pop 	esi
		pop 	edx
		pop 	ecx
		pop 	ebx
		pop 	eax
		pop 	ebp
		ret 	8
	MODL_$$_POD_CROSS1$LONGINT$LONGINT endp
	
;----------------POD_CROSS2-------------------------------
	PUBLIC	MODL_$$_POD_CROSS2$LONGINT$LONGINT
	MODL_$$_POD_CROSS2$LONGINT$LONGINT proc
		push 	ebp
		mov 	ebp, esp
		push 	eax
		push 	ebx		
		mov 	eax, [ebp + 8]
		mov 	ebx, [ebp + 12]
		
		push 	ebx
		push 	eax
		push 	ebx
		push 	eax
		call 	MODL_$$_POD_CROSS1$LONGINT$LONGINT
		call 	MODL_$$_POD_CROSS1$LONGINT$LONGINT
		
		pop 	ebx
		pop 	eax
		pop 	ebp
		ret 	8
	MODL_$$_POD_CROSS2$LONGINT$LONGINT endp
	
;-------------------POD_CROSS3--------------------------------
	PUBLIC	MODL_$$_POD_CROSS3$LONGINT$LONGINT
	MODL_$$_POD_CROSS3$LONGINT$LONGINT proc
		push 	ebp
		mov 	ebp, esp
		push 	eax
		push 	ebx
		push 	ecx
		push 	edx ;x
		push 	esi ;y
		push 	edi
		
		mov 	eax, [ebp + 8]
		mov 	eax, [eax]
		mov 	ebx, [ebp + 12]
		mov 	ebx, [ebx]
		mov 	ecx, 1
		xor 	edx, edx
		xor 	esi, esi
C30:
		;Присвоить edi случайное число 0 или 1
		test 	edi, 1
		jnz 	C31
		mov 	edi, ecx
		and 	edi, eax
		or 		edx, edi
		jmp 	C32
C31:
		mov 	edi, ecx
		and 	edi, ebx
		or 		esi, edi
C32:		
		shl 	ecx, 1
		cmp 	ecx, 0000FFFFh
		jl 		C30
		
		mov 	eax, [ebp + 8]
		mov 	[eax], edx
		mov 	ebx, [ebp + 12]
		mov 	[ebx], esi
		
		pop 	edi
		pop 	esi
		pop 	edx
		pop 	ecx
		pop 	ebx
		pop 	eax
		pop 	ebp
		ret 	8
	MODL_$$_POD_CROSS3$LONGINT$LONGINT endp
	
;------------------POD_CROSS4-----------------------------
	PUBLIC MODL_$$_POD_CROSS4$LONGINT$LONGINT
	MODL_$$_POD_CROSS4$LONGINT$LONGINT proc
		push 	ebp
		mov 	ebp, esp
		push 	eax ;a
		push 	ebx ;b
		push 	ecx ;i
		push 	edx ;x
		push 	esi ;y
		push 	edi ;t
		
		mov 	eax, [ebp + 8]
		mov 	eax, [eax]
		mov 	ebx, [ebp + 12]
		mov 	ebx, [ebx]
		mov 	ecx, 1
		xor 	edx, edx
		xor 	esi, esi
		;Присвоить edi Случайное число от 0 до 0000FFFFh = 2^16-1
		inc 	edi
C40:	
		test 	edi, ecx
		jz 		C41
		push 	ecx
		and 	ecx, eax
		or 		edx, ecx
		pop 	ecx
		jmp 	C42
C41:
		push 	ecx
		and 	ecx, ebx
		or 		esi, ecx
		pop 	ecx
C42:
		shl 	ecx, 1
		cmp 	ecx, 0000FFFFh
		jl 		C40
		
		mov 	eax, [ebp + 8]
		mov 	[eax], edx
		mov 	ebx, [ebp + 12]
		mov 	[ebx], esi
		
		pop 	edi
		pop 	esi
		pop 	edx
		pop 	ecx
		pop 	ebx
		pop 	eax
		pop 	ebp
		ret 	8
	MODL_$$_POD_CROSS4$LONGINT$LONGINT endp
	
;--------------------POD_MUT1-----------------------------
	PUBLIC MODL_$$_POD_MUT1$LONGINT$$LONGINT
	MODL_$$_POD_MUT1$LONGINT$$LONGINT proc
		push 	ebx
		mov 	eax, [esp + 8]
		mov 	ebx, eax
		
		;Trunc
		push 	ecx
		mov		ecx, 31
T10:
		shl 	eax, 1
		jc 		T11
		dec 	ecx
		jnz 	T10
T11:		
		mov 	eax, ecx
		pop 	ecx
		;здесь нужно присвоить eax := Random(eax);
		;Exp
		push 	ecx
		mov 	ecx, eax
		mov 	eax, 1
		shl 	eax, cl
		pop 	ecx
		
		xor 	eax, ebx
		
		pop 	ebx
		ret 	4
	MODL_$$_POD_MUT1$LONGINT$$LONGINT endp
	
;---------------------POD_MUT2-------------------------------
	PUBLIC MODL_$$_POD_MUT2$LONGINT$$LONGINT
	MODL_$$_POD_MUT2$LONGINT$$LONGINT proc
		push 	ebx
		push 	ecx
		mov 	eax, [esp + 8]
		mov 	ebx, eax
		mov 	ecx, eax
		
		;Trunc
		push 	ecx
		mov		ecx, 31
T20:
		shl 	eax, 1
		jc 		T21
		dec 	ecx
		jnz 	T20
T21:		
		mov 	eax, ecx
		pop 	ecx
		;здесь нужно присвоить eax := Random(eax);
		;Exp
		push 	ecx
		mov 	ecx, eax
		mov 	eax, 1
		shl 	eax, cl
		pop 	ecx
		
		xor 	ebx, eax
		mov 	eax, ecx
		
		;Trunc
		push 	ecx
		mov		ecx, 31
T40:
		shl 	eax, 1
		jc 		T41
		dec 	ecx
		jnz 	T40
T41:		
		mov 	eax, ecx
		pop 	ecx
		;здесь нужно присвоить eax := Random(eax);
		;Exp
		push 	ecx
		mov 	ecx, eax
		mov 	eax, 1
		shl 	eax, cl
		pop 	ecx
		
		xor 	ebx, eax
		
		pop 	ecx
		pop 	ebx
		ret 	4
	MODL_$$_POD_MUT2$LONGINT$$LONGINT endp
	
;-------------------POD_MUT3---------------------------
	PUBLIC MODL_$$_POD_MUT3$LONGINT$$LONGINT
	MODL_$$_POD_MUT3$LONGINT$$LONGINT proc
		mov 	eax, [esp +4]
		push 	ebp ;k
		push 	ebx ;t
		push 	ecx ;i
		push 	edx ;l
		push 	edi ;k div 2
		push 	esi
				
		mov 	edi, eax
		;Trunc
		push 	ecx
		mov		ecx, 31
T30:
		shl 	eax, 1
		jc 		T31
		dec 	ecx
		jnz 	T30
T31:		
		mov 	eax, ecx
		pop 	ecx
		;Присвоить ebp случайное число до eax
		
		mov 	ecx, ebp 
		mov 	ebx, 1
		shl 	ebx, cl
		inc 	ebp
		
		mov 	ecx, 1
		mov 	edx, 1
		mov 	edi, ebp
		shr 	edi, 1
		
M0:		cmp 	ecx, edi
		jg 		M1
		pop 	ecx
		mov 	ecx, 1
		mov 	esi, 1
		
		test 	eax, ebx
		jnz 	M2
		xor 	ecx, ecx
M2:
		test 	eax, edx
		jnz 	M3
		xor 	esi, esi
M3:
		xor 	ecx, esi
		jz 		M4
		xor 	eax, ebx
		xor 	eax, edx
M4:		
		push 	ecx
		shl 	edx, 1
		shr 	ebp, 1
		inc 	ecx
		jmp 	M0
M1:		
		pop 	esi
		pop 	edi
		pop 	edx
		pop 	ecx
		pop 	ebx
		pop 	ebp
		ret 	4
	MODL_$$_POD_MUT3$LONGINT$$LONGINT endp
	exit
	end