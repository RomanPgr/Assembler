//{$L MOD.o}
{$CALLING STDCALL}
unit modul;

interface

type
	mas_long = array of longint;
	mas_doub = array of double;
	TF = function (x : longint) : double;
	
const
	Two_in_15 = 32768; {2^15}
	
procedure Crossing(F : TF; var x : mas_long; var y : mas_doub; N, 
					Num_cross, modification : longint);

procedure Mutation(F : TF; var x : mas_long; var y : mas_doub; N, 
					Num_mut, modification : longint);

procedure Sort_two_array(var x : mas_long; var y : mas_doub; N : longint);

implementation

uses MODL;

{procedure Pod_cross1(var a, b : longint); stdcall; external 'MODL.obj' name '_MODL_$$_POD_CROSS1$LONGINT$LONGINT$0';
procedure Pod_cross2(var a, b : longint); stdcall; external 'MODL.obj' name '_MODL_$$_POD_CROSS2$LONGINT$LONGINT$0';
procedure Pod_cross3(var a, b : longint); stdcall; external 'MODL.obj' name '_MODL_$$_POD_CROSS3$LONGINT$LONGINT$0';
procedure Pod_cross4(var a, b : longint); stdcall; external 'MODL.obj' name '_MODL_$$_POD_CROSS4$LONGINT$LONGINT$0';
function Pod_mut1(a : longint) : longint; stdcall; external 'MODL.obj' name '_MODL_$$_POD_MUT1$LONGINT$$LONGINT$0';
function Pod_mut2(a : longint) : longint; stdcall; external 'MODL.obj' name '_MODL_$$_POD_MUT2$LONGINT$$LONGINT$0';
function Pod_mut3(a : longint) : longint; stdcall; external 'MODL.obj' name '_MODL_$$_POD_MUT3$LONGINT$$LONGINT$0';}

procedure Crossing(F : TF; var x : mas_long; var y : mas_doub; N, Num_cross, 
					modification : longint);
var 
	k, i, a, b : longint;
begin
	k := 1;
	while (x[k] <> 0) and (k < N) do
		k := k + 1;
	if x[k] = 0 then
		while (k <= N) and (Num_cross > 0) do
		begin
			i := 0;
			repeat
				i := i + 1;
				a := x[Random(k - 1) + 1];
				b := x[Random(k - 1) + 1];
			until (a <> b) or (i = 1000);
			case modification of
				1 : pod_cross1(a, b);
				2 : pod_cross2(a, b);
				3 : pod_cross3(a, b);
				4 : pod_cross4(a, b);
			end;
			x[k] := a;
			y[k] := F(x[k]);
			if k < N then
			begin
				x[k + 1] := b;
				y[k + 1] := F(x[k +1]);
				k := k + 1;
				Num_cross := Num_cross - 1
			end;
			k := k + 1;
			Num_cross := Num_cross - 1
		end
end;

procedure Mutation(F : TF; var x : mas_long; var y : mas_doub; N, Num_mut, 
					modification : longint);
var 
	k, a : longint;
begin
	k := 1;
	while (x[k] <> 0) and (k < N) do
		k := k + 1;
	if x[k] = 0 then
		while (k <= N) and (Num_mut > 0) do
		begin
			a := x[Random(k - 1) + 1];
			case modification of 
				1 : x[k] := pod_mut1(a);
				2 : x[k] := pod_mut2(a);
				3 : x[k] := pod_mut3(a);
			end;
			y[k] := F(x[k]);
			k := k + 1;
			Num_mut := Num_mut - 1
		end
end;

procedure Sort_two_array(var x : mas_long; var y : mas_doub; N : longint);
var
	i, j, k, l, tx : longint;
	ty : double;
begin
	l := N;
	k := 2;
	for i := 1 to  N - 1 do
	begin
		for j := N downto k do
			if y[j] > y[j - 1] then
			begin
				l := j;
				tx := x[j];
				ty := y[j];
				x[j] := x[j - 1];
				y[j] := y[j - 1];
				x[j - 1] := tx;
				y[j - 1] := ty
			end;
		if l < N then
			k := l + 1
		else
			Exit
	end
end;
end.
