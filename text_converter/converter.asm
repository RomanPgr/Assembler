	include console.inc
	
	.data
		N 			dd 512
		text1 		db 1024 dup (?)
		text2 		db 1024 dup (?)
		len1 		dd 0
		len2 		dd 0
		prog_ttl 	db 'Text converter', 0
		hello 		db 'This is a welcome message!', 0
		entr_1 		db 'Enter the first text:', 0
		entr_2 		db 'Enter second text:', 0
		rule1 		db 'Rule 1 : replace each lowercase latin letter with a corresponding uppercase     letter and lowercase letter with a lowercase letter.', 0
		rule2 		db 'Rule 2 : double each digit included in the text.', 0
		txt_1_rule 	db 'The first text is converted by rule ', 0
		txt_2_rule 	db 'The second text is converted by rule ', 0
		i_err 		db 'Input error!', 0
		exit_progr	db 'Press any key to exit...', 0
	
	.code
;---function in_text(var text : string; N : longword; var len : longword) : boolean;------------------------------------------
	in_text proc
		push	ebp
		mov		ebp, esp
		push 	esi
		push 	edx
		push 	ecx
		push 	ebx
		
		mov		ebx, [ebp + 8] ;� ���� �������� ����� ������ �������
		mov 	edx, [ebp + 12] ;� ���� �������� ������������ ����� ������� = 512
		sub 	ecx, ecx ;���������� ��������
		sub 	eax, eax ;ah = 1 ���� ����� ������� �������� ��� ��������� �������� ����, ����� 0. � al ������� ������
		sub 	esi, esi ;��������� ������� ����� ������
	
CYCLE:	
		cmp 	ah, 0 ;������ ��������� ����� �����
		jne 	L6 ; �������� �������� ah 0 ��� 1
		readkey ;������ ��������� ������ � al
		sub 	ah, ah
		jmp 	L7
L6:		
		readkey
		mov 	ah, 1 
L7:		
		cmp 	al, 13 ;������ ������� �������
		jne 	L5
		mov 	al, 10 ;������ ����� ������
L5:	
		outchar al ;���� � ����
		cmp 	al, '\' 
		je 		L2
		mov 	[ebx + ecx], al ;���� ������ �� '\'
		inc 	ecx ;����������� ���������� ��������
		cmp 	ah, 1 
		je 		L325 ;���� ����� ������� �������� ��� �������� ����
		cmp 	esi, 0
		je 		L_ESI_0
		cmp		esi, 1
		je 		L_ESI_1
		cmp 	esi, 2
		je 		L_ESI_1
		cmp 	esi, 3
		je 		L_ESI_0
L_ESI_0:
		cmp 	al, '@'
		jne 	L4
		inc 	esi
		jmp 	L3
L_ESI_1:
		cmp 	al, '@'
		jne 	L8
		mov 	esi, 1
		jmp 	L3
L8:	
		cmp 	al, '%'
		jne 	L4
		inc 	esi
		jmp 	L3
L325:
		dec 	ecx
		dec 	ecx
		mov 	[ebx + ecx], al
		inc 	ecx
L4:
		sub 	esi, esi
L3:
		cmp 	esi, 4
		je 		CYCLE_TRUE
		add 	edx, esi
		cmp 	ecx, edx
		ja 		CYCLE_FALSE
		sub 	edx, esi
		sub 	ah, ah
		jmp 	CYCLE
L2: 	
		cmp 	ah, 0 ;���� ������ ���� '\'
		jne 	L1
		inc 	ah
		mov 	[ebx + ecx], al
		inc 	ecx
		cmp 	ecx, edx
		ja 		CYCLE_FALSE
		jmp 	CYCLE
L1:
		dec 	ah
		jmp 	CYCLE ;����� ��������� �����
		
CYCLE_TRUE: ;���� ���� ������ ��������, �� �� �������� ������������ �����
		sub 	ecx, 4
		cmp 	ecx, 0
		je 		CYCLE_FALSE ;���� ����� ����
		mov 	eax, 1
		jmp 	COMPLETED
CYCLE_FALSE:
		mov 	eax, 0
		sub 	ecx, 4
COMPLETED:;��������� ������ �������, ��������� ����
		
		mov 	edx, [ebp + 16]
		mov 	[edx], ecx
		
		pop 	ebx ;���������� ��������� ���������
		pop 	ecx
		pop 	edx
		pop		esi
		mov 	esp, ebp
		pop 	ebp
		ret 	12
	in_text endp


;---procedure Print_text(var text : string; len : longword);--------------------------------------------------------
	Print_text proc
		push 	ebp
		mov 	ebp, esp
		push 	ecx
		push 	ebx
		push 	eax
		
		mov 	ecx, [ebp + 12];����� ������
		mov 	ebx, [ebp + 8];����� ������ ������
		
		newline
		outstrln '"""'
CYCLE_PRINT:		
		mov 	al, [ebx]
		outchar al
		inc		ebx
		loop 	CYCLE_PRINT
		newline
		outstrln '"""'
		
		pop 	eax
		pop 	ebx
		pop 	ecx
		mov 	esp, ebp
		pop 	ebp
		ret 	8
	Print_text endp

;---procedure Rule_1(var text : string; len : longword);----------------------------------------------------------
	Rule_1 proc
		push 	ebp
		mov 	ebp, esp
		push 	ecx
		push 	ebx
		push 	eax
		
		mov 	ecx, [ebp + 12];����� ������
		mov 	ebx, [ebp + 8];����� ������ ������
		sub 	eax, eax
		
