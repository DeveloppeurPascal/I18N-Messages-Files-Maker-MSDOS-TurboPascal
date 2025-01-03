program Message_Maker;
{
Auteur: Patrick Pr‚martin.
Date: 27/07/1992.
Langage: Turbo Pascal 6.0
But: Cr‚ation et modification des fichiers .MSG … partir de sources ASCII .TXT
}

uses
    dos,
    u_parametre,
    u_ger_chaine,
    u_msg,
    u_pile;

const
     num_ver = '1.0';
     dat_ver = '07/27/1992';

var
   taille_msg : word;
   langue_autorisee : longint;
   langue_utilisee : longint;
   nb_msg : word;
   liste : p_file;
   nom1,
   nom2 : string;
   ch : string;
   f1 : text;
   f2 : file;
   path : dirstr;
   name : namestr;
   ext : extstr;

procedure ecrit_langue_utilisee;
begin
     ch := set_maj_chaine (ch);
     if (pos ('MSG_F', ch) > 0)
     then
         langue_utilisee := msg_f;
     {endif}
     if (pos ('MSG_GB', ch) > 0)
     then
         langue_utilisee := msg_gb;
     {endif}
     if (pos ('MSG_D', ch) > 0)
     then
         langue_utilisee := msg_d;
     {endif}
     if (pos ('MSG_I', ch) > 0)
     then
         langue_utilisee := msg_i;
     {endif}
     blockwrite (f2, langue_utilisee, sizeof (longint));
end; { ecrit_langue_utilisee }

procedure ecrit_texte;
var
   e : p_elem2;
   ch : string;
begin
     taille_msg := 0;
     nb_msg := 0;
     e := liste^.first;
     while (e <> nil) do
           begin
                taille_msg := taille_msg + succ (length (e^.nb));
                inc (nb_msg);
                e := e^.next;
           end;
     {endwhile}
     blockwrite (f2, taille_msg, sizeof (taille_msg));
     blockwrite (f2, nb_msg, sizeof (nb_msg));
     while (liste^.first <> nil) do
           begin
                ch := liste^.suppr;
                blockwrite (f2, ch [0], succ (length (ch)));
           end;
     {endwhile}
end; { ecrit_texte }

begin
     writeln ('MKMSG ('+num_ver+')');
     writeln ('(c) Patrick Pr‚martin '+dat_ver);
     writeln ('(c) Olf Software 1992');
     writeln;
     if ((param_del ('/?') or param_del ('/H')) or (paramcount = 0))
     then
         begin
              writeln ('This program make MSG files with TXT files.');
              writeln ('It is the Multi-Language Interface compiler.');
              writeln;
              writeln ('Syntax:');
              writeln ('       MKMSG <Fich_Txt>[.TXT] [<Fich_Msg>[.MSG]]');
              writeln;
              writeln ('Read Fich_Txt.TXT and transform ASCII into Fich_Msg.MSG');
              writeln ('If there is not Fich_Msg, result will be Fich_Txt.MSG');
              writeln;
              writeln ('This program is property of Olf Software and its members...');
         end
     else
         begin
              if (paramcount = 1)
              then
                  begin
                       fsplit (fexpand (paramstr (1)), path, name, ext);
                       nom1 := path+name+'.TXT';
                       nom2 := path+name+'.MSG';
                  end
              else
                  begin
                       fsplit (fexpand (paramstr (1)), path, name, ext);
                       nom1 := path+name+'.TXT';
                       fsplit (fexpand (paramstr (2)), path, name, ext);
                       nom2 := path+name+'.MSG';
                  end;
              {endif}
              assign (f1, nom1);
              {$i-}
              reset (f1);
              {$i+}
              if (ioresult <> 0)
              then
                  begin
                       writeln ('Can not open '+nom1);
                       halt (1);
                  end;
              {endif}
              assign (f2, nom2);
              {$i-}
              rewrite (f2, 1);
              {$i+}
              if (ioresult <> 0)
              then
                  begin
                       writeln ('Can not write into '+nom2);
                       close (f1);
                       halt (2);
                  end;
              {endif}
{ Ecriture du Header. }
              ch := header_msg;
              blockwrite (f2, ch [0], succ (length (header_msg)));
{ Saisie des langues autoris‚es. }
              readln (f1, ch);
              langue_autorisee := 0;
              ch := set_maj_chaine (ch);
              if (pos ('F', ch) > 0)
              then
                  langue_autorisee := langue_autorisee + msg_f;
              {endif}
              if (pos ('GB', ch) > 0)
              then
                  langue_autorisee := langue_autorisee + msg_gb;
              {endif}
              if (pos ('D', ch) > 0)
              then
                  langue_autorisee := langue_autorisee + msg_d;
              {endif}
              if (pos ('I', ch) > 0)
              then
                  langue_autorisee := langue_autorisee + msg_i;
              {endif}
              blockwrite (f2, langue_autorisee, sizeof (longint));
{ Traitement des blocs correspondants chacun … une langue. }
              liste := new (p_file, init);
              readln (f1, ch);
              ecrit_langue_utilisee;
              while not eof (F1) do
                    begin
                         readln (f1, ch);
                         if (ch [1] <> '.')
                         then
                             liste^.add (ch)
                         else
                             begin
                                  ecrit_texte;
                                  ecrit_langue_utilisee;
                             end;
                         {endif}
                    end;
              {endwhile}
              ecrit_texte;
              dispose (liste, done);
              close (f2);
              close (f1);
         end;
     {endif}
end.
