program msg_documentation;
{
Auteur: Patrick Pr‚martin.
Date: 27/07/1992.
      30/07/1992.
      31/07/1992.
Langage: Turbo Pascal 6.0
But: Impression de la documentation complŠte concernant un fichier MSG.
}

uses
    printer,
    u_chaine,
    u_ger_chaine,
    u_msg;

const
     num_ver = '1.0';
     dat_ver = '07/31/1992';

procedure imprime_doc (langue, param : string);
var
   i : word;
   first : boolean;
   ch : string;
begin
     writeln (lst, 'Documentation du fichier de messages: '+set_maj_chaine (nom_fich_msg));
     writeln (lst);
     writeln (lst, '     * Langue: ', langue);
     writeln (lst, '     * ParamŠtre du programme: ', param);
     writeln (lst);
     for i := 1 to get_nb_msg do
         begin
              first := true;
              ch := get_msg (i);
              writeln (lst, 'ÚÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
              repeat
                    if first
                    then
                        writeln (lst, '³', i : 5, '³', copy (ch, 1, 72), trait (#178, 72-length (ch)), '³')
                    else
                        writeln (lst, '³     ³', copy (ch, 1, 72), trait (#178, 72-length (ch)), '³');
                    {endif}
                    delete (ch, 1, 72);
                    first := false;
              until (length (ch) < 1);
         end;
     {endfor}
     writeln (lst, #12);
end; { imprime_doc }

begin
     writeln ('MSG Documentation ('+num_ver+')');
     writeln ('(c) Patrick Pr‚martin '+dat_ver);
     writeln ('(c) Olf Software 1992');
     writeln;
     if (paramcount = 0)
     then
         begin
              writeln ('Syntax:');
              writeln ('       MSGDOC Nom_Fich.MSG');
              writeln;
         end
     else
         begin
         init_msg (paramstr (1));
              if (set_langue (msg_f))
              then
                  imprime_doc ('Fran‡ais', '/FRANCAIS');
              {endif}
              if (set_langue (msg_gb))
              then
                  imprime_doc ('Anglais', '/ENGLISH');
              {endif}
              if (set_langue (msg_d))
              then
                  imprime_doc ('Allemand', '/DEUTSCH');
              {endif}
              if (set_langue (msg_i))
              then
                  imprime_doc ('Italien', '/ITALIAN');
              {endif}
         end;
     {endif}
end.
