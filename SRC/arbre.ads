with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

generic
    
type T_Donnee is private;
    

package arbre is

    type T_arbre is  private;


--Initialiser un arbre
    procedure initialiser (Arbre: out T_arbre) with 
            post=>est_vide(arbre);
    
 -- retourne un booléen qui indique si l'arbre est vide ou non
    function est_vide(arbre:in T_arbre) return boolean with
            post=>taille(arbre)=0;

--Donne la taille de l'arbre
    function taille(arbre:in T_arbre) return integer;
    
 --Indique si un arbre est réduit à une feuille   
    function est_une_feuille(arbre:in T_arbre) return boolean; 
           

--La donnee est-elle présente dans l'arbre?
    function donnee_presente1(arbre:in T_arbre; donnee:in T_donnee) return boolean; 
   

   
    --vide l'arbre
    procedure vider(arbre: in out T_arbre) with
            post=>est_vide(arbre);
            
-- Donne la'bre droit d'un arbre de type T_arbre     
   function droit(arbre:in T_arbre) return T_arbre ;
   
--Donne l'arbre gauche d'un arbre de type T_arbre           
   function gauche(arbre:in T_arbre) return T_arbre;
          
--Fusionne deux arbres selon le principe de hufman, dans l'arbred:
   procedure fusion(arbred:in out T_arbre; arbreg:in T_arbre;donnee_defaut:in T_donnee);

--retourne le code associé à la donnée dans l'arbre de huffman 
    function code_associe(arbre: in T_arbre; caractere: in T_donnee) return Unbounded_String
            with pre=> not est_vide(arbre) and donnee_presente1(arbre,caractere);
     
--Donne la cle de la racine de l'arbre: 
    function cle(arbre:in T_arbre) return integer with
            pre=> not est_vide(arbre);
    
--Donne la donnée de la racine de l'arbre:
    function donnee(arbre:in T_arbre) return T_donnee with 
            pre=> not est_vide(arbre);
   
 --Transforme une cle et une donnée en une étiquette de donnée : donnée et de clé:clé          
    function construction_feuille(cle:integer;donnee:T_donnee) return T_arbre ;
    
 -- Indique si une clé est présente dans l'arbre:  
    function cle_presente(arbre:in T_arbre;cle:integer) return boolean;
    
procedure incrementer_frequence(arbre:in out T_arbre);
    
private
    type T_noeud;
    
    type T_arbre is access T_noeud;
    
    type T_noeud is record 
        cle:integer;
        donnee:T_Donnee;
        gauche:t_arbre;
        droit:T_arbre;
    end record;
    
                       
          

end arbre;
