


   -- Définition de structures de données associatives sous forme d'une liste
-- chaînée associative (LCA).
generic
	type T_Cle is private;
   
    type T_donnee is private;
 
package LCA is
    type T_lca is private;
  
    -- Initialiser une Sda.  La Sda est vide.
	procedure Initialiser(Sda: out T_LCA) with
		Post => Est_Vide (Sda);


	-- Est-ce qu'une Sda est vide ?
	function Est_Vide (Sda : T_LCA) return Boolean;
	
	    -- Obtenir le nombre d'éléments d'une Sda. 
	function Taille (Sda : in T_LCA) return Integer with
		Post => Taille'Result >= 0
			and (Taille'Result = 0) = Est_Vide (Sda);


	-- Enregistrer une Donnée associée à une Clé dans une Sda.
	-- Si la clé est déjà présente dans la Sda, sa donnée est changée.
	procedure Enregistrer (lca : in out T_LCA ; Cle : in T_Cle ; Donnee : in T_donnee);
		

	-- Supprimer la Donnée associée à une Clé dans une Sda.
	-- Exception : Cle_Absente_Exception si Clé n'est pas utilisée dans la Sda
	procedure Supprimer (Sda : in out T_LCA ; Cle : in T_Cle) ;
		         

	-- Savoir si une donnée est présente dans une Sda.
	function donnee_Presente (Sda : in T_LCA ; donnee : in T_donnee) return Boolean;


	-- Obtenir la donnée associée à une Cle dans la Sda.
	-- Exception : Cle_Absente_Exception si Clé n'est pas utilisée dans l'Sda
	function La_Donnee (Sda : in T_LCA ; cle : in T_cle) return T_donnee;


	-- Supprimer tous les éléments d'une Sda.
	procedure Vider (Sda : in out T_LCA) with
            Post => Est_Vide (Sda);
            
    --Retourne la clé d'une sda        
    function cle(sda:in T_lca) return T_cle;
    
    -- Retourne la donnée d'une sda
    function donnee(sda:in T_lca) return T_donnee;
    
    -- Retourne la sda suivante d'une sda donnée
    function suivante(sda:in T_lca) return T_lca;


	-- Appliquer un traitement (Traiter) pour chaque couple d'une Sda.
	generic
		with procedure Traiter (Cle : in T_Cle; Donnee: in T_donnee);
    procedure Pour_Chaque (Sda : in T_LCA);
    
    
    -- la clé associée à la donnee
    function La_cle (Sda : in T_LCA ; donnee : in T_donnee) return T_cle;
    
    
    
        
     



private
    
    type T_cellule;
    type T_LCA is access T_cellule;
    type T_cellule is record 
        cle:T_cle;
        donnee:T_donnee;
        suivante: T_LCA;
    end record;
    
                       
          

end LCA;
