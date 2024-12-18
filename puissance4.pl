
%% AFFICHAGE
% Affichage global du plateau
% Affiche le plateau avec les numéros de colonnes
affichagePlateau(_, Plateau) :-
    write("  1   2   3   4   5   6   7 "), nl,
    write("-----------------------------"), nl,
    affichageLignes(6, Plateau).

% Affiche les lignes du plateau
affichageLignes(0, _) :- nl.
affichageLignes(N, Plateau) :-N > 0,afficherLigne(N, Plateau),nl,
    write("-----------------------------"), nl,
    N1 is N - 1, affichageLignes(N1, Plateau).

% Affiche une ligne donnée
afficherLigne(N, []) :- write("|").
afficherLigne(N, [Colonne|Reste]) :-
    (nth1(N, Colonne, Element) -> write("| "), write(Element), write(" ") ; write("| . ")),
    afficherLigne(N, Reste).
%%DEBUT DU JEU
%Demander le mode de jeu
demanderModeJeu :- write('Bienvenue dans ce jeu du puissance 4 !'), nl, write('Si vous voulez jouer avec un humain, tapez 1. Si vous voulez jouer contre la machine, tapez 2 : '),  
    read(Input),                                       
    (   integer(Input),                                
        Input >= 1,
        Input =< 2
    ->  choixJeu(Input)                                 
    ;   write('Entrée invalide. '), nl,
        demanderModeJeu                   
    ).
%Si le jeu est contre une autre personne, on demande les noms et on lance le jeu en multi. Sinon on demande le nom de l'unique joueur et on lance le jeu contre notre algo.
choixJeu(Numero) :- Numero is 1, nomJoueurs(Joueur1, Joueur2),initialisationJeu(Joueur1, Joueur2) ; Numero is 2 , write('Veuillez entrer votre nom : '), read(Joueur),nl, initialisationJeuSeul(Joueur).

%Demander le nom des joueurs
nomJoueurs(Joueur1, Joueur2) :- write('Veuillez entrer le nom du joueur 1 : '), read(Joueur1), write('Veuillez entrer le nom du joueur 2 : '), 
    read(Joueur2),nl,format('Bienvenue ~w et ~w, le jeu peut commencer !', [Joueur1, Joueur2]),nl.

%% INITIALISATION DU JEU
%Jeu en multi
initialisationJeu(J1, J2) :- PlateauVide= [[],[],[],[],[],[],[]], etatJeu(PlateauVide,J1,J2,J1).

%Jeu contre la machine
initialisationJeuSeul(Joueur) :- PlateauVide= [[],[],[],[],[],[],[]], etatJeu(PlateauVide,Joueur,'Robot',Joueur).

%% TOUR DE JEU D'UN JOUEUR
%On affiche l'état du jeu
etatJeu(Plateau, J1, J2, JA) :- nl, write('C''est à '), write(JA) , write(" de jouer. Voici le plateau de jeu : "),nl, affichagePlateau(6,Plateau), tourDeJeu(Plateau, J1,J2, JA).

%On regarde si c'est à un joueur ou au robot de jouer. Si c'est au joueur, on lui demande un chiffre, sinon le robot joue son coup.
tourDeJeu(Plateau,J1,J2,JA) :- dif(JA,'Robot'),demander_chiffre(Plateau,J1,J2,JA); coupRobot(Plateau,J1,J2,JA).

coupRobot(Plateau,J1,J2,JA):- robotChoixCoup(Plateau, J1, J2, JA, CoupRobot),verifierTaille(Plateau,J1, J2, JA, CoupRobot).
robotChoixCoup(Plateau, J1, J2, JA, CoupRobot):-CoupRobot is 1.


demander_chiffre(Plateau,J1,J2,JA) :-
    nl,
    write('Veuillez entrer un chiffre entre 1 et 7 : '),  
    read(Input),                                       
    (   integer(Input),                                
        Input >= 1,
        Input =< 7
    ->  verifierTaille(Plateau,J1, J2, JA, Input)                                 
    ;   write('Entrée invalide. '), nl,
        demander_chiffre(Plateau,J1,J2,JA)                    
    ) .

choisirPion(J1,J2,JA, Pion) :- dif(J1,JA), Pion = "X" ; dif(J2,JA), Pion = "O" .
changerJoueur(J1,J2,JA,JS) :- dif(J1,JA), JS = J1; dif(J2,JA), JS = J2 .

%% GESTION D'UN COUP DE JEU
coup(Plateau, J1, J2, JA, Chiffre) :- choisirPion(J1, J2, JA, Pion), changerJoueur(J1, J2, JA, JS), ajouterPion(Plateau, Chiffre, Pion, NouveauPlateau), verificationfinduJeu(NouveauPlateau, Chiffre, J1, J2, JA, JS).   

