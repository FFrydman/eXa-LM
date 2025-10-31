
:- dynamic(avoir/8), dynamic(lire/8), dynamic(devenir/8), dynamic(estun/9), dynamic(estune_partie_de/10).


fs0(P) :-
	current_predicate(_,P), 
	P.

fs0(P) :- !, fail.  


% Si X est un Y Q2 alors X est Q2.
être(X,Q2,[[],[]],[_,[EtqQ2]],_,[[],[]],'si/CS/jamais|si/CS X/X/ACRO est_un/MHYPONYME Y/Y/ACRO Q/ADJ-* alors/alors/ADV X/X/ACRO est/être/V Q/ADJ-*','l') :- 
	fs0(\+ dif(EtqQ2,'ADJ')), 
	estun(X,_,[[],[]],[_,['NC']],[],[[],Q],_,'l'), \+var(Q), dif(Q,[]),
	fs0(member(Q2,Q)).

% Si X est membre de Y alors X fait partie de Y.
estune_partie_de(X,Y,[[],[]],[_,_],[],[_,_],'si/CS/jamais|si/CS X/X/ACRO est/être/V membre/membre de Y/Y/ACRO alors/alors/ADV X/X/ACRO fait_partie_de/MMERONYME Y/Y/ACRO','l') :- 
	être(X,Y,[[],[]],[_,_],['membre'],[_,_],_,'l').

% Si estun(X,Y,Z) alors estun(X,Y).
estun(X,Y,[[],[]],[_,_],_,[[],[]],'si/CS/jamais|si/CS X/X/ACRO est_un/MHYPONYME Y/Y/ACRO Z/Z/ACRO alors/alors/ADV X/X/ACRO est_un/MHYPONYME Y/Y/ACRO','l') :-
	estun(X,Y,Z,[[],[],[]],[_,_,_],_,[[],[],_],_,'l').

% Si X a des Y et X est un Z alors X est un Z avec Y.
estun(X,Z,Y,[[],[],[avec]],[_,_,_],[],[[],[],[]],'si/CS/jamais|si/CS X/X/ACRO a/avoir/V des Y/Y/ACRO et/et/CC X/X/ACRO est_un/MHYPONYME Z/Z/ACRO alors/alors/ADV X/X/ACRO est_un/MHYPONYME Z/Z/ACRO avec/avec/P Y/Y/ACRO','l') :-
	avoir(X,Y,[[],[]],[_,_],[],[_,_],_,'l'), \+var(Y),
	estun(X,Z,[[],[]],[_,_],[],[[],[]],_,'l').
	
% Si X n'a pas de Y et X est un Z alors X est un Z sans Y.	
estun(X,Z,Y,[[],[],[sans]],[_,_,_],[],[[],[],[]],'si/CS/jamais|si/CS X/X/ACRO ne/ne/ADV a/avoir/V pas/pas|pas/ADV-* de Y/Y/ACRO et/et/CC X/X/ACRO est_un/MHYPONYME Z/Z/ACRO alors/alors/ADV X/X/ACRO est_un/MHYPONYME Z/Z/ACRO sans/sans/P Y/Y/ACRO','l') :-
	not(avoir(X,Y,[[],[]],[_,_],[],[_,_],_,'l')), \+var(Y),
	estun(X,Z,[[],[]],[_,_],[],[[],[]],_,'l').

% Si X a lu le livre Y alors Y est un livre.
estun(X,'livre',[[],[]],[_,NC],[],[_q1,[]],'si/CS/jamais|si/CS X/X/ACRO a/avoir/V lu/lire/VPP le livre/livre|livrer/V|livrer/VIMP Y/Y/ACRO alors/alors/ADV X/X/ACRO est_un/MHYPONYME livre/livre|livrer/V|livrer/VIMP','l') :- 
	lire(Y,X,[[],[]],[_,_],['livre'],[_q2,_q1],_,'l').

% Si X a lu le livre Y alors X a lu un livre.
lire(Y,'livre',[[],[]],[_,NC],[],[_q1,[]],'si/CS/jamais|si/CS X/X/ACRO a/avoir/V lu/lire/VPP le livre/livre|livrer/V|livrer/VIMP Y/Y/ACRO alors/alors/ADV X/X/ACRO est_un/MHYPONYME livre/livre|livrer/V|livrer/VIMP','l') :- 
	lire(Y,X,[[],[]],[_,_],['livre'],[_q2,_q1],_,'l').

% Si X devient plus intelligent alors X est plus intelligent qu'avant.	
être(X,[[]],[_],['plus','intelligent','que'],[[]],' X/X/ACRO est/être/V plus/plaire/VPP|plus/ADV|plus intelligent/intelligent/ADJ que/que/CS|que?/PROWH|que/PROREL avant/avant/ADV|avant|avant/P-*','l') :- 
	devenir(X,intelligent,[[],[]],[_,ADJ],['plus'],[_q1,[]],_,'l').

% Si Z de Y vient de X alors Y vient de X.
venir(Y,X,[[],[]],[_,_],[],[[],[]],_,'l') :- 
	venir(_,X,[[],[]],[_,_],[Y],[[],[]],_,'l').

% Si X de Y commence par X alors Z commence par X.
commencer(X,Z,[[],[]],[_,_],[Y|T],[[],[]],_,'l') :- \+ var(Z),
	commencer(X,Y,[[],[]],[_,_],T,[[],[]],_,'l').
	
% Si X est un Y dans Z alors Z abrite le Y de X.
abriter(Z,X,[[],[]],[_,_],[Y],[[],[]],'Z abrite le Y de X','l') :- 
	estun(X,Y,Z,[[],[],[dans]],[_,_,_],[],[[],[],[]],_,'l').


% Si alors X est une partie de Y le Z T
estune_partie_de(X,Y,[[],[]],[['NC/NPP'],['NC']],[],[[],[Z,T]],'Si alors X est une partie de Y le Z T','l') :- 
	estune_partie_de(X,Y,T,_,[[],[],[],[]],[_,['NC'],['ADJ'],['NC']],[Z,_],[_,[],[],[]],_,'l').


% Si X est F1 par Y alors  _ est un X F1 par Y
estun(_,X,Y,[[],[],[]],[_,_,_],[],[[],F1,[]],'Si X est F1 par Y alors  _ est un X F1 par Y','l') :- \+ var(X),
	être(Y,X,[[],[]],[['NC/NPP'],['NC/NPP']],F1,[[],[]],_,'l').
