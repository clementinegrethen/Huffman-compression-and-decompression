with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Command_Line;      use Ada.Command_Line;
with lca;
with arbre;
with ada.integer_text_IO;       use ada.integer_text_IO;
with Ada.Strings.Unbounded;  use Ada.Strings.Unbounded;
with Ada.Strings;  use Ada.Strings;
with ada.io_exceptions;
procedure decompresser is

     type T_octet is mod 2**8;
   
     
    
   
    type T_tab is array (1..257) of T_octet;
    type T_tab2 is array (1..257) of unbounded_string;
    
    
    
    -- fonction qui convertit un octet en binaire
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
    
    
    -- Stocke dans un unbounded_string l'encodage du texte
    procedure verifier_entree(nom_fichier:in string;texte: in out unbounded_string) is 
    S: Stream_Access; 
     File: Ada.Streams.Stream_IO.File_Type;
        octet:T_octet;
        compteur:integer:=1;
        i:integer;
        limit:integer;
       
    begin
    open(file,in_file,nom_fichier);
        s:=stream(file);
        while not end_of_file(file) loop
        octet:=T_octet'input(s);
        texte:=texte&octet_binaire(octet);
        end loop;
        put(to_string(texte));
        close(file);
     end;
    
    
    
    -- décompose l'entête en séparant les caractères en parcours infixe, le parcours infixe de l'arbre et le texte encodé.
    procedure decomposer_entete(nom_fichier: in string;tab:in out T_tab;texte_infixe:in out unbounded_string;indice_dollards:in out integer;texte_caractere:in out unbounded_string) is 
   
       File: Ada.Streams.Stream_IO.File_Type;	-- car il y a aussi Ada.Text_IO.File_Type
        S: Stream_Access; 
        octet:T_octet;
        compteur:integer:=1;
        i:integer;
        limit:integer;
        texte:unbounded_string:=to_unbounded_string("");
        texte_code:unbounded_string:=to_unbounded_string("");
    begin
        open(file,in_file,nom_fichier);
        s:=stream(file);
        indice_dollards:=integer(T_octet'input(s));
        octet:=T_octet'input(s);
        tab(1):=octet;
        texte_caractere:=texte_caractere&octet_binaire(octet);
        octet:=T_octet'input(s);
        compteur:=compteur+1;
        while octet/=tab(compteur-1) loop -- Dans cette procédure, tab ne sert qu'à comparer les octets entre eux, et arrêter la lecture quand on a un doublon à la suite.
            
            tab(compteur):=octet;
            texte_caractere:=texte_caractere&octet_binaire(octet);
            compteur:=compteur+1;
            octet:=T_octet'input(s);
       end loop;
      tab(compteur):=octet;
      texte_caractere:=texte_caractere&octet_binaire(octet);
       while not end_of_file(file) loop
            octet:=T_octet'input(s);
            texte:=texte&octet_binaire(octet); 
            --put(to_string(texte));     -- texte contient le reste du fichier: le parcours infixe, le texte et les 0 supplémentaires
       end loop;
       
        limit:=0;
        i:=1;
        
        while limit/=compteur loop
            if element(texte,i)='1' then 
          
                limit:=limit+1;
             end if;
            texte_infixe:=texte_infixe & element(texte,i);
            i:=i+1;
        end loop; -- texte_infixe contient le parcours infixe 
        texte_code:=unbounded_slice(texte,i,length(texte)-i);
        close(file);
    end decomposer_entete;
    
    
    
    -- Convertit un binaire en un octet:
    function Binaire_to_octet (Octet: in Unbounded_String) return T_Octet  is
                
                code: String(1..8);
                s: Integer;
        begin
                s := 0;
                code := To_String(Octet);
                for i in 1..8 loop
                        if code(i) = '1' then
                                s := s + 2**(8-i);
                        end if;
                end loop;
       
        return T_Octet(s) ;
        end Binaire_to_octet;
        
    
    
    
   -- Création de la table de Huffman à partir dun parcours infixe et des caractères dans le parcours infixe
        function Creation_table_huffmann (Texte_caractere : in unbounded_string;  parcours_infixe : in Unbounded_String;indice_dollards:integer ) return T_tab2 is
                Code : Unbounded_String;
                nb_feuille : Integer;
         
                tab_huff:T_tab2;
                texte_caractere_curseur:unbounded_string:=texte_caractere;
                
        begin
                Code := Null_Unbounded_String;
                nb_feuille := 1;
                
                For i in  1..Length(parcours_infixe) loop
                        
                        if Element(parcours_infixe, i) = '0' then
                                Append(Code, To_Unbounded_String("0"));
                        else
                        
                            if nb_feuille=indice_dollards then -- si on atteint l'indice de fin de texte
                                tab_huff(257):=code;
                            else    
                                
                                tab_huff(integer(binaire_to_octet((unbounded_slice(texte_caractere_curseur,1,8))))):=code;
                            
                                if length(texte_caractere_curseur)>8 then 
                                 texte_caractere_curseur:=  Unbounded_Slice(texte_caractere_curseur,9 , Length(texte_caractere_curseur));-- on retire l'octet auquel on vient d'associer un code de huffman
                                end if;
                             end if;
                                nb_feuille := nb_feuille+1;
                                
                                if Length(Code) = 1 then
                                        Code := To_Unbounded_String("1");
                                else
                                        if i /= length(parcours_infixe) then 
                                                while Element(Code, Length(Code)) = '1' loop
                                                        Code := Unbounded_Slice(Code, 1, Length(Code)-1);
                                                end loop;
                                                if Length(Code) = 1 then
                                                        Code := To_Unbounded_String("1");
                                                else
                                                        Replace_Element(Code,Length(Code),  '1');
                                                end if;
                                        end if;   
                                end if;       
                        end if;      
                end loop;
                
                
                return tab_huff;
                        
        end Creation_table_huffmann;
        
        
   -- Afficher les codes et les caractères correspondants: 
   procedure afficher_codes_huffman(tab_huff:in T_tab2) is 
     
     begin
        put("voici la table de huffman associee");
        new_line;
        for i in 1..tab_huff'length-1 loop
            if tab_huff(i)/=null_unbounded_string then 
            put(to_string(tab_huff(i)));
            put("-->");
            put(character'val(i));
            new_line;
            end if;
        end loop;
            put(to_string(tab_huff(257)));
             put("-->");
             put("/$");
            
         
     end;  
   
    -- Décode un texte donné en entré
   procedure decoder(texte: in unbounded_string; tab_huff: in T_tab2;tab_element:in out T_tab;nb_element:in out integer)  is
   code:unbounded_string;
   i:integer:=1;
   limit:integer:=1;
   fin_texte:boolean:=false;
  
    begin
    while not fin_texte loop
        --put("x");
        --put(i);
        code:=code&element(texte,i);
        for limit in 1..257 loop
        --put("c");
            if tab_huff(limit)/=null_unbounded_string then 
                if code=tab_huff(limit) then
                if code=tab_huff(257) then 
                    --put("grr");
                        fin_texte:=true;
                 else
                    
                   
                   new_line; 
                    tab_element(nb_element):=T_octet(limit);
                    nb_element:=nb_element+1;
                    
                   end if;
                     code:=null_unbounded_string;
                 end if;
                 end if;
        end loop;
         
        i:=i+1;
         end loop;
         
         
         
    
    
        
    end decoder;
     
    
    -- Ecrire le texte décode dans un fichier .txt:
    procedure decompresser_fichier(nom_fichier:in unbounded_string; tab_element: in T_tab;limit:integer) is 
        File: Ada.Streams.Stream_IO.File_Type;	-- car il y a aussi Ada.Text_IO.File_Type
        S: Stream_Access; 
        octet:T_octet;
        c:character;
    begin
    
    Create(file, Out_File, Slice(nom_fichier, 1, Length(nom_fichier)-4));
    
    S := Stream(file);
    for i in 1.. limit loop
        octet:=tab_element(i);
        character'write(S,character'val(octet));
     end loop;
     close(file);
    end decompresser_fichier;
    
    
    
  --Déclaration des variables utiles pour la décompression
  
  tab:T_tab; -- Va contenir les octets des caractères dans l'ordre infixe
  
  texte_infixe:unbounded_string:=to_Unbounded_String("");-- contient le parcours infixe de l'arbre
  
  
  table_huffman:T_tab2;-- contiendra les codes de huffman associés aux caractères (la case d'indice i contient son code en tant que code ascii associé au caractère)
  
  texte_caractere:unbounded_string:=to_unbounded_string(""); -- contient les octets en parcours infixe écrits en binaire
  
  tab_elements: T_tab;-- contient dans l'ordre, les octet à placer dans le fichier texte
  
  indice_dollards:integer:=0; -- psotion du caractère de fin dans l'arbre
  nb_element:integer:=1;-- nombre de caractères dans le texte décompressé
  
  texte_entree:unbounded_string:=to_unbounded_string(""); -- contient l'ensemble du texte encodé
  
  taille:integer;-- taille du parcours infixe et des caractères concaténés
  
  texte_code2:unbounded_string;-- contient le texte en code de huffman
     
begin
     if Argument_Count = 0  then
            put("Votre entrée n'est pas bonne: il faut au moins un texte à décompresser "); --on rend l'algorithme robuste: on traite le cas où l'utilisateur n'a pas rentré d'argument.
        end if; 
    for i in 1..argument_count loop
        if argument(i)/="-b" then
            begin
                
               -- On commence par stocker le texte encodé  
                verifier_entree(argument(i),texte_entree);
               -- on isole ensuite les caractères en parcours infixe et le parcours infixe
                decomposer_entete(argument(i),tab,texte_infixe,indice_dollards,texte_caractere);
                
                
                taille:=length(texte_caractere)+8+length(texte_infixe);
                
                -- on tronque texte_entre en enlevant le parcours infixe et les caractère en parcours infixe: on a le texte en code de Huffman
                texte_code2:=unbounded_slice(texte_entree,taille+1,length(texte_entree));
                
                -- on reconstruit la table de huffman et on la stocke dans un tableau table_huffman
                table_huffman:=Creation_table_huffmann (texte_caractere, texte_infixe,indice_dollards);
               
                if Argument(1) = "-b" then
                    
                     afficher_codes_huffman(table_huffman); -- l'option -b est choisie: on afficha la table de huffman
                
                end if;
                
               
                -- on décode texte_code2 grâce à la table, dans un tableau de longueur nb_element
                decoder(texte_code2,table_huffman,tab_elements,nb_element);
                
               -- on écrit les caractères dans un fichier .txt
                decompresser_fichier(to_unbounded_string(argument(i)), tab_elements,nb_element);
                
                -- on traite les exceptions:
                exception
                
              when Ada.IO_Exceptions.NAME_ERROR =>
                    Put_Line("veuillez rentrer un ou des fichiers existants!!!");  
            
        end;
        
        end if;
                
      end loop;
      
end decompresser;          
               
  
    
   
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
            
            
            
                
            