% Vérifie qu'on peut ajouter un pion
verifierTaille(Plateau,J1,J2,JA, NumColonne) :- recupererColonne(Plateau, NumColonne, ColonneVoulue), length(ColonneVoulue, Taille), Taille >= 6, write('Cette colonne est pleine.'), demander_chiffre(Plateau,J1,J2,JA); 

% Ajoute un pion si on le peut en récupérant la colonne voulue
recupererColonne(Plateau, NumColonne, ColonneVoulue), length(ColonneVoulue, Taille), Taille < 6,coup(Plateau,J1, J2, JA, NumColonne).
recupererColonne([Colonne|Reste], Indice, ColonneVoulue) :- IndiceSuivant is Indice-1 , recupererColonne(Reste, IndiceSuivant, ColonneVoulue).
recupererColonne([Colonne|Reste], 1,ColonneVoulue) :- ColonneVoulue = Colonne.


% Ajoute un pion dans une colonne donnée (reconstruit le plateau)
ajouterPion([Colonne|Reste], 1, Pion, [NouvelleColonne|Reste]) :- ajouterColonnePionFin(Colonne, Pion, NouvelleColonne). % Choisi la bonne colonne pour ajouter le pion
ajouterPion([Colonne|Reste], Chiffre, Pion, [Colonne|NouveauReste]) :- Chiffre > 1, ChiffreSuivant is Chiffre - 1, ajouterPion(Reste, ChiffreSuivant, Pion, NouveauReste). 

% Ajoute un élément à la fin d'une colonne
ajouterColonnePionFin([], Pion, [Pion]). 
ajouterColonnePionFin([T|Q], Pion, [T|R]) :- ajouterColonnePionFin(Q, Pion, R).



%%VERIFICATION
% VERIFICATION 1 : vérification si le plateau de jeu est pleins.
verificationfinduJeu(Plateau, Chiffre, J1, J2, JA, JS) :-
    ( grilleremplie(Plateau) ->
        write("La grille est pleine. Match nul !"), nl, finDuJeu
    ; verificationColonne(Plateau, Chiffre, J1, J2, JA, JS) % On vérifie maintenant toutes les colonnes
    ).

grilleremplie([]) :- true. % Toutes les colonnes sont pleines
grilleremplie([Colonne|Reste]) :- length(Colonne, Taille), ( Taille >= 6 -> grilleremplie(Reste) ; fail).

% VERIFICATION 2: vérifie si il y a 4 pions alignés dans la colonne ou le dernier joueur a mis son pion
verificationColonne(Plateau, Chiffre, J1, J2, JA, JS) :-
    recupererColonne(Plateau, Chiffre, ColonneVoulue),
    ( aColonne(ColonneVoulue) ->
        write(JA), write(" a gagné !"), nl, affichagePlateau(6,Plateau), finDuJeu 
        ; verificationLigne(Plateau, Chiffre, J1, J2, JA, JS)
    ).
% Vérifie si une colonne contient une suite de 4 termes identiques
aColonne(Colonne) :- length(Colonne, Taille), Taille >= 4, contientSuiteDeQuatre(Colonne).

% Vérifie si une suite de 4 termes identiques existe dans la liste
contientSuiteDeQuatre([X, X, X, X | _]) :- X \= ".", X \= '.' . 
contientSuiteDeQuatre([_ | Reste]) :- contientSuiteDeQuatre(Reste).

%VERIFICATION 3 : vérifie si il y a 4 pions alignés sur la ligne ou le dernier joueur a mis son pion
verificationLigne(Plateau, Chiffre, J1, J2, JA, JS) :- recupererColonne(Plateau, Chiffre, ColonneVoulue), length(ColonneVoulue, Ligne),
    ( aLigne(Plateau, Ligne) ->
        write(JA), write(" a gagné !"), nl, affichagePlateau(6,Plateau), finDuJeu ; 
    verificationDiagonale(Plateau, Chiffre, J1, J2, JA, JS)
    ).

% Vérifie si une ligne contient une suite de 4 symboles identiques en construidant la ligne ou le dernier joueur a mis son pio et en regardant si il y a une suite
aLigne(Plateau, Ligne) :- construireLigne(Plateau, Ligne, LigneConstruite), contientSuiteDeQuatre(LigneConstruite).

% Construit une ligne en rassemblant les éléments correspondants à l'index Ligne dans chaque colonne
construireLigne([], _, []). % Cas de base : on a parcouru toutes les colonnes du plateau, la ligne est entièrement construite
construireLigne([Colonne|ResteColonnes], Ligne, [Element|ResteLigne]) :- ( nth1(Ligne, Colonne, Element) -> true ; Element = '.'), construireLigne(ResteColonnes, Ligne, ResteLigne).


%VERIFICATION 4 : vérifie si il y a 4 pions alignés sur une diagonale où le dernier joueur a mis son pion
verificationDiagonale(Plateau, Chiffre, J1, J2, JA, JS) :- recupererColonne(Plateau, Chiffre, ColonneVoulue), length(ColonneVoulue, Ligne),
    ( aDiagonale(Plateau, Ligne, Chiffre) ->
        write(JA), write(" a gagné !"), nl, affichagePlateau(6,Plateau), finDuJeu ; 
    etatJeu(Plateau, J1, J2, JS)
    ).
