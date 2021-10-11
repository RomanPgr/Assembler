//{$ASMMODE INTEL}//{$OUTPUT_FORMAT MASM}
{$CALLING STDCALL}
unit MODL;

interface
procedure pod_cross1(var a, b : longint);
procedure pod_cross2(var a, b : longint);
procedure pod_cross3(var a, b : longint);
procedure pod_cross4(var a, b : longint);
function pod_mut1(a : longint) : longint;
function pod_mut2(a : longint) : longint;
function pod_mut3(a : longint) : longint;
implementation

procedure pod_cross1(var a, b : longint);
var 
	t, q : longint;
begin
	if a < b then
	begin
		q := b;
		b := a;
		a := q
	end;
	t := Round(Exp(Random(Trunc(ln(a) / ln(2))) * ln(2)));
	if ((a and t) <> 0) xor ((b and t) <> 0) then
	begin
		a := a xor t;
		b := b xor t
	end
end;

procedure pod_cross2(var a, b : longint);
begin
	pod_cross1(a, b);
	pod_cross1(a, b)
end;

procedure pod_cross3(var a, b : longint);
var 
	i, x, y : longint;
begin
	i := 1;
	x := 0;
	y := 0;
	while i < 65536 do
	begin
		if odd(Random(2)) then
		begin
			x := x or (a and i);
			y := y or (b and i)
		end
		else
		begin
			x := x or (b and i);
			y := y or (a and i);
		end;
		i := i * 2
	end;
	if x <> 0 then
		a := x mod 65535;
	if y <> 0 then
		b := y mod 65535
end;

procedure pod_cross4(var a, b : longint);
var
	t, i, x, y : longint;
begin
	x := 0;
	y := 0;
	i := 1;
	t := Random(65535) + 1;
	while i < 65536 do
	begin
		if (t and i) <> 0 then
		begin
			x := x or (a and i);
			y := y or (b and i)
		end
		else
		begin
			x := x or (b and i);
			y := y or (a and i)
		end;
		i := i * 2
	end;
	a := x;
	b := y
end;

function pod_mut1(a : longint) : longint;
begin
	pod_mut1 := a xor Round(Exp(Random(Trunc(ln(a) / ln(2))) * ln(2)));
end;

function pod_mut2(a : longint) : longint;
begin
	pod_mut2 := (a xor Round(Exp(Random(Trunc(ln(a) / ln(2))) * ln(2)))) 
				   xor Round(Exp(Random(Trunc(ln(a) / ln(2))) * ln(2)));
end;

function pod_mut3(a : longint) : longint;
var 
	k, i, t, l : longint;
begin
	k := Random(Trunc(ln(a) / ln(2))) + 1;
	t := Round(Exp((k - 1) * ln(2)));
	l := 1;
	for i := 1 to k div 2 do
	begin
		if ((a and t) <> 0) xor ((a and l) <> 0) then
			a := a xor t xor l;
		l := l * 2;
		t := t div 2
	end;
	pod_mut3 := a
end;
	
end.