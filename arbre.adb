-- with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with SDA_Exceptions;         use SDA_Exceptions;
with Ada.Unchecked_Deallocation;
with ada.integer_text_IO;       use ada.integer_text_IO;
with Ada.Strings.Unbounded;  use Ada.Strings.Unbounded;
with Ada.Strings;  use Ada.Strings;

package body arbre is

    procedure free is 
        new ada.Unchecked_Deallocation(Object=> T_noeud, Name=> T_arbre);



    procedure initialiser (Arbre: out T_arbre) is
    begin
      
        arbre:=null;
    end;
    
    function Est_Vide (arbre : T_arbre) return Boolean is
	    begin
            return arbre=null;
        end est_vide;

    
    
            
    function est_une_feuille(arbre:in T_arbre) return boolean is
    begin
        return arbre.all.gauche=null and arbre.all.droit=null;
    end;
    
    
    function taille(arbre:in T_arbre) return integer is 
    begin
        if est_vide(arbre) then
            return 0;
        else
            return 1+taille(arbre.all.gauche)+taille(arbre.all.droit);
        end if;
    end;
           


    function donnee_presente1(arbre:in T_arbre; donnee:in T_donnee) return boolean is 
    begin
     
      if Est_Vide(Arbre) then

            return False;
        elsif arbre.all.donnee=donnee then
       
            return true;
        else
        
            return(donnee_presente1(arbre.all.gauche,donnee) or donnee_presente1(arbre.all.droit,donnee));
        end if;
        
    end;
     
                 
                
                
    
    

    procedure vider(arbre: in out T_arbre) is
        arbre1:T_arbre;
        arbre2:T_arbre;
    begin
            if not est_vide(arbre) then
                arbre1:=arbre.all.gauche;
                arbre2:=arbre.all.droit;
                free(arbre);
                vider(arbre1);
                vider(arbre2);
            end if;
    end vider;
    
    procedure fusion(arbred:in out T_arbre; arbreg:in T_arbre;donnee_defaut:in T_donnee) is 
        Donnee : T_donnee;
		Cle : integer;
		
	begin
		cle := Arbred.all.cle + Arbreg.all.cle;
		
		Arbred := new T_Noeud'(Donnee => donnee_defaut, Cle => Cle , Gauche => Arbred , Droit => Arbreg);
	end Fusion;




    function code_associe(arbre: in T_arbre; caractere: in T_donnee) return unbounded_string is 
    begin
        if Arbre.all.donnee=caractere and est_vide(arbre.all.gauche) and est_vide(arbre.all.droit) then
             return To_Unbounded_String("");
        elsif donnee_presente1(arbre.all.gauche,caractere) then 
             return To_Unbounded_String("0")&code_associe(arbre.all.gauche,caractere);
        else
             return To_Unbounded_String("1") & Code_associe(Arbre.all.droit, Caractere);
        end if; 
    end;
    
    

   function construction_feuille(cle:integer;donnee:T_donnee) return T_arbre is
      arbre:t_arbre;
   begin
        arbre:= new T_noeud'(cle=>cle,donnee=>donnee,gauche=>null,droit=>null);
        return arbre;
   end;
   
   
   
    function cle(arbre:T_arbre) return integer is
    begin
        return arbre.all.cle;
    end;
      
   
   
    function donnee(arbre:T_arbre) return T_donnee is
    begin
        return arbre.all.donnee;
    end;
    
      
    

    function droit (arbre:in T_arbre) return T_arbre is 
    begin 
        return arbre.all.droit;
    end;
    
    
    
    function gauche (arbre:in T_arbre) return T_arbre is 
    begin 
        return arbre.all.gauche;
    end;
    
    
    
    function cle_presente(arbre:in T_arbre;cle:integer) return boolean is 
    begin
         if arbre.all.cle=cle then
            return true;
        else
            return cle_presente(arbre.all.gauche,cle) and cle_presente(arbre.all.droit,cle);
        end if;
    end;
    
   procedure incrementer_frequence(arbre: in out T_arbre) is 
   begin
        arbre.all.cle:=arbre.all.cle+1;
        end;
        
 


end arbre; 
