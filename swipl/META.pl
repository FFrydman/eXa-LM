
% Si X<>Y et X est un Y et R0(Y) alors R0(X).
meta([Relation0,X,[_],[_],[],[_],'si/CS/jamais|si/CS X/X/ACRO estun/MHYPONYME Y/Y/ACRO et/et/CC Relation0/Relation0/V Y/Y/ACRO alors/alors/ADV Relation0/Relation0/V X/X/ACRO','l'],T1,T3) :- 
fs(estun(X,Y,[[],[]],[_,_],[],[[],[]],_,'l'),T1,T2), !, dif(X,Y), \+ var(X), meta([Relation0,Y,[_],[_],[],[_],_,'l'],T2,T3).

% Si X<>Y et X est un Y et R0(Z,X) alors R0(Z,Y)
meta([Relation0,Z,Y,[_,_],[_,_],F1,[Q1,Q2],'si/CS/jamais|si/CS X/X/ACRO estun/MHYPONYME Y/Y/ACRO et/et/CC Z/Z/ACRO Relation0/Relation0/V X/X/ACRO alors/alors/ADV Z/Z/ACRO Relation0/Relation0/V Y/Y/ACRO','l'],T1,T3) :- 
fs(estun(X,Y,[[],[]],[_,_],[],[[],Q2],_,'l'),T1,T2), dif(X,Y), \+ var(X), meta([Relation0,Z,X,[_,_],[_,_],F1,[Q1,_],_,'l'],T2,T3).


% Si X<>Y et X est un Y P T et R0(Z,X) alors R0(Z,Y,P,T)
meta([Relation0,Z,Y,T,[_,_,P],[_,_,_],[],[Q1,Q2,Q3],'si/CS/jamais|si/CS X/X/ACRO estun/MHYPONYME Y/Y/ACRO et/et/CC Z/Z/ACRO Relation0/Relation0/V X/X/ACRO <préposition> T/T/ACRO alors/alors/ADV Z/Z/ACRO Relation0/Relation0/V Y/Y/ACRO <préposition> T/T/ACRO','l'],T1,T3) :- 
fs(estun(X,Y,T,[[],[],P],[_,_,_],[],[[],Q2,Q3],_,'l'),T1,T2), dif(X,Y), \+ var(X), meta([Relation0,Z,X,[_,_],[_,_],[],[Q1,_],_,'l'],T2,T3).

% Si X<>Y et X est un Y et R0(Y,Z) alors R0(X,Z).
meta([Relation0,X,Z,[_,_],[_,_],F1,[Q1,Q2],'si/CS/jamais|si/CS X/X/ACRO estun/MHYPONYME Y/Y/ACRO et/et/CC Y/Y/ACRO Relation0/Relation0/V Z/Z/ACRO alors/alors/ADV X/X/ACRO Relation0/Relation0/V Z/Z/ACRO','l'],T1,T3) :- 
fs(estun(X,Y,[[],[]],[_,_],[],[[],[]],_,'l'),T1,T2), !, dif(X,Y), (dif(Relation0,'être');F1=[]), \+ var(X), meta([Relation0,Y,Z,[_,_],[_,_],F1,[Q1,Q2],_,'l'],T2,T3).


%  Si X<>Y et X est un Y et R0(X,Z) alors certains R0(Y,Z).
meta([Relation0,Y,Z,[_,_],[_,_],F1,[[certain|Q3],_],'si/CS/jamais|si/CS X/X/ACRO estun/MHYPONYME Y/Y/ACRO et/et/CC X/X/ACRO Relation0/Relation0/V Z/Z/ACRO alors/alors/ADV certains Y/Y/ACRO Relation0/Relation0/V Z/Z/ACRO','l'],T1,T3) :- 
	fs(estun(X,Y,[[],[]],[_,_],[],[Q1,Q3],_,'l'),T1,T2), !, dif(X,Y), dif(Relation0,'estun'), \+ var(X), \+ member(estun(X,Y,[[],[]],[_,_],[],[Q1,Q3],_,'l'),T1),
	meta([Relation0,X,Z,[_,_],[_,_],F1,[Q1,_],_,'l'],T2,T3).
	

% Si T<>X et T est un X P2 Y et R0(T,Z,P2) alors R0(X,Y,Z,P2,F1).
meta([Relation0,X,Y,Z,[_,P1,P2],[_,_,_],F1,[Q1,_,_],'Si T<>X et T est un X P2 Y et T R0 P2 Z alors X R0 P1 F1 Y P2 Z','l'],T1,T3) :- 
	fs(estun(T,X,Y,[[],[],P2],[_,_,_],F1,[_,Q1,_],_,'l'),T1,T2), !, dif(T,X), dif(Relation0,'estun'), \+ var(X), \+ member(estun(T,X,Y,[[],[],P2],[_,_,_],F1,[_,_,_],_,'l'),T1),
	meta([Relation0,T,Z,[_,P2],[_,_],[],[_,_],_,'l'],T2,T3).


