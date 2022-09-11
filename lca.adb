-- with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with SDA_Exceptions;         use SDA_Exceptions;
with Ada.Unchecked_Deallocation;

package body LCA is



	procedure Free is
		new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_LCA);


	procedure Initialiser(Sda: out T_LCA) is
	begin
		sda := null;
    end Initialiser;



	function Est_Vide (Sda : T_LCA) return Boolean is
	begin
        return sda=null;
    end est_vide;



	function Taille (Sda : in T_LCA) return Integer is
	begin
        if est_vide(sda) then
            return 0;
        else
            return 1+taille(sda.all.suivante);
        end if;
    end Taille;




   



    procedure Enregistrer (lca : in out T_LCA ; Cle : in T_Cle ; Donnee : in T_donnee) is
	begin
	    if donnee_presente(lca,donnee) then 
	  
	        if lca.all.donnee=donnee then 
	            lca.all.cle:=cle;
	          
	        else
	            enregistrer(lca.all.suivante,cle,donnee);
	        end if;
	    else
	        
	        lca:= new T_cellule'(cle,donnee,lca);
	    end if;
	    end;


	function donnee_Presente (Sda : in T_LCA ; donnee : in T_donnee) return Boolean is
	begin
            if sda = null then
                return false;
            elsif sda.all.donnee = donnee then
                return true;
            else
                return donnee_presente(sda.all.suivante,donnee);
        end if;
    end donnee_Presente;




  

  function La_cle (Sda : in T_LCA ; donnee: in T_donnee) return T_cle is
    begin

        if sda.all.donnee= donnee then
            return sda.all.cle;
        else
            return La_cle(sda.all.suivante,donnee);
        end if;
    end La_cle;



    procedure Supprimer (Sda : in out T_LCA ; Cle : in T_Cle) is
		temp : T_LCA;

	begin
		if Sda /= null then
			if Sda.all.Cle = Cle then
				temp := Sda;
				Sda := Sda.all.Suivante;
				Free(temp);
			else
				Supprimer(Sda.all.Suivante,Cle);
			end if;
		else
			raise Cle_Absente_Exception;
		end if;
	end Supprimer;




	procedure Vider (Sda : in out T_LCA) is
	begin
		sda := null;
	end Vider;




    procedure Pour_Chaque (Sda : in T_LCA) is
    begin
        if sda /= null then
            begin
                traiter(sda.all.cle,sda.all.donnee);
            exception
                when others =>
                    null;
            end;
            pour_chaque(sda.all.suivante);
        end if;
    end Pour_Chaque;
    
    

    function cle(sda:T_lca) return T_cle is
    begin
        return sda.all.cle;
    end;
      function La_Donnee (Sda : in T_LCA ; cle : in T_cle) return T_donnee is
    begin
       
        if sda.all.cle = cle then
            return sda.all.donnee;
        else
            return La_donnee(sda.all.suivante,cle);
        end if;
    end La_Donnee;
    
    
    
    

    function donnee(sda:T_lca) return T_donnee is
    begin
  
        return sda.all.donnee;
    end;
    


    function suivante(sda:T_lca) return T_lca is
    begin
        return sda.all.suivante;
    end;
    
    
   

end LCA;
