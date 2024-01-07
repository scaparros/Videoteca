Unit capa;
Interface
uses graph,crt;
Procedure nada;
Procedure centra(texto:string;y:byte);
Procedure Pon_cursor;
Procedure Quitar_cursor;
Procedure scroll_peli(texto:string;y:byte);
Procedure vuelo;
Procedure Spain;
Procedure cata;

IMPLEMENTATION

Procedure nada;
Begin
     clrscr;
end;
Procedure centra (texto:string;y:byte);
var
x:integer;
Begin
     x:=40 - round (length(texto)/2);
     gotoxy (x,y);
     Writeln (texto);
end;
Procedure Pon_cursor; Assembler;
asm
   mov ah,1h
   mov ch,10h
   mov cl,11h
   int 10h
end;
Procedure quitar_cursor; Assembler;
asm
   mov ah,1h
   mov ch,31h
   mov cl,31h
   int 10h
end;

Procedure scroll_peli (texto:string;y:byte);
VAR
 b:word;
BEGIN
 ClrScr;
 Gotoxy(30,y);write(texto);
 Gotoxy(1,24);
 REPEAT
 WHILE (Port[$3DA] AND 8)=0 DO ;
 Portw[$3D4] := $008;
 Writeln;
 Delay(15);
 FOR b:=0 TO $E DO
 BEGIN
 WHILE (Port[$3DA] AND 8)=0 DO ;
 Portw[$3D4]:=$108+B*256;
 Delay(15);
 END;
 UNTIL KeyPressed;
 Portw[$3D4]:=$08;
END;
Procedure vuelo;
TYPE

 Pointrec = RECORD

 sX, sY, ox, oy: LongInt;

 oapo, apo, c : Byte;

 END;

VAR

 Parr : Array[1..255] Of Pointrec;

 GD,GM,mx,my,I,cc,j,smx,smy : Integer;

 kl : LongInt;

 ch : Char;

 rx,ry,tx,ty : LongInt;

 starnum,decv : Byte;

BEGIN

 IF paramcount=0 THEN starnum:=120 ELSE val(paramstr(1),starnum,i);

 IF starnum<30 THEN starnum:=120;

 DetectGraph(GD,GM);

{la siguiente línea indica el path donde se sitúan los controladores
gráficos *.bgi dentro de nuestro disco duro}

 InitGraph(GD,GM,'c:\util\dos\tp7\bgi');

 mx:=getmaxx; my:=getmaxy; smx:=mx div 2; smy:=my div 2;

 decv:=starnum div 30;

 Randomize;

 FillChar(Parr,SizeOF(Parr),0);

 FOR i:=1 TO starnum DO WITH Parr[i] DO

 BEGIN

 sx:=(random(Succ(mx))-smx)*80; sy:=(random(Succ(my))-smy)*60;

 apo:=random(200)+decv;

 c:=Random(7)+1;

 ox:=sx; oy:=sy; oapo:=apo;

 END;

 REPEAT

 FOR i:=1 TO starnum DO WITH Parr[i] DO

 BEGIN

 oapo:=apo; ox:=sx; oy:=sy;

 dec(apo,decv);

 RX:=(sx div SUCC(apo))+smx;

 RY:=(sy div SUCC(apo))+smy;

 TX:=(ox div SUCC(oapo))+smx;

 TY:=(oy div SUCC(oapo))+smy;

 IF (RX>640) OR (RY>480) OR (RX<0) OR (RY<0) OR (APO<decv) THEN

 BEGIN

 sx:=(random(Succ(mx))-smx)*80; sy:=(random(Succ(my))-smy)*60;

 apo:=200+decv;

 RX:=(sx div SUCC(apo))+smx; RY:=(sy div SUCC(apo))+smy;

 END;

 IF apo>120 THEN cc:=C ELSE cc:=C+8;

 PutPixel(TX,TY,0); PutPixel(RX,RY,cc);

 IF OAPO<70 THEN PutPixel(TX+1,TY+1,0);

 IF APO<70 THEN PutPixel(RX+1,RY+1,cc);

 IF OAPO<60 THEN PutPixel(TX+1,TY,0);

 IF APO<60 THEN PutPixel(RX+1,RY,cc);

 IF OAPO<50 THEN PutPixel(TX,TY+1,0);

 IF APO<50 THEN PutPixel(RX,RY+1,cc);

 IF OAPO<40 THEN PutPixel(TX-1,TY-1,0);

 IF APO<40 THEN PutPixel(RX-1,RY-1,cc);

 IF OAPO<30 THEN PutPixel(TX+2,TY+2,0);

 IF APO<30 THEN PutPixel(RX+2,RY+2,cc);

 IF OAPO<20 THEN BEGIN

 PutPixel(TX+2,TY-1,0); PutPixel(TX-1,TY+2,0);

 END;

 IF APO<20 THEN BEGIN

 PutPixel(RX+2,RY-1,cc); PutPixel(RX-1,RY+2,cc);

 END;

 END;

 UNTIL KeyPressed;

 WHILE KeyPressed DO ch:= ReadKey;

 Closegraph;