%  Si X<>Y et X est un Y et R0(Z,Y) alors R0(Z,X).
meta([Relation0,Z,X,[_,_],[_,_],[],[Q1,Q2],'si/CS/jamais|si/CS X/X/ACRO estun/MHYPONYME Y/Y/ACRO et/et/CC Z/Z/ACRO Relation0/Relation0/V Y/Y/ACRO alors/alors/ADV Z/Z/ACRO Relation0/Relation0/V X/X/ACRO','l'],T1,T3) :- 
fs(estun(X,Y,[[],[]],[_,_],[],[[],Q2],_,'l'),T1,T2), !, dif(X,Y), \+ var(X), \+ member(estun(X,Y,[[],[]],[_,_],[],[[],Q2],_,'l'),T1), meta([Relation0,Z,Y,[_,_],[_,_],[],[Q1,_],_,'l'],T2,T3).


% Si X R0 Y P Z alors X R0 Y.
meta([Relation0,X,Y,[[],P],[_,_],[],[Q1,Q2],'Si X R0 Y P Z alors X R0 Y','l'],T1,T3) :-
	\+ var(X), \+ var(Y), dif(Relation0,'estun'), dif(Relation0,'être'), dif(P,[]), 
	meta([Relation0,X,Y,Z,[_,_,_],[_,_,_],[],[Q1,Q2,_],_,'l'],T2,T3).


% Si R0(X,Y,[beaucoup]) alors R0(X,Y).
meta([Relation0,X,Y,[_,_],[_,_],[],[Q1,Q2],'si/CS/jamais|si/CS X/X/ACRO Relation0/Relation0/V beaucoup Y/Y/ACRO alors/alors/ADV X/X/ACRO Relation0/Relation0/V Y/Y/ACRO ','l'],T1,T3) :-
meta([Relation0,X,Y,[_,_],[_,_],['beaucoup'],[Q1,Q2],_,'l'],T1,T3).

% Si R1 est synonyme de R2 et X R1 Y alors X R2 Y.
meta([Relation2,X,Y,[_,_],[_,_],[],[[],[]],'si/CS/jamais|si/CS Relation1/Relation1 est/être le synonyme/synonyme/ADJ|synonyme-* de Relation2/Relation2 et/et/CC X/X/ACRO Relation1/Relation1 Y/Y/ACRO alors/alors/ADV X/X/ACRO Relation2/Relation2 Y/Y/ACRO','l'],T1,T3) :- 
fs(être(Relation1,Relation2,[[],[]],[[],[]],['synonyme'],[[],[]],_,'l'),T1,T2), meta([Relation1,X,Y,[_,_],[_,_],[],[[],[]],_,'l'],T2,T3).

% Si X R Z et Y R Z et X est différent de Y alors les X sont analogues aux Y.
meta([être,X,Y,[[],[à]],[_,_],[analogue],[[],[]],'si/CS/jamais|si/CS X/X/ACRO Relation0/Relation0 Z/Z/ACRO et/et/CC Y/Y/ACRO Relation0/Relation0 Z/Z/ACRO et/et/CC $dif_X_Y/$dif_X_Y/NPP alors/alors/ADV les X/X/ACRO sont/être analogues/analogue/ADJ à/à/P Y/Y/ACRO','l'],T1,T4) :- meta([Relation0,X,Z,[_,_],[_,_],[],[[],[]],_,'l'],T1,T2), meta([Relation0,Y,Z,[_,_],[_,_],[],[[],[]],_,'l'],T2,T3), fs(dif(X,Y),T3,T4).
meta([être,X,Y,[[],[à]],[_,_],[analogue],[[],[]],'si/CS/jamais|si/CS X/X/ACRO Relation0/Relation0 Z/Z/ACRO et/et/CC Y/Y/ACRO Relation0/Relation0 Z/Z/ACRO et/et/CC $dif_X_Y/$dif_X_Y/NPP alors/alors/ADV les X/X/ACRO sont/être analogues/analogue/ADJ à/à/P Y/Y/ACRO','l'],T1,T4) :- meta([Relation0,X,Y,[_,_],[_,_],[],[[],[]],_,'l'],T1,T2), meta([Relation0,Y,$dif,[_,_],[_,NC],[],[[],[X,Y]],_,'l'],T2,T3), fs(dif(X,Y),T3,T4).