aDiagonale(Plateau, Ligne, Colonne) :- aDiagonale1(Plateau, Ligne, Colonne) ; aDiagonale2(Plateau,Ligne,Colonne).

%%On regarde si il existe une diagonale : haut-gauche - bas-droite de 4 éléments ou plus. Si oui, on va la construire et regarder si elle contient 4 éléments identiques à la suite.
aDiagonale1(Plateau, Ligne, Colonne) :- TotalLigneColonne is Ligne + Colonne,
    ( TotalLigneColonne >= 5, TotalLigneColonne =< 11 ->
    construireDiagonale1(Plateau, TotalLigneColonne, Diagonale1Construite),contientSuiteDeQuatre(Diagonale1Construite)
    ; false).

%On construit la diagonale
construireDiagonale1(Plateau, TotalLigneColonne, Diagonale1Construite) :- debutDiagonale(TotalLigneColonne, LigneDebut, ColonneDebut), recupererdiagonale1(Plateau,LigneDebut, ColonneDebut, Diagonale1Construite).

%On regarde quelle est la ligne et la colonne de début de cette diagonale en partant du coté gauche du plateau de jeu
debutDiagonale(TotalLigneColonne, LigneDebut, ColonneDebut) :- ( TotalLigneColonne > 7 ->
    LigneDebut is 6, ColonneDebut is TotalLigneColonne - 6
    ; LigneDebut is TotalLigneColonne - 1 , ColonneDebut is 1 ).


% Récupère les éléments d'une diagonale dans la direction "bas-gauche à haut-droite"
recupererdiagonale1(_, Ligne, Colonne, []) :-  Ligne < 1 ; Colonne > 7. % Condition d'arrêt : ligne < 1 ou colonne > 7

recupererdiagonale1(Plateau, Ligne, Colonne, [Element|Reste]) :-
    recupererElement(Plateau, Ligne, Colonne, Element), % Récupère l'élément à la position (Ligne, Colonne)
    LigneSuivante is Ligne - 1, % Passe à la ligne précédente
    ColonneSuivante is Colonne + 1, % Passe à la colonne suivante
    recupererdiagonale1(Plateau, LigneSuivante, ColonneSuivante, Reste).

% Récupère l'élément (ligne, colonne) dans le plateau
recupererElement(Plateau, Ligne, Colonne, Element) :-
    nth1(Colonne, Plateau, CurrentCol), 
    (nth1(Ligne, CurrentCol, Element) -> true ; Element = '.'). % Si l'élément existe, récupère-le, sinon insère '.'

%Faire la diagonale 2
%%On regarde si il existe une diagonale : bas-gauche - haut-droite de 4 éléments ou plus. Si oui, on va la construire et regarder si elle contient 4 éléments identiques à la suite.
aDiagonale2(Plateau, Ligne, Colonne) :- ColonneMoinsLigne is Colonne-Ligne,
    ( ColonneMoinsLigne >= -2, ColonneMoinsLigne =< 3 ->
    construireDiagonale2(Plateau, ColonneMoinsLigne, Diagonale2Construite), contientSuiteDeQuatre(Diagonale2Construite)
    ; false).

%On construit la diagonale
construireDiagonale2(Plateau, ColonneMoinsLigne, Diagonale2Construite) :- debutDiagonale2(ColonneMoinsLigne, LigneDebut, ColonneDebut), recupererdiagonale2(Plateau,LigneDebut, ColonneDebut, Diagonale2Construite).

%On regarde quelle est la ligne et la colonne de début de cette diagonale en partant du coté gauche du plateau de jeu
debutDiagonale2(ColonneMoinsLigne, LigneDebut, ColonneDebut) :- ( ColonneMoinsLigne >= 1 ->
    LigneDebut is 7 - ColonneMoinsLigne, ColonneDebut is 7
    ; LigneDebut is 6 , ColonneDebut is 6+ ColonneMoinsLigne), !.


% Récupère les éléments d'une diagonale dans la direction "bas-gauche à haut-droite"
recupererdiagonale2(_, Ligne, Colonne, []) :-  Ligne < 1 ; Colonne > 7. % Condition d'arrêt : ligne < 1 ou colonne > 7

recupererdiagonale2(Plateau, Ligne, Colonne, [Element|Reste]) :-
    recupererElement(Plateau, Ligne, Colonne, Element), % Récupère l'élément à la position (Ligne, Colonne)
    LigneSuivante is Ligne - 1, % Passe à la ligne précédente
    ColonneSuivante is Colonne - 1, % Passe à la colonne suivante
    recupererdiagonale2(Plateau, LigneSuivante, ColonneSuivante, Reste).

%Fin du jeu
finDuJeu :- write('Le jeu est terminé ! Merci d''avoir joué.'), nl,halt.
