with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Command_Line;      use Ada.Command_Line;
with lca;
with arbre;
with ada.integer_text_IO;       use ada.integer_text_IO;
with Ada.Strings.Unbounded;  use Ada.Strings.Unbounded;
with Ada.Strings;  use Ada.Strings;
with ada.IO_exceptions;

procedure compresser is
    type T_octet is mod 2**8;
   
   
   
    package arbre_new is new arbre(T_donnee=>T_octet);
    use arbre_new;
    
    
    package lca_arbre is new LCA(T_cle=>integer,T_donnee=>T_arbre);
    use lca_arbre;
    
    package lca_integer is new lca(T_cle=> integer,T_donnee=>T_octet);
    use lca_integer;
    
    type T_tab2 is array (1..257) of Unbounded_String;
    
    
    
     --Retourne la fréquence minimale dans une lca(parmi la fréquence des racines des arbres)
    function cle_min(tab_frequence:in lca_arbre.T_lca) return integer is 
        curseur:lca_arbre.T_lca;
        min:integer;
    begin
        
        curseur:=Tab_frequence;
     
        min:=cle(tab_frequence);
       
        while not Est_Vide(curseur) loop
    
          
            if cle(curseur)<min then
            
                min:=cle(curseur);
            end if;
           
            curseur:=suivante(curseur);
        end loop;
       
        return min;
    end;
    
    
    
    -- Création de l'arbre de Huffman:
    function arbre_huffman(frequence: in out lca_arbre.T_lca) return T_arbre is
        arbre1:T_arbre;
        arbre2:T_arbre;
        arbre:T_arbre;
        donnee_defaut:T_octet:=0;
    begin
        
        while taille(frequence)>1 loop
       
            arbre1:=La_Donnee(frequence,cle_min(frequence));
          
            supprimer(frequence,cle_min(frequence));
            
            arbre2:=la_donnee(frequence,cle_min(frequence));
            
            supprimer(frequence,cle_min(frequence));
           
            fusion(arbre1,arbre2,donnee_defaut);
          
            enregistrer(frequence,cle(arbre1),arbre1);
            
        end loop;
        arbre:=donnee(frequence);
        return arbre;
    end;
    
    
   
    
    
    
  
       --Lecture du fichier des texte et on place les caractères du texte et leur fréquence associée dans une lca_frequence:
    procedure construction_frequence (nom_fichier:in string;frequence:in out lca_integer.T_lca) is 
        file:ada.streams.Stream_IO.file_type;
        S:Stream_Access;
        octet:T_octet;
        indice:integer;
    begin
      
        open(file,in_file,nom_fichier);
        s:=stream(file);
     
        while not End_Of_File(file) loop
            octet:= T_octet'input(s);
       
           
            if donnee_presente(frequence,octet) then
               
                     enregistrer(frequence,la_cle(frequence,octet)+1,octet);
                    
                  
            else
           
                enregistrer(frequence,1,octet);
            end if;
            
                
        end loop;
        enregistrer(frequence,0,-1);-- on enregistre le caractère de fin '/$': son octet vaut -1.
        close(file);
    end;
    
    
    
    
    -- passer d'une lca_integer à une lca_arbre:
    function octet_to_feuille(frequence: in lca_integer.T_lca) return lca_arbre.T_lca is 
    curseur :lca_integer.T_lca:=frequence;
    frequence_arbre:lca_arbre.T_lca;
    begin
        while not est_vide(curseur) loop
            enregistrer(frequence_arbre,cle(curseur),construction_feuille(cle(curseur),donnee(curseur)));
            curseur:=suivante(curseur);
        end loop;
     return frequence_arbre;
     end;
     
     
     
     
     -- Afficher les codes de huffman associés aux caractères d'un texte en entrée:
     procedure afficher_codes_huffman(tab_code:in T_tab2;frequence:lca_arbre.T_lca) is 
     i:T_octet:=2;
     curseur:lca_arbre.T_lca:=frequence;
     indice:integer;
     begin
        put("'/$'");
            put("-->");
            put(to_string(tab_code(257)));
           
            new_line;
           
        while not est_vide(curseur) loop  
            indice:=integer(donnee(donnee(curseur)));
            put("'" & character'val(donnee(donnee(curseur))) & "'");
           
            put("-->");
          
           
            put(to_string(tab_code(indice)));
            new_line;
            curseur:=suivante(curseur);   
     
       end loop;
     end;
            
            
        
                
              
              
                               
                            
    --Fpnction qui convertit un octet en binaire:
    function Octet_binaire(Octet : in T_Octet) return Unbounded_String is  
       	 Bit : T_Octet;
       	 octet2:T_octet;
       	 str  : Unbounded_String;
         Bit_str : String(1..2);
         
       	 begin
       	 octet2 := Octet;
       	 Bit := octet2 / 128;
         Bit_str := Integer'Image(Integer(bit));
       	 str := To_Unbounded_string(Bit_str(2..Bit_str'Last));
       	 octet2 := octet2* 2;
       	 for N in 1..7 loop
       		 Bit := octet2 / 128;
       		 Bit_str := Integer'Image(Integer(bit));
       		 str := str & To_Unbounded_string(Bit_str(2..Bit_str'Last));
       		 octet2 := octet2 * 2;
       	 end loop;
       	 return(str);
       	 
    end Octet_binaire;
    
    
    
    -- on consrtuit le tableau contenant les codes de huffman associés aux caractères
    function table_codage(tab_frequence:in lca_integer.T_lca;arbre:in T_arbre) return T_tab2 is 
        tab_code:T_tab2;
        indice:integer;
        curseur:lca_integer.T_lca:=tab_frequence;
        begin
            tab_code(257):=code_associe(arbre,-1);--Ecriture du code de fin en première position
            while not Est_Vide(curseur) loop
                indice:=integer(donnee(curseur));
                tab_code(indice):=code_associe(arbre,donnee(curseur));
                curseur:=suivante(curseur);
            end loop;
        return Tab_code;
    end;
        
        
        
            
       --Retourne un unbounded_string contenant le parcours infixe de l'arbre et un tableau contenant l'octet des caractères dans l'ordre infixe:     
    procedure code_infixe(arbre:T_arbre;code_infixe:in out unbounded_string;tab_caractere:in out T_tab2)is 
        nb_feuille:T_octet:=0;
        procedure infixe(arbre:T_arbre) is 
        begin           
            if not est_une_feuille(arbre) then
                code_infixe:=code_infixe & "0";
                infixe(gauche(arbre));
                infixe(droit(arbre));
            else
                nb_feuille:=nb_feuille+1;
                if donnee(arbre)=-1 then
                     tab_caractere(1):=octet_binaire(nb_feuille);-- écriture de la position de '/$'
                else
                     tab_caractere(integer(nb_feuille)):=octet_binaire(donnee(arbre));
                end if;
                code_infixe:=code_infixe & "1";
            end if;
       end;
        
        
    begin
       infixe(arbre);
       tab_caractere(integer(nb_feuille)+1):=tab_caractere(integer(nb_feuille)); -- on double le dernier caractère en le rajoutant dans la case suivante vide.
           
    end;
        
        
      --Concaténer les caractères du parcours infixe,le parcours infixe et le texte en code de huffman( c'est ce qu'il faudra écrire dans le fichier)  
    function concatene (tab:T_tab2;parcours_infixe:in Unbounded_String;nom_fichier:in string;codage:in T_tab2) return unbounded_string is
       file:Ada.Streams.Stream_IO.File_Type;
       chaine: Unbounded_String;
       octet:T_octet;
       s:Stream_Access;
       indice:integer;
    begin
     
       open(file,in_file,nom_fichier);
       s:=stream(file);
       for i in 1..Tab'length loop
           chaine:=chaine&tab(i);
       end loop;
           
       chaine:=chaine&parcours_infixe;
       while not End_Of_File(file) loop
            octet:=T_octet'input(s);
            indice:=character'pos(character'val(octet)) ;
            chaine:=chaine&codage(indice);
       end loop;
       chaine:=chaine&codage(257);
       return chaine;
       
   end;
   
    
    --On procède à la création du fichier.hff et on écrit les octets concaténés:  
   procedure ecrire_code(symbole: in unbounded_string;Nom_fichier:in string) is 
       s:stream_access;
       file:Ada.Streams.Stream_IO.File_Type;
       octet:T_octet;
       indice:integer:=1;
       bit:T_octet;
   begin
       create(file,out_file,nom_fichier&".hff");
       s:=stream(file);
       for i in 1..length(symbole) loop
           bit:=character'pos(element(symbole,i)) - character'pos('0');
           octet:=octet*2 or bit;
           indice:=indice+1;
           if indice >8 then 
              indice:=1;
              T_octet'write(s,octet);
              octet:=0;
           end if;
       end loop;
       if indice/=1 then -- on écrit un octet: on complète le dernier octet incomplet
           for i in indice..8 loop
               octet:=octet*2;
           end loop;
           T_octet'write(S,octet);
       end if;
   end;
  
  
  
    procedure Afficher(arbre:T_arbre; n:integer) is
            begin
                if est_une_feuille(arbre) then
                    Put("(");
                    Put(cle(arbre),0);
                    Put(")");
                    Put("'");
                    Put(character'val(donnee(arbre)));
                    Put("'");
                else
                    Put("(");
                    Put(cle(arbre),0);
                    Put(")");
                    New_Line;
                    for i in 0..n-1 loop
                        Put("       ");
                        Put("|      ");
                    end loop;
                    put("\--0--");
                    Afficher(gauche(arbre),n+1);
                    New_Line;
                    for i in 0..n-1 loop
                        Put("       ");
                        Put("|      ");
                    end loop;
                    put("\--1--");
                    Afficher(droit(arbre),n+1);

                end if;
            end;


  
   
   arbre:T_arbre;
   frequence:lca_integer.T_lca;
   Tab_code:T_tab2;
   code_parcours_infixe:unbounded_string:=To_Unbounded_String("");
   tab_caractere:T_tab2;
   chaine:unbounded_string;
   chemin : Unbounded_String := Null_Unbounded_String;
   frequence_sup:lca_integer.T_lca;
   frequence_arbre:lca_arbre.T_lca;
   frequence_sup_arbre:lca_arbre.T_lca;
   
 begin
       if Argument_Count = 0 or else (Argument_Count = 1 and Argument(1) = "-b") then
            put("Votre entrée n'est pas bonne: il faut au moins un texte à décompresser "); --on rend l'algorithme robuste: on traite le cas où l'utilisateur n'a pas rentré d'argument.
        end if;                     
      
        for i in 1..argument_count loop    -- on peut compresser plusieurs fichiers en même temps.
            if argument(i)/="-b" then
            begin
                    
               
              
                  initialiser(frequence);
                 
                  construction_frequence(argument(i),frequence);
                  
                  frequence_arbre:=octet_to_feuille(frequence);
                  
                  initialiser(frequence_sup);
                  
                  construction_frequence(argument(i),frequence_sup); 
                  
                  frequence_sup_arbre:=octet_to_feuille(frequence_sup); -- on stocke la lca contenant la fréquence des caractères, on l'utilisera par la suite
                  
                  initialiser(arbre);
                  
             
                  arbre:=arbre_huffman(frequence_arbre);
                 
                  Tab_code:=table_codage(frequence_sup,arbre);
          
                  code_infixe(arbre,code_parcours_infixe,tab_caractere);
                  
                  if Argument(1) = "-b" then
                    Afficher(Arbre,0);
                    new_line;
                    afficher_codes_huffman(tab_code,frequence_sup_arbre);
                    
                 end if;
                  
                  chaine:=concatene(tab_caractere,code_parcours_infixe,argument(i),tab_code);
                
                  ecrire_code(chaine,argument(i));
                
                
                  vider(arbre);
                 -- on traite les exceptions relatives aux fichiers:
                 exception
                 
                when Ada.IO_Exceptions.STATUS_ERROR =>
                    Put_Line("attention un des fichiers est déjà ouvert");
                when Ada.IO_Exceptions.NAME_ERROR =>
                    Put_Line("veuillez rentrer un ou des fichiers existants!!!");
            end;
                  
        end if;
                            
           
    end loop;
 end;
     
     
     
     
     
     
     
     
     
     
     
            
            
            
                
            
