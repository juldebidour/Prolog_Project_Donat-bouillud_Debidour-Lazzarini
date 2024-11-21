% Résolution du problème des tours de Hanoi avec comptage des étapes et affichage final du nombre d/étapes à effectuer 

% Fonction de résolution qui compte le nombre d/étapes

hanoi(N) :-
    write('Résolution du problème de Hanoi à'), write(N), write(' disques :'), nl,
    write('Liste ordonnée des déplacement des '), write(N), write(' disques :'), nl,
    hanoi(N, 'A', 'C', 'B', 0, TotalÉtapes), % Initialiser le compteur d/étapes à 0
    nl,
    write('Nombre total étapes minimum : '), write(TotalÉtapes), nl.

% Cas limite - un seul disque : déplacer le disque et ajouter une étape dans le comptage

hanoi(1, Origine, Destination, _, ÉtapesActuelles, ÉtapesFinales) :-
    format('À ce tour, il faut déplacer le disque en haut de la pile ~w à la pile ~w~n', [Origine, Destination]),
    ÉtapesFinales is ÉtapesActuelles + 1.

% Cas général : décomposer le problème et accumuler les étapes

hanoi(N, Origine, Destination, Intermediaire, ÉtapesActuelles, ÉtapesFinales) :-
    N > 1,
    M is N - 1,
    hanoi(M, Origine, Intermediaire, Destination, ÉtapesActuelles, Étapes1), % Déplacer N-1 disques vers l/intermédiaire
    hanoi(1, Origine, Destination, _, Étapes1, Étapes2),                     % Déplacer le disque le plus grand vers la destination
    hanoi(M, Intermediaire, Destination, Origine, Étapes2, ÉtapesFinales).  % Déplacer les N-1 disques vers la destination
