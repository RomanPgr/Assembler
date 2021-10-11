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
		
		mov		ebx, [ebp + 8] ;В этом регистре адрес начала массива
		mov 	edx, [ebp + 12] ;В этом регистре максимальная длина массива = 512
		sub 	ecx, ecx ;Количество символов
		sub 	eax, eax ;ah = 1 если перед текущим символом был одиночный обратный слеш, иначе 0. В al текущий символ
		sub 	esi, esi ;Проверяет условие конца текста
	
CYCLE:	
		cmp 	ah, 0 ;Начало основного цикла ввода
		jne 	L6 ; Сохраним значение ah 0 или 1
		readkey ;Должен поместить символ в al
		sub 	ah, ah
		jmp 	L7
L6:		
		readkey
		mov 	ah, 1 
L7:		
		cmp 	al, 13 ;Символ воврата каретки
		jne 	L5
		mov 	al, 10 ;Символ новой строки
L5:	
		outchar al ;Ввод с эхом
		cmp 	al, '\' 
		je 		L2
		mov 	[ebx + ecx], al ;Если символ не '\'
		inc 	ecx ;Увеличиваем количество символов
		cmp 	ah, 1 
		je 		L325 ;Если перед текущим символом был обратный слеш
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
		cmp 	ah, 0 ;Если введён знак '\'
		jne 	L1
		inc 	ah
		mov 	[ebx + ecx], al
		inc 	ecx
		cmp 	ecx, edx
		ja 		CYCLE_FALSE
		jmp 	CYCLE
L1:
		dec 	ah
		jmp 	CYCLE ;Конец основного цикла
		
CYCLE_TRUE: ;Если ввод текста завершён, он не превысим максимальную длину
		sub 	ecx, 4
		cmp 	ecx, 0
		je 		CYCLE_FALSE ;Если текст пуст
		mov 	eax, 1
		jmp 	COMPLETED
CYCLE_FALSE:
		mov 	eax, 0
		sub 	ecx, 4
COMPLETED:;Завершаем работу функции, подчищаем стек
		
		mov 	edx, [ebp + 16]
		mov 	[edx], ecx
		
		pop 	ebx ;Возвращаем состояния регистров
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
		
		mov 	ecx, [ebp + 12];Длина текста
		mov 	ebx, [ebp + 8];Адрес начала текста
		
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
		
		mov 	ecx, [ebp + 12];Длина текста
		mov 	ebx, [ebp + 8];Адрес начала текста
		sub 	eax, eax
		
CYCLE_R:		
		;Проверить является ли текущий символ строчной латинской буквой
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
		;Проверить является ли текущий символ заглавной латинской буквой
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
		
		mov 	ecx, [ebp + 12];Адрес длины текста
		mov 	ecx, [ecx];Длина текста
		mov 	ebx, [ebp + 8];Адрес начала текста
		sub 	edx, edx;Количество цифр
		sub 	eax, eax
		sub 	esi, esi

		;edx := количество цифр в тексте
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
		
		;Удвоение чисел
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
		
		;Ввод первого текста
		lea 	eax, [len1] ; Адрес длины 1-го текста
		push 	eax
		push 	N ; Максимальное количество символов
		lea 	eax, [text1] ; Адрес начала 1-го текста
		push 	eax
		call 	in_text
		newline
		cmp 	eax, 0
		je 		Err
		newline
		
		;Ввод второго текста
		outstrln offset entr_2 ;'Enter second text:' 
		lea 	eax, [len2] ; Адрес длины 2-го текста
		push 	eax
		push 	N ; максимальное количество символов
		lea 	eax, [text2] ; Адрес начала 2-го текста
		push 	eax
		call 	in_text 
		newline
		cmp 	eax, 0
		je 		Err
		
		newline
		outstrln offset rule1
		outstrln offset rule2
		newline
		
		;Определение большего текста
		mov 	eax, len1
		cmp 	eax, len2
		jb 		R2
		
		;Преобразование
		outstr 		offset txt_1_rule ;'The first text is converted by rule 1'
		outintln 	1
		outstr 		offset txt_2_rule ;'The second text is converted by rule 2'
		outintln 	2
		
		push 	len1 ; Длина 1-го текста
		lea 	eax, [text1] ;Адрес начала 1-го текста
		push 	eax
		call 	Rule_1

		lea 	eax, [len2] ; Адрес длины 2-го теста
		push 	eax
		lea 	eax, [text2] ; Адрес начала 2-го текста
		push 	eax
		call 	Rule_2
		jmp 	M
R2:		
		outstr 		offset txt_1_rule;'The first text is converted by rule 2'
		outintln 	2
		outstr 		offset txt_2_rule;'The second text is converted by rule 2'
		outintln 	1
		
		push 	len2 ;Длина 2-го текста
		lea 	eax, [text2] ;Адрес начала 2-го текста
		push 	eax
		call 	Rule_1
		
		lea 	eax, [len1] ;Адрес длины 1-го текста
		push 	eax
		lea 	eax, [text1] ;Адрес начала 1-го текста
		push 	eax
		call 	Rule_2
M:		
		;Печать
		push 	len1 ;Длина 1-го текста
		lea 	eax, [text1] ;Адрес начала 1-го текста
		push 	eax
		call 	Print_text
		
		newline
		push 	len2 ;Длина 2-го текста
		lea 	eax, [text2] ;Адрес начала 2-го текста
		push 	eax
		call 	Print_text
		
		;Завершение работы
		jmp 	Exit_progr
Err: 
		outstrln 	offset i_err ;'Input error!'

Exit_progr:
		newline
		pause 		offset exit_progr ;'Press any key to exit'
		exit
	end start