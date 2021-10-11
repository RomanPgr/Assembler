{$I-}{$H+}{$R-}{$CALLING STDCALL}
uses modul;
const
	Two_in_15 = 32768; {2^15}
	
type
	mas_long = array of longint;
	mas_doub = array of double;
	conf_const = record
		Eps, Permissible_y : double;
		N, Iterations,  Max_const_iter,  Inviolability, Percent : longint;
		Modif_cross, Modif_mut, Percent_mut, Percent_cross : longint;
	end;
	
var
	test_mode, output_test : boolean;
	temp_data : string;
	i, k, sequence_eps, Num_mut, Num_cross, Num_shot : longint;
	population_x : mas_long;
	population_y : mas_doub;
	log, f_conf : text;
	pre_max_y : double;
	configuration : conf_const;
	

	
function F(n : longint) : double;
var
	x : double;
begin
	x := (2 * n - 1) / Two_in_15;
	{F := (x - 2) * (x - 2.5) * (x - 3.5) * (1 - Exp(x - 1.5))}
	{F := (x-1)*(x-1)*(x-1)*(x-1)*(x-1)*(x-0.05)*(x-3)*(x-3.5)*(1-Exp(x-3.95))*ln(x+0.22)}
	{F := (x-3)*(x-2)*(x-0.01)*(x-0.01)*(x-0.01)*(x-0.01)*(x-3.99)*(x-3.99)*(x-3.99)*(x-3.99)*(1-Exp(x-1.5))*sin(x/3+0.2)}
	F := x*(x-1.1)*(x-1.1)*(x-1.1)*(x-1.1)*(x-1.1)*(x-1.2)*(x-1.2)*(x-1.2)*(x-1.2)*(x-1.3)*(x-1.3)*(x-1.3)*cos(x+100)
	{F := x*sin(x+5)*cos(x-6)*sin(x+7)*cos(x-8)*sin(x/3)}
	{F := x*(x-2)*(x-2.75)*cos(x/10)*(2-Exp((x-2)*ln(3)))*Exp(x/10)}
end;
	
procedure Config(var configuration : conf_const; var f_conf : text);
var
	c : char;
	i : longint;
	s : string;
	b : boolean;
