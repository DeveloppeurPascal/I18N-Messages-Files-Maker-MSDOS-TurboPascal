program test_msg;
{
Auteur: Patrick Pr‚martin.
Date: 27/07/1992.
Langage: Turbo Pascal 6.0
But: Programme permettant le test de MKMSG et des unit‚s U_MSG et U_SETUP.
}

uses
    u_setup,
    u_msg;

var
   i : integer;
   b : boolean;
   ch : string;

procedure affiche_msg;
begin
     i := 1;
     ch := get_msg (i);
     while (ch <> '') do
           begin
                writeln (i : 5, ch);
                inc (i);
                ch := get_msg (i);
           end;
     {endwhile}
end; { affiche_msg }

begin
     affiche_msg;
     b := set_langue (msg_f);
     writeln ('Fran‡ais = ', b);
     affiche_msg;
     b := set_langue (msg_gb);
     writeln ('Anglais = ', b);
     affiche_msg;
end.
