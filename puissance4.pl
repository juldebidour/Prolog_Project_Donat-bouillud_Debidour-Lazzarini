
%% AFFICHAGE
% Affichage global du plateau
affichagePlateau(NbLignes, Plateau) :-
    NbLignes > 0,  % Vérifie qu'il reste des lignes à afficher
    write("| "),
    afficherColonnes(Plateau, NbLignes),  % Affiche les éléments à la ligne actuelle
    write(" |"), nl,  % Saut de ligne
    NbLignesSuivantes is NbLignes - 1,  % Passe à la ligne suivante
    affichagePlateau(NbLignesSuivantes, Plateau).  % Appel récursif
affichagePlateau(0, _) :- nl .  

% Fonction récursive pour afficher chaque colonne d'une ligne donnée

afficherColonnes([], Indice) :- !.
afficherColonnes([Colonne|Reste], Indice) :-
    afficher(Colonne, Indice),  % Affiche l'élément de la colonne à l'indice donné
    write(" "),  % Ajoute un espace entre les colonnes
    afficherColonnes(Reste, Indice).  % Appel récursif pour les colonnes restantes

afficher_liste([]) :-!. 

% Fonction pour afficher un élément spécifique d'une colonne
afficher(Colonne, Indice) :-
    nth1(Indice, Colonne, Element), write(" "), % Récupère l'élément à l'indice donné
    write(Element), write(" "), !.  % Affiche l'élément s'il existe
afficher(_, _) :- write(' . ').

initialisationJeu(J1, J2) :- write("Bienvenue, joueur 1 : "), write(J1), write(" et joueur 2 : "),write(J2),nl, 
 PlateauVide= [[],[],[],[],[],[],[]], etatJeu(PlateauVide,J1,J2,J1).

etatJeu(Plateau, J1, J2, JA) :- nl, write('C''est à '), write(JA) , write(" de jouer. Voici le plateau de jeu : "),nl, affichagePlateau(6,Plateau), demander_chiffre(Plateau, J1,J2, JA). % affichagePlateau

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
%finJeu(Plateau, ).
