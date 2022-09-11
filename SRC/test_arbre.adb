with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with SDA_Exceptions; 		use SDA_Exceptions;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
	
with arbre;


procedure test_arbre is

        type T_octet is mod 256;
        
        package arbre_test is new arbre (T_Donnee => T_octet);
    	use arbre_test; 
    	
        arbre1:T_arbre;
        arbre2:t_arbre;
        arbre3:T_arbre;
begin   
	
    	initialiser(arbre1);
    	put("test1 réussi");
    	new_line;
    	pragma assert(taille(arbre1)=0);
    	pragma assert (est_vide(arbre1));
    	put("test1 réussi");
    	new_line;
    	-- l'arbre 2 est une feuille de clé 5 et de donnée 250
    	arbre2:=construction_feuille(5,250);
    	pragma assert(taille(arbre2)=0);
    	put("test2 réussi");
    	new_line;
    	pragma assert(est_une_feuille(arbre2));
    	put("test3 réussi");
    	new_line;
    	pragma assert(est_vide(droit(arbre2)));
    	put("test4 réussi");
    	new_line;
    	pragma assert(est_vide(gauche(arbre2)));
    	put("test4 réussi");
    	new_line;
    	pragma assert(donnee_presente1(arbre2,250));
    	put("test5 réussi");
    	new_line;
    	pragma assert(cle(arbre2)=5);
    	put("test6 réussi");
    	new_line;
    	pragma assert(donnee(arbre2)=250);
    	put("test7 réussi");
    	new_line;
    	-- l'arbre 1 est une feuille de clé 2 et de donnée 35
    	arbre1:=construction_feuille(2,35);
    	pragma assert(taille(arbre1)=0);
    	pragma assert(est_une_feuille(arbre1));
    	pragma assert(est_vide(droit(arbre1)));
    	pragma assert(est_vide(gauche(arbre1)));
    	pragma assert(donnee_presente1(arbre1,25));
    	pragma assert(cle(arbre1)=5);
    	pragma assert(donnee(arbre1)=35);
    	
    	initialiser(arbre3);
    	arbre3:=construction_feuille(7,75);
    	
    	
    -- on fusionne dans l'abre1 : l'arbre1 et l'arbre2
        fusion(arbre1,arbre2,0);
        
    -- on fusionne ensuite l'abre 1 et 3
        fusion(arbre1,arbre3,0);
    	
    	
    	pragma assert(cle(arbre1)=14);
    	pragma assert(taille(arbre1)=5);
    	pragma assert(not est_une_feuille(arbre1));
    	pragma assert(gauche(arbre1)=arbre3);
    	pragma assert(code_associe(arbre1,75)="0");
    	pragma assert(code_associe(arbre1,250)="10");
    	pragma assert(code_associe(arbre1,35)="11");
    	incrementer_frequence(arbre1);
    	pragma assert(cle(arbre1)=15);
    	
    	Put_Line ("Fin des tests : OK.");
    	vider(arbre1);
    	pragma assert (taille(arbre1)=0);
    	
    	
    	
end test_arbre;
    	
    	 
    	 
    	
    	
    	
    	
    	
    	
    	
    	