begin
	with configuration do
	begin
		N := 300;
		Iterations := 200;
		Eps := 0.000000000000001;
		Max_const_iter := 30;
		Permissible_y := 9E300;
		Inviolability := 10;
		Percent := 50;
		Percent_cross := 50;
		Percent_mut := 30;
		Modif_cross := 1;
		Modif_mut := 1;
		Assign(f_conf, 'config.txt');
		Reset(f_conf);
		b := false;
		if IoResult <> 0 then
			b := true;
		if b then
			WriteLn('No configuration file found. The default settings are used.')
		else
			while not eof(f_conf) do
			begin
				s := '';
				i := 0;
				while not eoln(f_conf) and (i < 2) do
				begin
					Read(f_conf, c);
					if c in ['#', #10, #13] then
					begin
						ReadLn(f_conf);
						Break
					end;
					s := s + c;
					if c = ' ' then
						i := i + 1
				end;
				case s of 
					'N = '              : ReadLn(f_conf, N);
					'Iterations = '     : ReadLn(f_conf, Iterations);
					'Eps = '            : ReadLn(f_conf, Eps);
					'Max_const_iter = ' : ReadLn(f_conf, Max_const_iter);
					'Permissible_y = '  : ReadLn(f_conf, Permissible_y);
					'Inviolability = '  : ReadLn(f_conf, Inviolability);
					'Percent = '        : ReadLn(f_conf, Percent);
					'Percent_cross = '	: ReadLn(f_conf, Percent_cross);
					'Percent_mut = '	: ReadLn(f_conf, Percent_mut);
					'Modif_cross = '    : ReadLn(f_conf, Modif_cross);
					'Modif_mut = '      : ReadLn(f_conf, Modif_mut)
				end;
				if eoln(f_conf) then
					ReadLn(f_conf, s);
				if IoResult <> 0 then
				begin
					WriteLn('Configuration file error.');
					ReadLn();
					Halt()
				end
			end;
		if (N < 10) or (Percent_cross + Percent_mut > 100) or (Percent_cross < 0)
			or (Percent_mut < 0) or (Inviolability >= N) or (Inviolability < 1)
			or (Iterations < 1) or (Percent < 1) or not (Modif_mut in [1..3])
			or (N * Percent / 100 + 1 > N - Inviolability) or not (Modif_cross in [1..4])then
		begin
			WriteLn('Invalid values in the configuration file.');
			ReadLn();
			Halt()
		end;
		WriteLn('The following parameters are accepted:');
		WriteLn('N =              ', N);
		WriteLn('Iterations =     ', Iterations);
		WriteLn('Eps =           ', Eps);
		WriteLn('Max_const_iter = ', Max_const_iter);
		WriteLn('Permissible_y = ', Permissible_y);
		WriteLn('Inviolability =  ', Inviolability);
		WriteLn('Percent =        ', Percent, '%');
		WriteLn('Percent_cross =  ', Percent_cross, '%');
		WriteLn('Percent_mut =    ', Percent_mut, '%');
		WriteLn('Modif_cross =    ', Modif_cross);
		WriteLn('Modif_mut =      ', Modif_mut, #10);
	end;
	if not b then
		Close(f_conf)
end;

procedure Write_if_need(test_mode, output_test : boolean; 
			var population_x : mas_long; var population_y : mas_doub;
			var log : text; k, N : longint);
begin
	if test_mode then 
	begin
		if output_test then 
			WriteLn('Population ', k);
		WriteLn(log, 'Population ', k);
		for i := 1 to N do
			begin
				if output_test then
					WriteLn('F(', (2 * population_x[i] - 1) / Two_in_15, ') = ', population_y[i]);
				WriteLn(log, i, #9, population_x[i], #9, 
					(2 * population_x[i] - 1) / Two_in_15, #9, population_y[i])
			end
	end
end;

procedure Shooting(var x : mas_long; var y : mas_doub; N, Num_shot : longint);
var 
	w, i, t : longint;
begin
	i := 0;
	w := Num_shot;
	repeat
		i := i + 1;
		t := Random(N) + 1;
		if (t > configuration.Inviolability) and (x[t] <> 0) then
		begin
			x[t] := 0;
			y[t] := -9E300;
			w := w - 1
		end
	until ((w = 0) or (i = 1000000))
end;

procedure Aliens(var x : mas_long; var y : mas_doub; N : longint);
var 
	k : longint;
begin
	k := 1;
	while (x[k] <> 0) and (k < N) do
		k := k + 1;
	if x[k] = 0 then
		while k <= N do
		begin
			x[k] := Random(65535) + 1;
			y[k] := F(x[k]);
			k := k + 1
		end
end;

procedure Complete(test_mode, output_test : boolean; var population_x : mas_long;
					var population_y : mas_doub; var log : text);
begin
	if test_mode then
	begin
		WriteLn(log, chr(10), 'A maximum of F(', (2 * population_x[1] - 1) / Two_in_15, ') = ', population_y[1], ' is found for ', k, ' iterations');
		if output_test then 
		begin
			WriteLn(chr(10), 'A maximum of F(', (2 * population_x[1] - 1) / Two_in_15, ') = ', population_y[1], ' is found for ', k, ' iterations');
			ReadLn()
		end;
		Close(log)
	end
	else
	begin
		WriteLn(chr(10), 'A maximum of F(', (2 * population_x[1] - 1) / Two_in_15, ') = ', population_y[1], ' is found for ', k, ' iterations');
		ReadLn()
	end;
	Halt()
end;

begin
	Config(configuration, f_conf);
	Num_shot := (configuration.N * configuration.Percent) div 100; {Сколько выстрелов в цель}
	Num_cross := (configuration.Percent_cross * Num_shot) div 100; {Сколько добавляют скрещивание}
	Num_mut := (configuration.Percent_mut * Num_shot) div 100; {Сколько добавляют мутации}
	SetLength(population_x, configuration.N + 1);
	SetLength(population_y, configuration.N + 1);
	k := 1;
	randomize;
	{Подготовка к запуску тестового режима, если требуется}
	Write('Run in test mode? (Yes/No): ');
	ReadLn(temp_data);
	test_mode := (temp_data = 'y') or (temp_data = 'Y') or (temp_data = 'yes') 
					or (temp_data = 'YES') or (temp_data = 'Yes');
	if test_mode then
	begin
		Write('Display each step on the screen? (Yes/No): ');
		ReadLn(temp_data);
		output_test := (temp_data = 'y') or (temp_data = 'Y') or 
				(temp_data = 'yes') or (temp_data = 'YES') or (temp_data = 'Yes');
		Assign(log, 'log.txt');
		ReWrite(log)
	end;
	
	{Формируем 1-ю популяцию}
	i := 0;
	repeat
		i := i + 1;
		population_x[i] := Random(65535) + 1;
		population_y[i] := F(population_x[i])
	until i = configuration.N;
	
	{Сортируем 1-ю популяцию}
	Sort_two_array(population_x, population_y, configuration.N);
	
	{Вывод популяции в файл и на экран}
	Write_if_need(test_mode, output_test, population_x, population_y, log, k, configuration.N);

	{Можем ли завершить работу?}
	if population_y[1] > configuration.Permissible_y then
		Complete(test_mode, output_test, population_x, population_y, log);
	
	sequence_eps := 0;
	pre_max_y := -9E300;
	{Основной цикл алгоритма}
	repeat
		if (not test_mode) {and (population_y[1] > pre_max_y)} then
		begin
			{Write('Iteration ', k, ':');
			for i := 0 to 4 - Trunc(ln(k) / ln(10)) do
				Write(' ');
			WriteLn('F(', (2 * population_x[1] - 1) / Two_in_15, ') = ', population_y[1]);}
			WriteLn('Iteration ', k, ':', #9, 'F(', (2 * population_x[1] - 1) / Two_in_15, ') = ', population_y[1]);
		end;
		pre_max_y := population_y[1];
		k := k + 1; {Поколение}
		
		Shooting(population_x, population_y, configuration.N, Num_shot); {Естественный отбор в популяции}
		
		Sort_two_array(population_x, population_y, configuration.N);
		
		Crossing(@F, population_x, population_y, configuration.N, Num_cross, configuration.modif_cross); {Скрещивание}
		Mutation(@F, population_x, population_y, configuration.N, Num_mut, configuration.modif_mut); {Мутация}
		Aliens(population_x, population_y, configuration.N); {Прилёт инопланетян}
		
		Sort_two_array(population_x, population_y, configuration.N);
		
		{Вывод популяции в файл и на экран}
		Write_if_need(test_mode, output_test, population_x, population_y, log, k, configuration.N);
		
		{Сильно ли отличается от предыдущей?}
		if population_y[1] - pre_max_y < configuration.Eps then
			sequence_eps := sequence_eps + 1
		else
			sequence_eps := 0
					
	until (k = configuration.Iterations) or (sequence_eps = configuration.Max_const_iter) or (population_y[1] >= configuration.Permissible_y);
	
	{Завершаем работу}
	Complete(test_mode, output_test, population_x, population_y, log)
end.