CYCLE_R:		
		;��������� �������� �� ������� ������ �������� ��������� ������
		mov 	al, [ebx] 
		cmp 	al, 'a'
		jb 		K
		cmp 	al, 'z'
		ja 		K
		sub 	al, 'a'
		add 	al, 'A'
		mov 	[ebx], al
		jmp 	K1
K:	
		;��������� �������� �� ������� ������ ��������� ��������� ������
		cmp 	al, 'A'
		jb 		K1
		cmp 	al, 'Z'
		ja 		K1
		sub 	al, 'A'
		add 	al, 'a'
		mov 	[ebx], al
K1:	
		inc 	ebx
		loop 	CYCLE_R
		
		pop 	eax
		pop 	ebx
		pop 	ecx
		mov 	esp, ebp
		pop 	ebp
		ret 	8
	Rule_1 endp

;---procedure Rule_2(var text : string; var len : longword);------------------------------------------------------
	Rule_2 proc
		push 	ebp
		mov 	ebp, esp
		push 	esi
		push 	edx
		push 	ecx
		push 	ebx
		push 	eax
		
		mov 	ecx, [ebp + 12];����� ����� ������
		mov 	ecx, [ecx];����� ������
		mov 	ebx, [ebp + 8];����� ������ ������
		sub 	edx, edx;���������� ����
		sub 	eax, eax
		sub 	esi, esi

		;edx := ���������� ���� � ������
HT:		mov 	al, [ebx + esi]
		inc 	esi
		cmp 	al, '0'
		jb 		H
		cmp 	al, '9'
		ja 		H
		inc 	edx
H:		
		cmp 	esi, ecx
		jne 	HT
		
		
		mov 	esi, edx
		add 	ebx, ecx
		dec 	ebx
		
		;�������� �����
NY:		mov 	al, [ebx]
		mov 	[ebx + esi], al
		dec 	ebx
		cmp 	al, '0'
		jb 		H1
		cmp 	al, '9'
		ja 		H1
		mov 	[ebx + esi], al
		dec 	esi
H1:		
		loop 	NY
		

		mov 	ecx, [ebp + 12]
		add 	[ecx], edx

		pop 	eax
		pop 	ebx
		pop 	ecx
		pop 	edx
		pop 	esi
		mov 	esp, ebp
		pop 	ebp
		ret 	8
	Rule_2 endp
;-----------START--------------------------------------------------------------------------
start :
		ConsoleMode
		ConsoleTitle 	offset prog_ttl ;'Text converter'
		outstrln 		offset hello ;'This is a welcome message!'
		outstrln 		offset entr_1 ;'Enter the first text:'
		
		;���� ������� ������
		lea 	eax, [len1] ; ����� ����� 1-�� ������
		push 	eax
		push 	N ; ������������ ���������� ��������
		lea 	eax, [text1] ; ����� ������ 1-�� ������
		push 	eax
		call 	in_text
		newline
		cmp 	eax, 0
		je 		Err
		newline
		
		;���� ������� ������
		outstrln offset entr_2 ;'Enter second text:' 
		lea 	eax, [len2] ; ����� ����� 2-�� ������
		push 	eax
		push 	N ; ������������ ���������� ��������
		lea 	eax, [text2] ; ����� ������ 2-�� ������
		push 	eax
		call 	in_text 
		newline
		cmp 	eax, 0
		je 		Err
		
		newline
		outstrln offset rule1
		outstrln offset rule2
		newline
		
		;����������� �������� ������
		mov 	eax, len1
		cmp 	eax, len2
		jb 		R2
		
		;��������������
		outstr 		offset txt_1_rule ;'The first text is converted by rule 1'
		outintln 	1
		outstr 		offset txt_2_rule ;'The second text is converted by rule 2'
		outintln 	2
		
		push 	len1 ; ����� 1-�� ������
		lea 	eax, [text1] ;����� ������ 1-�� ������
		push 	eax
		call 	Rule_1

		lea 	eax, [len2] ; ����� ����� 2-�� �����
		push 	eax
		lea 	eax, [text2] ; ����� ������ 2-�� ������
		push 	eax
		call 	Rule_2
		jmp 	M
R2:		
		outstr 		offset txt_1_rule;'The first text is converted by rule 2'
		outintln 	2
		outstr 		offset txt_2_rule;'The second text is converted by rule 2'
		outintln 	1
		
		push 	len2 ;����� 2-�� ������
		lea 	eax, [text2] ;����� ������ 2-�� ������
		push 	eax
		call 	Rule_1
		
		lea 	eax, [len1] ;����� ����� 1-�� ������
		push 	eax
		lea 	eax, [text1] ;����� ������ 1-�� ������
		push 	eax
		call 	Rule_2
M:		
		;������
		push 	len1 ;����� 1-�� ������
		lea 	eax, [text1] ;����� ������ 1-�� ������
		push 	eax
		call 	Print_text
		
		newline
		push 	len2 ;����� 2-�� ������
		lea 	eax, [text2] ;����� ������ 2-�� ������
		push 	eax
		call 	Print_text
		
		;���������� ������
		jmp 	Exit_progr
Err: 
		outstrln 	offset i_err ;'Input error!'

Exit_progr:
		newline
		pause 		offset exit_progr ;'Press any key to exit'
		exit
	end start