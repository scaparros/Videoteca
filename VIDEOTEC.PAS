{Programador: Sergi Caparr¢s Jurado
Fecha Inicio Proyecto: 13-12-1998}
{TIME
13-12-98     23:12 -> 01:52;
14-12-98     15:18 -> 16:27
14-12-98     23:25 -> 00:39
15-12-98     08:00 -> 09:00
15-12-98     15:05 -> 18:06
}
program VIDEOTECA;
uses crt,capa,dos,printer;
type
    semana=array[0..6] of string[9];
    menu1=array[1..7]  of string[30];
    tipo_peli=record
               nom:string;
               dire:string;
               prota:string;
               dura:string;
               ano:string;
               cate:string;
               numero:integer;
    end;
const
     dia:semana=('Domingo','Lunes','Martes','Mi‚rcoles','Jueves','Viernes','S bado');
     opc1:menu1=('A¥ADIR PELICULA','ELIMINAR PELICULA','ORDENAR LISTADO','LISTADO','IMPRIMIR','BUSCAR PELICULA','SALIR');

var
auxpeli:tipo_peli; {Primero se guardan aqu¡ los datos y luego se pasan al FILE}
f:file of tipo_peli;{El fichero con los datos}
posi:byte; {Posici¢n del cursor}
dd,mm,aa,nd:word; {Se guarda la fecha}
ch:char;{Guarda la tecla pulsada en el men£ de fechas}
Procedure cursor;
Begin
     asm
        mov ah,1h
        mov cl,31h
        mov ch,31h
        int 10h
     end;
end;
Procedure abre_fichero;
Begin
     {$I-}
          reset (f);
     {$I+}
     if ioresult<>0 then Begin
        rewrite (f);
        close (f);
        reset (f);
     end;
end;
Procedure sonido;
Begin
     sound (400);
     delay (50);
     sound (5000);
     delay (50);
     nosound;
end;
Procedure noabierto;
Begin
     Textbackground (White);
     Clrscr;
     Textbackground (black);
     Textcolor (30);
     sonido;
     Centra ('ERROR: El fichero "CAPA.DAT" no contiene ning£n registro.',13);
     sonido;
     readkey;
end;
Procedure noencontrado;
Begin
     Textbackground (White);
     Clrscr;
     Textbackground (black);
     Textcolor (30);
     sonido;
     Centra ('ERROR: No se ha encontrado la pelicula especificada.',13);
     sonido;
     readkey;
