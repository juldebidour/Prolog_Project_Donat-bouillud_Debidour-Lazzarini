


afficher_liste([]) :-!. 

afficher_liste([T|Q]) :-
    write(T),  % Affiche le premier élément
    nl,           % Passe à la ligne suivante
    afficher_liste(Q).


initialisationJeu(J1, J2) :- write("Bienvenue, joueur 1 : "), write(J1), write(" et joueur 2 : "),write(J2),nl, 
 PlateauVide= [[],[],[],[],[],[],[]], etatJeu(PLateauVide,J1,J2,J1).



etatJeu(Plateau, J1, J2, JA) :- write("C'est à "), write(JA) , write(" de jouer. Voici le plateau de jeu : "),nl, write(Plateau), demander_chiffre(Plateau, J1,J2, JA). % affichagePlateau

demander_chiffre(Plateau,J1,J2,JA) :-
    nl,
    write('Veuillez entrer un chiffre entre 1 et 7 : '),  
    read(Input),                                       
    (   integer(Input),                                
        Input >= 1,
        Input =< 7
    ->  coup(Plateau,J1, J2, JA, Input)                                 
    ;   write('Entrée invalide. '), nl,
        demander_chiffre(Plateau,J1,J2,JA)                    
    ) .
choisirPion(J1,J2,JA, Pion) :- dif(J1,JA), Pion = "X" ; dif(J2,JA), Pion = "O" .
changerJoueur(J1,J2,JA,JS) :- dif(J1,JA), JS = J1; dif(J2,JA), JS = J2 .

coup(Plateau,J1, J2, JA, Chiffre) :- choisirPion(J1,J2,JA, Pion), changerJoueur(J1,J2,JA,JS), etatJeu(Plateau, J1,J2,JS).

%append(nth1(Chiffre, Plateau, 1), [1], Plateaufutur), 
%write("Le joueur"), write(JA), write("a mis son point dans la colonne"), write(Chiffre),
%etatJeu(Plateaufutur, J1,J2,J2).

a(X) :-  write(X).
finJeu(Plateau, ).