END;
Procedure spain;
const
  gseg : word = $a000;
  spd = 2; size = 3; curve = 125;
  xmax = 200 div size;
  ymax = 100 div size;
  sofs = 50; samp = 5; slen =255;
var stab : array[0..slen] of word;
procedure csin; var i : byte; begin
  for I := 0 to slen do stab[i] := round(sin(i*4*pi/slen)*samp)+sofs; end;
procedure displaymap;
type scrarray = array[0..xmax,0..ymax] of byte;
var
  postab : array[0..xmax,0..ymax] of word;
  bitmap : scrarray;
  x,y,xp,yp,sidx : word;
begin
  fillchar(bitmap,sizeof(bitmap),0);
  sidx := 0;
  for x := 0 to xmax do
    for y := 0 to (ymax div 3) do bitmap[x,y] := Red;
  for x := 0 to xmax do
    for y := (ymax div 3) to 2*(ymax div 3) do bitmap[x,y] := Yellow;
  for x := 0 to xmax do
    for y := 2*(ymax div 3) to ymax do bitmap[x,y] := Red;
  repeat
    while (port[$3da] and 8) <> 0 do;
    while (port[$3da] and 8) = 0 do;
    for x := 0 to xmax do
      for y := ymax downto 0 do begin
        mem[gseg:postab[x,y]] := 0;
        xp := size*x+stab[(sidx+curve*x+curve*y) mod slen];
        yp := size*y+stab[(sidx+4*x+curve*y+y) mod slen];
        postab[x,y] := xp+yp*320;
        mem[gseg:postab[x,y]] := bitmap[x,y];
      end;
    sidx := (sidx+spd) mod slen;
  until keypressed;
end;
begin
  csin;
  asm mov ax,13h; int 10h; end;
  displaymap;
  textmode(lastmode);
end;

Procedure cata;
const
  gseg : word = $a000;
  spd = 2; size = 3; curve = 125;
  xmax = 200 div size;
  ymax = 100 div size;
  sofs = 50; samp = 5; slen =255;
var stab : array[0..slen] of word;

procedure csin; var i : byte; begin
  for I := 0 to slen do stab[i] := round(sin(i*4*pi/slen)*samp)+sofs; end;

procedure displaymap;
type scrarray = array[0..xmax,0..ymax] of byte;
var
  postab : array[0..xmax,0..ymax] of word;
  bitmap : scrarray;
  x,y,xp,yp,sidx : word;
begin
  fillchar(bitmap,sizeof(bitmap),0);
  sidx := 0;
  for x := 0 to xmax do
    for y := 0 to (ymax div 7) do bitmap[x,y] := Red;
  for x := 0 to xmax do
    for y := (ymax div 7) to 2*(ymax div 7)-1 do bitmap[x,y] := Yellow;
  for x := 0 to xmax do
      for y:= (2*ymax div 7)-1 to 3*(ymax div 7)-1 do bitmap[x,y]:=red;
  for x := 0 to xmax do
      for y:= (3*ymax div 7)-2 to 4*(ymax div 7)-1 do bitmap[x,y]:=yellow;
  for x := 0 to xmax do
      for y:= (4*ymax div 7)-2 to 5*(ymax div 7)-1 do bitmap[x,y]:=red;
  for x := 0 to xmax do
      for y:= (5*ymax div 7)-3 to 6*(ymax div 7)-1 do bitmap[x,y]:=yellow;
  for x := 0 to xmax do
      for y:= (6*ymax div 7)-4 to ymax-6 do bitmap[x,y]:=red;

  repeat
    while (port[$3da] and 8) <> 0 do;
    while (port[$3da] and 8) = 0 do;
    for x := 0 to xmax do
      for y := ymax downto 0 do begin
        mem[gseg:postab[x,y]] := 0;
        xp := size*x+stab[(sidx+curve*x+curve*y) mod slen];
        yp := size*y+stab[(sidx+4*x+curve*y+y) mod slen];
        postab[x,y] := xp+yp*320;
        mem[gseg:postab[x,y]] := bitmap[x,y];
      end;
    sidx := (sidx+spd) mod slen;
  until keypressed;
end;

begin
  csin;
  asm mov ax,13h; int 10h; end;
  displaymap;
  textmode(lastmode);
end;











end.