end;
Procedure num (var cadena:string;max_pos:byte);
var
ch:char;
pos:byte;
auxcadena:string;
Begin
     Textbackground (blue);
     pos:=1;
     auxcadena:='';
     Textcolor (white);
     Repeat
           ch:=Upcase(readkey);
           case ch of
                #13:begin end;
                #08:If pos>1 then Begin
                       pos:=pos-1;
                       Write (ch);
                       Write ('²');
                       Write (ch);
                end;
                '1'..'9','0': if max_pos>pos then begin
                              auxcadena[pos]:=ch;
                              Write (ch);
                              pos:=pos+1;
                              end
                              else sonido;
                else sonido;
           end {Case}
     Until (ch=#13) and (pos>1);
     auxcadena[0]:=chr (pos-1);
     cadena:=auxcadena;
end;
Procedure Alphanum (var cadena:string;max_pos:byte);
var
ch:char;
pos:byte;
auxcadena:string;
Begin
     Textbackground (blue);
     pos:=1;
     auxcadena:='';
     Textcolor (white);
     Repeat
           ch:=Upcase(readkey);
           if ch='¤' then ch:='¥';
           case ch of
                #13:begin end;
                #08:If pos>1 then Begin
                       pos:=pos-1;
                       Write (ch);
                       Write ('²');
                       Write (ch);
                end;
           else if max_pos>pos then begin
                auxcadena[pos]:=ch;
                Write (ch);
                pos:=pos+1;
           end
           else sonido;
           end {Case}
     Until (ch=#13) and (pos>1);
     auxcadena[0]:=chr (pos-1);
     cadena:=auxcadena;
end;
Procedure nume (var num:integer);
var
bandera:byte;
Begin

     Repeat
           Textcolor (White);
           gotoxy (68,23);
           Write ('²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²');
           Textbackground (blue);
           Textcolor (white);Textcolor (30);gotoxy (60,23);Write ('N£mero: ');
           Textcolor (white);
           {$i-}
                read(num);
           {$i+}
           bandera:=ioresult;
           if (bandera<>0) or (num>9999) or (num<0) then sonido;
     until (num<9999) and (bandera=0) and (num>=0);
end;
Procedure pelicula;
VAR
 i:integer;
 b:word;
BEGIN
 i:=0;
 Textbackground (black);
 ClrScr;
 Textcolor (Yellow);
 Gotoxy(30,20);writeln('Este programa es FREEWARE');
 Textcolor (green);
 Gotoxy(30,22);Writeln ('This program  is FREEWARE');
 Textcolor (red);
 Gotoxy (30,24);Write ('Programado  por   NAZGUL');
 REPEAT
 WHILE (Port[$3DA] AND 8)=0 DO ;
 Portw[$3D4] := $008;
 Writeln;
 Delay(15);
 FOR b:=0 TO $E DO
 BEGIN
 WHILE (Port[$3DA] AND 8)=0 DO ;
 Portw[$3D4]:=$108+B*256;
 Delay(20);
 i:=i+1;
 END;
 UNTIL KeyPressed or (i>=140);
 if i>=140 then Begin
    delay (1000);
    if keypressed then readkey;
 end;
 Portw[$3D4]:=$08;
END;
Procedure fondo;
var
i:byte;
Begin
     Textcolor(white);
     Textbackground (blue);
     clrscr;
     For i:=2 to 24 do
     begin
          gotoxy (1,i);
          Write ('²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²');
     end;
     getdate (aa,mm,dd,nd);
     Textbackground(blue);
     gotoxy (1,1);
     Write ('                                                                                ');
     Centra ('VIDEOTECA v3.0 por Sergio Caparr¢s Jurado',1);
     Textbackground (black);
     Textcolor (white);
     gotoxy (1,1);Write('*        *');
     gotoxy (71,1);Write('*        *');
     Textcolor (30);
     Gotoxy (2,1);Write (' Nazgul');
     Gotoxy (72,1);Write (' Nazgul ');
     textcolor (yellow);
     Textbackground (blue);
     gotoxy (1,25);
     Write ('FECHA ACTUAL: ',dd,'/',mm,'/',aa,' (',dia[nd],')');

end;
Procedure menu;
var
i,y:byte;
Procedure cuadro;
Begin
     Textcolor (lightred);
     Textbackground (blue);
     centra ('ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»',5);
     centra ('º       Menu Principal        º',6);
     centra ('ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹',7);
     centra ('º                             º',8);
     centra ('º                             º',9);
     centra ('º                             º',10);
     centra ('º                             º',11);
     centra ('º                             º',12);
     centra ('º                             º',13);
     centra ('º                             º',14);
     centra ('º                             º',15);
     centra ('º                             º',16);
     centra ('º                             º',17);
     centra ('º                             º',18);
     centra ('º                             º',19);
     centra ('º                             º',20);
     centra ('ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼',21);
end;
Begin
     Repeat
           Textcolor (white);
           Textbackground(0);
           clrscr;
           cuadro;
           y:=8;
           if posi>7 then posi:=1;
           if posi<1 then posi:=7;
           for i:=1 to 7 do
           begin
                if posi=i then textcolor(Yellow)
                else Textcolor(07);
                centra (opc1[i],y);
                y:=y+2;
           end;
           ch:=readkey;
           if ch=#72 then posi:=posi-1;
           if ch=#80 then posi:=posi+1;
     until ch=#13;
End;
Procedure FondoAltas;
Begin
     Textcolor (07);
     textbackground(blue);
     gotoxy(5,5);Write ('Pel¡cula: ');
     gotoxy(5,7);Write ('Director: ');
     gotoxy(5,9);Write ('Protagonistas: ');
     gotoxy(5,11);Write ('Duraci¢n aprox.: ');
     gotoxy (50,11);Write ('A¤o de rodaje: ');
     gotoxy (5,13);Write ('Categor¡a: ');
     gotoxy (60,23);Write ('N£mero: ');
end;
Procedure Altas;
Begin
     abre_fichero;
     Textbackground (Blue);
     Textcolor (Yellow);
     gotoxy(5,5);Write ('Pel¡cula: ');
     Alphanum (auxpeli.nom,64);
     Textcolor (07);gotoxy(5,5);Write ('Pel¡cula: ');
     Textcolor (yellow);gotoxy(5,7);Write ('Director: ');
     Alphanum (auxpeli.dire,64);
     Textcolor (07);gotoxy(5,7);Write ('Director: ');
     Textcolor (yellow);gotoxy(5,9);Write ('Protagonistas: ');
     alphanum (auxpeli.prota,59);
     Textcolor (07);gotoxy(5,9);Write ('Protagonistas: ');
     Textcolor (Yellow);gotoxy(5,11);Write ('Duraci¢n aprox.: ');
     num (auxpeli.dura,5);
     Write (' "');
     Textcolor (07);gotoxy(5,11);Write ('Duraci¢n aprox.: ');
     Textcolor (yellow);gotoxy (50,11);Write ('A¤o de rodaje: ');
     num (auxpeli.ano,5);
     Textcolor (07);gotoxy (50,11);Write ('A¤o de rodaje: ');
     textcolor (yellow);gotoxy (5,13);Write ('Categor¡a: ');
     alphanum (auxpeli.cate,63);
     textcolor (07);gotoxy (5,13);Write ('Categor¡a: ');
     Textcolor (Yellow);gotoxy (60,23);Write ('N£mero: ');
     nume(auxpeli.numero);
     Textcolor (07);gotoxy (60,23);Write ('N£mero: ');
     seek (f,filesize (f));
     write (f,auxpeli);
     close (f);
end;
Procedure muestra_datos (pos:integer);
var
aux_peli:tipo_peli;
Begin
     seek (f,pos);
     read (f,aux_peli);
     with aux_peli do
     begin
          Textbackground (blue);
          Textcolor (lightgreen);
          gotoxy (15,5);Write (nom);
          gotoxy (15,7);Write (dire);
          gotoxy (20,9);write (prota);
          gotoxy (22,11);Write (dura,' "');
          gotoxy (65,11);Write (ano);
          gotoxy (16,13);Write (cate);
          Gotoxy (68,23);Write (numero);
     end;
end;
Procedure listado;
var
pos:integer;{Gurda la posici¢n dentro del fichero que lee en cada momento}
ch:char;{Gurda la tecla, para avanzar o retroceder en el fichero}
bandera:byte; {Guarda el valor de ioresult}
Begin
     {$I-}
          reset (f);
     {$I+}
     bandera:=ioresult;
     if (bandera=0) then
     if (filesize(f)>0) then
     begin
          pos:=0;
          seek (f,pos);
          read(f,auxpeli);
          repeat
                fondo;
                fondoaltas;
                muestra_datos(pos);
                Textcolor (white);gotoxy (40,25);Write ('[ <- ]  [ -> ] [ ESC ]          ',pos+1,'/',filesize(f));
                Repeat
                      ch:=readkey;
                until (ch=#27) or (ch=#77) or (ch=#75);
                if (ch=#77) then
                if not eof(f) then pos:=pos+1
                else sonido;
                if (ch=#75) then
                if (pos>0) then pos:=pos-1
                else sonido;
          until ch=#27
     end
     else noabierto
     else noabierto;
end;
Procedure busca_peli (num:integer;var pos:integer);
var
i:integer;
Begin
     pos:=-1;
     for i:=0 to filesize (f)-1 do
     Begin
          seek (f,i);
          read (f,auxpeli);
          if auxpeli.numero=num then pos:=i;
     end;
end;
     {Devuelve -1 si no lo encuentra, o la posici¢n del fichero si la encuentra}
Procedure busca_peli_nom (nom:string;var pos:integer);
var
i:integer;
Begin
     pos:=-1;
     for i:=0 to filesize (f)-1 do
     Begin
          seek (f,i);
          read (f,auxpeli);
          if auxpeli.nom=nom then pos:=i;
     end;
end;
Procedure Busca;
var
nom:string;
ch:char;
pos:integer;
Begin
     {$i-}
          Reset (f);
     {$i+}
     if ioresult<>0 then noabierto
     else begin

          fondo;
          fondoaltas;
          Textcolor (30);
          gotoxy(5,5);Write ('Pel¡cula: ');
          Alphanum (nom,64);
          busca_peli_nom (nom,pos);
          if pos=-1 then noencontrado
          else Begin
               Textcolor (07);
               gotoxy(5,5);
               Write ('Pel¡cula: ');
               Textcolor (white);
               gotoxy (40,25);
               Write ('ESC -> salir');
               muestra_datos (pos);
               repeat
                     ch:=readkey;
               until ch=#27;
          end;

     end;
end;
Procedure eliminar (pos:integer);
var
f2:file of tipo_peli;
aux_peli:tipo_peli;
i:integer;
ch:char;
Begin
     Textbackground (black);
     Textcolor (yellow);
     Centra ('Seguro que desea eliminar esta pel¡cula. (S/N)',12);
     Repeat
           ch:=upcase (readkey);
     until (ch='S') or (ch='N');
     if ch='S'then
     Begin
          assign (f2,'bajas.cap');
          rewrite (f2);
          for i:=pos to filesize (f)-2 do
          begin
               seek (f,i+1);
               read (f,auxpeli);
               seek (f,i);
               Write (f,auxpeli);
          end;
          for i:=0 to filesize(f)-1 do
          begin
               seek (f,i);
               read (f,aux_peli);
               seek (f2,i);
               write (f2,aux_peli);
          end;
          rewrite (f);
          for i:=0 to filesize (f2)-2 do
          begin
               seek (f2,i);
               read (f2,aux_peli);
               seek (f,i);
               write (f,aux_peli);
          end;
     end;
     {$i-}
          Reset (f2);
     {$i+}
     if ioresult=0 then close (f2);
end;
Procedure bajas;
var
pos:integer;{Se guarda la posicion, si encuentra la peli}
Begin
     {$i-}
          reset (f);
     {$I+}
     if ioresult=0 then
     begin
          fondo;
          fondoaltas;
          Textcolor (30);gotoxy (60,23);Write ('N£mero: ');
          nume(auxpeli.numero);

          busca_peli (auxpeli.numero,pos);
          if pos=-1 then noencontrado
          else Begin
               muestra_datos (pos);
               eliminar(pos);
          end;
          close (F);
     end
     else noabierto;
end;
Procedure imprime (pos:integer);
var ch:char;
Begin
     Textbackground (black);
     Textcolor (yellow);
     Centra ('Seguro que desea imprimir esta pel¡cula. (S/N)',12);
     Repeat
           ch:=upcase (readkey);
     until (ch='S') or (ch='N');
     if ch='S' then
     Begin
          seek (f,pos);
          read(f,auxpeli);
          with auxpeli do
          Begin
               Writeln (lst);
               Writeln (lst);
               Writeln (lst);
               Writeln (lst,'   * * * Videotec by Sergio Caparr¢s Jurado * * *');
               Writeln (lst);
               Writeln (lst,'   Pel¡cula: ',nom);
               Writeln (lst);
               Writeln (lst,'   Director: ',dire);
               Writeln (lst);
               Writeln (lst,'   Protagonista/s: ',prota);
               Writeln (lst);
               Writeln (lst,'   Duraci¢n: ',dura,' "');
               Writeln (lst);
               Writeln (lst,'   Categor¡a: ',cate);
               Writeln (lst);
               Writeln (lst,'   NUMERO: ',numero);
               Writeln (lst);
               Writeln (lst,'   * * * Videotec by Sergio Caparr¢s Jurado * * *');
          end;
     end;
end;
Procedure imprimir;
var
pos:integer;{Se guarda la posicion, si encuentra la peli}
Begin
     {$i-}
          reset (f);
     {$I+}
     if ioresult=0 then
     begin
          fondo;
          fondoaltas;
          Textcolor (30);gotoxy (60,23);Write ('N£mero: ');
          nume(auxpeli.numero);
          Textcolor (07);gotoxy (60,23);Write ('N£mero: ');
          busca_peli (auxpeli.numero,pos);
          if pos=-1 then noencontrado
          else Begin
               muestra_datos(pos);
               imprime (pos);
          end;
          close (F);
     end
     else noabierto;
end;
Procedure orden1;
var
auxpeli3,auxpeli2:tipo_peli;
i,j:integer;
Begin
     For i:=filesize(f) downto 0 do
         for j:=0 to i-2 do
         Begin
              seek (f,j);
              read (f,auxpeli);
              seek (f,j+1);
              read (f,
              auxpeli2);
              if auxpeli.nom> auxpeli2.nom then
              begin
                   auxpeli3:=auxpeli;
                   auxpeli:=auxpeli2;
                   auxpeli2:=auxpeli3;
                   seek (f,j);
                   write (f,auxpeli);
                   seek (f,j+1);
                   Write (f,auxpeli2);
              end;
         end;
end;
Procedure orden2;
var
auxpeli3,auxpeli2:tipo_peli;
i,j:integer;
Begin
     For i:=filesize(f) downto 0 do
         for j:=0 to i-2 do
         Begin
              seek (f,j);
              read (f,auxpeli);
              seek (f,j+1);
              read (f,
              auxpeli2);
              if auxpeli.numero> auxpeli2.numero then
              begin
                   auxpeli3:=auxpeli;
                   auxpeli:=auxpeli2;
                   auxpeli2:=auxpeli3;
                   seek (f,j);
                   write (f,auxpeli);
                   seek (f,j+1);
                   Write (f,auxpeli2);
              end;
         end;
end;
Procedure ordenar;
var
ch:char;
Begin
     {$i-}
          Reset (f);
     {$i+}
     if ioresult=0 then begin
        Textbackground (black);
        clrscr;
        Textbackground (white);
        Textcolor (black);
        Centra ('   1-. Ordenar por nombre de pelicula.   ',12);
        centra ('   2-. Ordenar por n£mero   ',14);
        Repeat
              ch:=readkey;
        until (ch='1') or (ch='2');
        case ch of
             '1':orden1;
             '2':orden2;
        end {case}
     end
     else noabierto;
end;
Begin
    if paramstr(1)='spain' then Begin
       spain;
       if keypressed then readkey;
    end;
    if paramstr(1)='cata' then Begin
       cata;
       if keypressed then readkey;
    end;
    cursor;
    assign (f,'capa.dat');
    posi:=1;
    {vuelo;}
    CLrscr;
    pelicula;
    if keypressed then readkey;
    Repeat
          menu;
          case posi of
               1:Begin
                      fondo;
                      fondoaltas;
                      altas;
               end;
               2:Bajas;
               3:Ordenar;
               4:Begin
                      Listado;
               end;
               5:imprimir;
               6:Busca;
          end; {case}
    Until (posi=7) and (ch=#13);
    {$i-}
         reset (f);
    {$i+}
    if ioresult=0 then close (f);
end.