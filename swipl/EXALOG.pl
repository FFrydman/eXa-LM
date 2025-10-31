:- module('EXALOG', [exalog/7]).
:- table call_mapping/5, prove/6, meta/3.
:- include('EXAMETA.pl').
:- include('META.pl').


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% eXaLog : traitement des quantificateurs généralisés et des qualificateurs %
% 					       Francis Frydman - 18/10/2022 					%
%			(révision 31/08/2025: compatibilité SWI Prolog 9.2.9			%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extraction des caractéristiques d'un prédicat linguistique :

caracteristiques(not(P),Prepositions,Etiquettes,QFoncteurs,QAttributs,Texte) :- !,
	caracteristiques(P,Prepositions,Etiquettes,QFoncteurs,QAttributs,Texte).

caracteristiques(P,Prepositions,Etiquettes,QFoncteurs,QAttributs,Texte) :-
 	functor(P,_,Arite),
	I is Arite-5,
	J is Arite-4,
	K is Arite-3,
	L is Arite-2,
	M is Arite-1,
	arg(I,P,Prepositions),
	arg(J,P,Etiquettes),
	arg(K,P,QFoncteurs),
	arg(L,P,QAttributs),
	arg(M,P,Texte),!.

% Extraction des arguments d'un prédicat linguistique :

arguments(P,I,Init,Args) :-
	functor(P,_,Arite),
	I < Arite-5,
	arg(I,P,Arg),
	\+var(Arg),
	append(Init,[Arg],Args2),
	I2 is I+1,
	arguments(P,I2,Args2,Args),!.

arguments(P,I,Init,Args) :-
	functor(P,_,Arite),
	I < Arite-5,
	arg(I,P,Arg),
	var(Arg),
	I2 is I+1,
	arguments(P,I2,Init,Args),!.

arguments(P,I,Args,Args) :- !.

% le prédicat A est-il plus général (ou égal) que le prédicat B?

% Si deux négations, on compare les termes niés (si seulement une, traité par "les deux foncteurs sont différents")
plusgeneralouegal(not(A),not(B),L,Cas) :- plusgeneralouegal(A,B,L,Cas).


% Non si les deux foncteurs sont différents
plusgeneralouegal(A,B,_,_)  :- 
	functor(A,FoncteurA,_),
	functor(B,FoncteurB,_), 
	dif(FoncteurA,FoncteurB),
	!, fail.

% sinon :
plusgeneralouegal(A,A,_,_) :- !.


% extraction des caractéristiques des foncteurs et attributs
plusgeneralouegal(A,B,L,Cas) :-
	caracteristiques(A,_,_,QFoncteursA,QAttributsA,_),
	caracteristiques(B,_,_,QFoncteursB,QAttributsB,_),
	\+(var(QFoncteursA)), \+(var(QFoncteursB)), \+(var(QAttributsA)), \+(var(QAttributsB)), 
	pge(QFoncteursA,QFoncteursB,QAttributsA,QAttributsB,L,Cas).

plusgeneralouegal(A,B,L,'') :- !, fail.

% cas question vs. faits

pge(QFoncteursA,QFoncteursA,QAttributsA,QAttributsA,'','0.0') :- !.


pge(QFoncteursA,QFoncteursB,QAttributsA,QAttributsB,'','0.2') :-
	qFoncteurplusgeneralouegal(QFoncteursA,QFoncteursB),
	attributsplusgenerauxouegaux(QAttributsA,QAttributsB), !.

pge(QFoncteursA,QFoncteursB,QAttributsA,QAttributsB,'','0.2') :-
	qFoncteurplusgeneral(QFoncteursA,QFoncteursB),
	attributsplusgenerauxouegaux(QAttributsB,QAttributsA), !.

pge(QFoncteursA,QFoncteursB,QAttributsA,QAttributsB,'','0.2') :-
	qFoncteurplusgeneralouegal(QFoncteursB,QFoncteursA),
	attributsplusgenerauxouegaux(QAttributsA,QAttributsB), !.

pge(QFoncteursA,QFoncteursB,QAttributsA,QAttributsB,'','0.3') :-
	qFoncteurplusgeneralouegal(QFoncteursB,QFoncteursA),
	attributsplusgenerauxouegaux(QAttributsB,QAttributsA), !.


% foncteur du littéral << foncteur du fait ET attributs du littéral << attributs du fait alors Faux 
pge(QFoncteursA,QFoncteursB,QAttributsA,QAttributsB,'litteral','1') :-
	dif(QFoncteursA,QFoncteursB),
	dif(QAttributsA,QAttributsB),
	qFoncteurplusgeneral(QFoncteursA,QFoncteursB),
	attributsplusgeneraux(QAttributsA,QAttributsB), !, fail.

% foncteur du littéral=foncteur du fait ET attributs du littéral << attributs du fait alors Vrai
pge(QFoncteursA,QFoncteursB,QAttributsA,QAttributsB,'litteral','2') :- 
	QFoncteursA=QFoncteursB,
	dif(QAttributsA,QAttributsB),
	attributsplusgeneraux(QAttributsA,QAttributsB), !.

% foncteur du littéral << foncteur du fait ET attributs du littéral = attributs du fait alors Faux
pge(QFoncteursA,QFoncteursB,QAttributsA,QAttributsB,'litteral','3') :-
	dif(QFoncteursA,QFoncteursB),
	QAttributsA=QAttributsB,
	qFoncteurplusgeneral(QFoncteursA,QFoncteursB), !, fail.

% foncteur du littéral >> foncteur du fait ET attributs du littéral = attributs du fait alors Vrai
pge(QFoncteursA,QFoncteursB,QAttributsA,QAttributsB,'litteral','4') :-
	dif(QFoncteursA,QFoncteursB), 
	QAttributsA=QAttributsB, 
	qFoncteurplusgeneral(QFoncteursB,QFoncteursA), !.

% foncteur du littéral = foncteur du fait ET attributs du littéral >> attributs du fait alors Faux
pge(QFoncteursA,QFoncteursB,QAttributsA,QAttributsB,'litteral','5') :-
	QFoncteursA=QFoncteursB,
	dif(QAttributsA,QAttributsB),
	attributsplusgeneraux(QAttributsB,QAttributsA), !, fail.

% foncteur du littéral >> foncteur du fait ET attributs du littéral >> attributs du fait alors Faux 
pge(QFoncteursA,QFoncteursB,QAttributsA,QAttributsB,'litteral','6') :-
	dif(QFoncteursA,QFoncteursB),
	dif(QAttributsA,QAttributsB),
	qFoncteurplusgeneral(QFoncteursB,QFoncteursA),
	attributsplusgeneraux(QAttributsB,QAttributsA), !, fail.

pge(QFoncteursA,QFoncteursB,QAttributsA,QAttributsB,'','8') :- !, fail.
pge(QFoncteursA,QFoncteursB,QAttributsA,QAttributsB,'litteral','7') :- !, fail.



% les quantificateurs du foncteur de A sont-ils plus généraux (ou égaux) que ceux de B ?

qFoncteurplusgeneralouegal(QFoncteursA,QFoncteursA) :- !.

qFoncteurplusgeneralouegal(QFoncteursA,QFoncteursB) :- 
	qFoncteurplusgeneral(QFoncteursA,QFoncteursB), !.

qFoncteurplusgeneral(QFoncteursA,QFoncteursB) :-
	QFoncteursA=[],
	dif(QFoncteursB,[]),
	pasfoncteurNC(QFoncteursB), !.

qFoncteurplusgeneral(QFoncteursA,QFoncteursB) :-
	dif(QFoncteursA,[]),
	subset2(QFoncteursA,QFoncteursB), !.	

qFoncteurplusgeneral(QFoncteursA,QFoncteursB) :- !, fail.


pasfoncteurNC([]) :- !.

pasfoncteurNC([H|T]) :-
	\+var(H),
	\+sub_string(H,_,_,_, "µµNC"),
	pasfoncteurNC(T).

pasfoncteurNC([H|T]) :-
	var(H), pasfoncteurNC(T).	


% les qualificateurs des attributs de A sont-ils plus généraux que ceux de B ?
% (les attributs de A sont supposés alignés avec ceux de B et en même nombre)

attributsplusgenerauxouegaux(A,A) :- !.
attributsplusgenerauxouegaux(A,B) :- 
	attributsplusgeneraux(A,B), !.

attributsplusgeneraux([],[]).
attributsplusgeneraux([H1|T1],[H2|T2]) :- 
	qAttributplusgeneral(H1,H2),
	attributsplusgeneraux(T1,T2).


% les qualificateurs d'un attribut Q1 sont-ils plus généraux que ceux de Q2 ?
qAttributplusgeneral(Q1,Q2) :- Q1=[], !.
qAttributplusgeneral(Q1,Q2) :- subset2(Q1,Q2), !.
qAttributplusgeneral(Q1,Q2) :- !, fail.

linguistique(A) :- functor(A,pour,_), !, fail.

linguistique(A) :- 
	functor(A,_,Arite),  
	Arite>0,
	arg(Arite,A,X),
	% not(var(X)), 
	X='l', !.

linguistique(not(A)) :- linguistique(A), !.

linguistique(A) :- !, fail.


selectpredicat(meta(_,_,_),_,_,_) :- !, fail.

selectpredicat(fs(_,_,_),_,_,_) :- !, fail.

%selectpredicat(A,A,_,_) :-  write('BUILT_IN:avant:A='), writeln(A), predicate_property(A,nodebug), writeln('BUILT_IN:après'), !.

selectpredicat(A,A,_,'litteral') :- clause(A,C), dif(C,true). 

selectpredicat(not(A),B,L1,L2) :- 
	duplicate_term(not(A),B), 
	functor(A,_,Arite),
	Arite>0,
	arg(Arite,A,'l'),
	J is Arite-4,
	K is Arite-3,
	L is Arite-2,
	M is Arite-1,
	nb_setarg2(J, A, X),
	nb_setarg2(K, A, Y), 
	nb_setarg2(L, A, Z),
	nb_setarg2(M, A, T),
	call(not(A)), 
	selectpred(not(A),L1,L2).

selectpredicat(A,B,L1,L2) :- 
	duplicate_term(A,B), 
	functor(A,F,Arite),
	Arite>0,
	arg(Arite,A,'l'),
	J is Arite-4,
	K is Arite-3,
	L is Arite-2,
	M is Arite-1,
	nb_setarg2(J, A, X),
	nb_setarg2(K, A, Y), 
	nb_setarg2(L, A, Z),
	nb_setarg2(M, A, T),
	dif(F,'dif_c_c'),
	(A;clause(A,_)),
	selectpred(A,L1,L2).

selectpred(A,'','') :- 
	clause(A,true), !.

selectpred(A,_,'litteral') :- 
	clause(A,true), !.

selectpred(A,'','litteral') :- 
	clause(A,C), dif(C,true), !.


% méta-interpréteur étendu aux prédicats « linguistiques », v3 (avec trace déductive), v4 (avec anti-bouclage)

% Cas particulier: pour(A,B) -> gestion de l'imbrication
prove(pour(A,B),Rep,_,_,_,History) :- pour(A,B), terme_chaine(B,Rep).

prove((A,B),_,L,TraceIn,TraceOut,History) :- prove(A,_,'litteral',TraceIn,_,History), prove(B,_,'litteral',TraceIn,_,History), flatten([TraceIn,[A],[B]],TraceOut), !. 
prove(meta(A,_,T2),A,_,TraceIn,TraceOut,History) :- meta(A,[],T2), flatten([T2,'=>',[A],TraceIn],TraceOut).

prove(A,A,_,TraceIn,TraceOut,History) :- predicate_property(A,built_in), !, A=true, flatten([TraceIn,[A]],TraceOut).
prove(A,A,_,TraceIn,TraceOut,History) :- predicate_property(A,built_in), !, dif(A,true), call(A), flatten([TraceIn,[A]],TraceOut).
prove(A,_,_,TraceIn,TraceOut,History) :- \+(linguistique(A)), clause(A,B), prove(B,_,_,TraceIn,T1,History), flatten([TraceIn,T1,['=>'],[B],['=>'],[A]],TraceOut).
prove(A,_,_,TraceIn,TraceOut,History) :- \+(linguistique(A)), A=true.
prove(A,_,_,TraceIn,TraceOut,History) :- \+(linguistique(A)), !, dif(A,true), call(A), flatten([TraceIn,[A]],TraceOut).

prove(A,Rep,L,TraceIn,TraceOut,History) :- linguistique(A), selectpredicat(A,Question,L,L2), provelinguistique(A,Question,Rep,L2,_,TraceIn,TraceOut,History).

provelinguistique(A,Question,A,'',_,TraceIn,TraceOut,History) :- clause(A,true), plusgeneralouegal(Question,A,'',Cas), dif(Cas,'0.2'), flatten([TraceIn,[A]],TraceOut).
provelinguistique(A,Question,A,'litteral',_,TraceIn,TraceOut,History) :-  plusgeneralouegal(A,Question,'litteral',_), \+member(A,History), clause(A,B),encapsuler(B,MetaB), prove(MetaB,_,'litteral',TraceIn,T1,[A|History]), flatten([TraceIn,T1,['=>'],[B],['=>'],[A]],TraceOut).
provelinguistique(A,Question,A,'',_,TraceIn,TraceOut,History) :- clause(A,true), !, plusgeneralouegal(Question,A,'','0.2'), flatten([TraceIn,[A]],TraceOut).
provelinguistique(A,Question,A,'',_,TraceIn,TraceOut,History) :- clause(A,true), !, plusgeneralouegal(A,Question,'',_), flatten([TraceIn,[A]],TraceOut).

provelinguistique(A,Question,A,'litteral',_,TraceIn,TraceOut,History) :- !, plusgeneralouegal(A,Question,'litteral',_), \+member(A,History), clause(A,B), prove(B,_,'litteral',TraceIn,T1,[A|History]), flatten([TraceIn,T1,['=>'],[B],['=>'],[A]],TraceOut). 
provelinguistique(A,Question,Rep,'litteral',_,TraceIn,TraceOut,History) :- dif(Question,A), !, plusgeneralouegal(Question,A,'litteral',_), \+member(A,History), clause(A,B), prove(B,Rep,'litteral',TraceIn,T1,[A|History]), flatten([TraceIn,T1,['=>'],[B],['=>'],[A]],TraceOut).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% eXaLog: Mapping des attributs de prédicats et littéraux 	         %%%%
% 					       Francis Frydman - 25/10/2022 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Prépositions de lieux
pl(['à', 'à_côté_de', 'à_gauche_de', 'à_droite_de', 'au-delà', 'au-dessous', 'au-dessus', 'à_travers', 'chez', 'contre', 'dans', 'en_dehors_de', 'en_face_de', 'hors', 'loin', 'sous', 'sur', 'vers', 'en', 'à_nord_de', 'à_sud_de']).
% Prépositions de moyen 
pm(['avec', 'à_le_aide_de','à_moyen_de', 'de', 'en', 'sans', 'par', 'à']).
% Prépositions de temps
pt(['à', 'après', 'avant', 'dans', 'depuis', 'dès', 'en', 'jusqu_à', 'pendant', 'le']).

%%%%% UTILITAIRES %%%%%

liste([X1|X2],X1,X2).

% contenu/2: version de subset excluant [].

contenu([],[]) :- !.

contenu([],B) :-
	dif(B,[]),
	!, fail.

contenu(A,B) :- 
	subset(A,B).

% conversion d'un terme en chaine, chaque élément séparé par un '£', chaque élément de liste séparé par un '$'

terme_chaine(Terme,Terme) :-
	functor(Terme,_,0), !.
	
terme_chaine(Terme,Chaine) :- 
	functor(Terme,Foncteur,Arite),
	Arite>0,
	arguments(Terme,1,[],Args),
	atomic_list_concat(Args,'$',ArgsL),
	caracteristiques(Terme,Prepositions,Etiquettes,QFoncteurs,QAttributs,Texte),
	flatten(Prepositions,P),
	atomic_list_concat(P,',',PrepositionsL), 
	flatten(Etiquettes,E),
	atomic_list_concat(E,',',EtiquettesL), 
	flatten(QFoncteurs,QF),
	atomic_list_concat(QF,',',QFoncteursL), 
	flatten(QAttributs,QA),
	atomic_list_concat(QA,',',QAttributsL),	
	atomic_list_concat([Foncteur,ArgsL,PrepositionsL,EtiquettesL,QFoncteursL,QAttributsL,Texte],'£',Chaine).

% réplique un terme N fois

repliquer_liste(X, N, L) :-
	length(L, N),
    	maplist(=(X), L).

% version d'intersection qui accepte une variable en premier attribut et renvoie le second attribut dans ce cas

intersect(L1,L2,L3) :-
	\+var(L1),
	intersection(L1,L2,L3), !.

intersect(L1,L2,L2) :- !.  

% version de subset qui accepte une variable en premier attribut et renvoie le second attribut dans ce cas

subset2(L1,L2) :-
	\+var(L1),
	subset(L1,L2), !.

subset2(L2,L2) :- !.  

% version de nb setarg avec controle de l'indice > 0

nb_setarg2(N,A,B) :-
	N > 0,
	nb_setarg(N,A,B), !.
	
nb_setarg2(N,A,B) :- !.


% failsafe: renvoie false si prédicat non déclaré

fs(P,T1,T2) :- 
	fs0(P),
	flatten([T1,[P]],T2).	

fs0(P) :-
	current_predicate(_,P), 
	P.

fs0(P) :- !, fail.  

%%%%%%%%%%%%%%%%%%%%%%%


% Fonction principale

mapping_question(Question,Fait,PQuestion,PFait,SQuestion,SFait,NewQuestion) :- 
	creer_question(Question,Fait,NewQuestion), 
	mapping(Question,Fait,PQuestion,PFait,SQuestion,SFait,1,1,NewQuestion), !.

mapping_question(Question,Question,PQuestion,PQuestion,SQuestion,SQuestion,Question) :- !.

% Si chaque liste de la liste de listes de prépositions de la question contient au moins une préposition de la liste des prépositions du fait
% alors on aligne les arguments de la question sur ceux du fait. Exemple: aller(Jean,_x1) -> aller(Jean,_,_x1,_)


mapping(Question,Fait,PQuestion,PFait,SQuestion,SFait,IndQuestion,IndFait,NewQuestion) :-
	 liste(PQuestion,HPQuestion,TPQuestion), !,
	 testemap(HPQuestion,PFait,SQuestion,SFait,IndQuestion,IndFait,X),
	 arg(IndQuestion,Question,Arg), 
	 setarg(X,NewQuestion,Arg), 
	 IndQuestion2 is IndQuestion+1, 
	 IndFait2 is IndFait+1, 
	 liste(PFait,_,TPFait), 
	 liste(SFait,_,TSFait), 
	 mapping(Question,Fait,TPQuestion,TPFait,SQuestion,TSFait,IndQuestion2,IndFait2,NewQuestion).

mapping(Question,Fait,PQuestion,PFait,SQuestion,SFait,IndQuestion,IndFait,NewQuestion) :- !.


% trouver quelle liste de préposition du fait est contenue dans PQuestion et dont le type syntaxique de l'attribut de la question dans SQuestion contient le type syntaxique de l'attribut du fait dans SFait lui correspondant dans ce mapping.


testemap(PQuestion,PFait,SQuestion,SFait,IndQuestion,IndFait,IndFait) :-  
	liste(PFait,HPFait,TPFait), 
	liste(SFait,HSFait,TSFait),
	contenu(HPFait,PQuestion), 
	nth1(IndQuestion,SQuestion,SEltQuestion), 
	((intersect(SEltQuestion,HSFait,X),X\==[]);var(SEltQuestion)), !.
	
testemap(PQuestion,PFait,SQuestion,SFait,IndQuestion,IndFait,Rep) :-
	liste(PFait,HPFait,TPFait), 
	liste(SFait,HSFait,TSFait),
	IndFait2 is IndFait+1,
	testemap(PQuestion,TPFait,SQuestion,TSFait,IndQuestion,IndFait2,Rep), !.
	
testemap(PQuestion,PFait,SQuestion,SFait,IndQuestion,IndFait,Rep) :- !, fail.

% créer un nouveau prédicat question de même arité que le fait (avec des variables anonymes)

creer_question(Question,Fait,NewQuestion) :- 
	functor(Question,FoncteurQuestion,AriteQuestion),
	functor(Fait,_,AriteFait),
	functor(NewQuestion,FoncteurQuestion,AriteFait).


%%%%%%%%%%%%%%%%%%%%%%%

% Format d'appel: mapping_question(Question,Fait,PQuestion,PFait,SQuestion,SFait,NewQuestion)
%
% Exemple1: Où va Jean?
% pl(PL), mapping_question(aller('Jean',_x1),aller('Jean','Paris','Rouen','train'),[[],PL],[[],[],['à'],['en']],[['NC/NPP'],['NC/NPP']],[['NC/NPP'],['NC/NPP'],['NC/NPP'],['NC']],NewQuestion).
%
% Exemple2: Comment Jean va-t-il à Paris?
% pm(PM), mapping_question(aller('Jean','Paris',_x1),aller('Jean','Paris','Rouen','train'),[[],['à'],PM],[[],[],['à'],['en']],[['NC/NPP'],['NC/NPP'],['NC']],[['NC/NPP'],['NC/NPP'],['NC/NPP'],['NC']],NewQuestion).

%%%%%%%%%%%%%%%%%%%%%%%


% appelle mapping_question avec tous les faits retournés par testefaits (et extraction des caractéristiques)

call_mapping(Question,PL,PM,PT,NewQuestion) :- 
	pl(PL), pm(PM), pt(PT),
	caracteristiques(Question,PQuestion,SQuestion,QFoncteurs,QAttributs,_),
	testefaits(Question,Fait), 
	caracteristiques(Fait,PFait,SFait,_,QAttributsFait,_),
	mapping_question(Question,Fait,PQuestion,PFait,SQuestion,SFait,NewQuestion),
	functor(NewQuestion,_,AriteQ),
	nb_setarg2(AriteQ, NewQuestion,'l'),
	J is AriteQ-5,
	K is AriteQ-4,
	L is AriteQ-3,
	M is AriteQ-2,
	nb_setarg2(J, NewQuestion, PFait),
	nb_setarg2(K, NewQuestion, SFait),
	nb_setarg2(L, NewQuestion, QFoncteurs), 
	length(QAttributsFait,LAttrFait),
	length(QAttributs,LAttrQuestion), 
	ajuste_qualificateurs(LAttrFait,LAttrQuestion,QAttributs,QAttributsFait,NewQAttributs),
	nb_setarg2(M, NewQuestion, NewQAttributs).

% ajuste le nommbre de qualificateurs de la question sur celui d'un fait
ajuste_qualificateurs(LAttrFait,LAttrFait,QAttributsQuestion,QAttributsFait,QAttributsQuestion) :- !.
	
ajuste_qualificateurs(LAttrFait,LAttrQuestion,QAttributsQuestion,QAttributsFait,NewQAttributs) :- 
	LAttrQuestion>LAttrFait, !, fail.

ajuste_qualificateurs(LAttrFait,LAttrQuestion,QAttributsQuestion,QAttributsFait,NewQAttributs) :- 
	LAttrQuestion<LAttrFait,
	Difference is LAttrFait-LAttrQuestion,
	repliquer_liste([], Difference, L),
	append(QAttributsQuestion,L,NewQAttributs),!.
	

% liste tous les faits (et têtes de règles) de même foncteur que A et d'arité = Arité(A) + I, avec 0 <= I <= 4
listefaits(A,I,B) :- 
	functor(A,F,Arite),
	NewArite is Arite+I,
	functor(B,F,NewArite),
	nb_setarg2(NewArite, B, 'l'),
	clause(B,_).

testefaits(A,B) :-
	(listefaits(A,0,B);
	listefaits(A,1,B);
	listefaits(A,2,B);
	listefaits(A,3,B);
	listefaits(A,4,B)),
	arguments(A,1,[],ArgsA),
	arguments(B,1,[],ArgsB),
 	(intersect(ArgsA,ArgsB,ArgsA);intersect(ArgsB,ArgsA,ArgsB);ArgsB=[]).

% appel principal 

exalog(not(Question),PL,PM,PT,Rep2,TraceIn,TraceOut) :- 
	linguistique(Question), !,
	prove(not(Question),Rep,'',TraceIn,TraceOut2,[]),
	term_string(Rep,Rep2),
	term_string(TraceOut2,TraceOut),
	writeln('-->0Prouvé!').

exalog(Question,PL,PM,PT,Rep2,TraceIn,TraceOut) :- 
	linguistique(Question), 
	call_mapping(Question,PL,PM,PT,NewQuestion),
	prove(NewQuestion,Rep,'',TraceIn,TraceOut2,[]), 
	term_string(Rep,Rep2),
	term_string(TraceOut2,TraceOut),
	writeln('-->1Prouvé!').


exalog(Question,PL,PM,PT,Rep2,TraceIn,TraceOut) :- 
	linguistique(Question), !, 
	encapsuler(Question,MetaQuestion),  
	prove(MetaQuestion,Rep,'',TraceIn,TraceOut2,[]),
	term_string(Rep,Rep2),
	term_string(TraceOut2,TraceOut),
	writeln('-->1-métaProuvé!').

exalog(Question,_,_,_,Rep,TraceIn,TraceOut) :- 
	\+(linguistique(Question)), !, 
	prove(Question,Rep,'',TraceIn,TraceOut2,[]), 
	term_string(TraceOut2,TraceOut),
	writeln('-->2Prouvé!').


%%%%%% INTERFACE D'APPEL DEPUIS eXa AVEC SORTIE FICHIER output.txt %%%%%%%
% ligne de commande : swipl.exe -q -l EXALOG.pl -g a --no-pce --no-signals --no-debug --no-threads --no-pack
%
% a :- 
%	protocol("output.txt"),
%	% On remplace ci-dessous le prédicat par le but à prouver
%	bagof(_x1,exalog(aimer(jean,_x1,[],[],[],[[],[]],'l'),PL,PM,PT,Rep),_x1),
%	write('_x1='), writeln(_x1), !.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% EXEMPLES D'EXECUTION %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% quantificateurs généralisés et qualificateurs %%%%%%%%%%%
% Exemple 1 :

/*
est_un('Jean','esthete').
etre('tableau','beau',[],[],[],[[],[]],'l').
%aimer(X,Y,[],[],[],[[],[]],'l') :- est_un(X,'esthete'), etre(Y,'beau',[],[],['tres'],[[],[]],'l').
aimer(X,Y,[],[],[],[[],[]],'l') :- est_un(X,'esthete'), etre(Y,'beau',[],[],[],[[],[]],'l').

% Q1: exalog(aimer('Jean',_x1,[],[],[],[[],[]],'l'),PL,PM,PT,Rep).
% Q2: exalog(aimer('Jean','tableau',[],[],[],[[],[]],'l'),PL,PM,PT,Rep).
*/

% Exemple 2 :

/*
aimer('Jean','pommes',[],[],['beaucoup'],[[],[]],'l').
acheter('Jean','pommes',[],[],[],[[],[]],'l') :- aimer('Jean','pommes',[],[],[],[[],[]],'l').

% Q: exalog(acheter('Jean','pommes',[],[],[],[[],[]],'l'),PL,PM,PT,Rep).
*/

% Exemple 3 :

/*
aimer('Jean','pommes',[],[],[],[[],[]],'l').
acheter('Jean','pommes',[],[],[quelques],[[],[]],'l') :- aimer('Jean','pommes',[],[],[],[[],[]],'l').

% Q1: exalog(acheter('Jean','pommes',[],[],[quelques],[[],[petites]],'l'),PL,PM,PT,Rep).
% Q2: exalog(acheter('Jean','pommes',[],[],[beaucoup],[[],[]],'l'),PL,PM,PT,Rep).
*/

% Exemple 4 :

/*
aimer(jean,poires,[],[],[],[[],[]],'l').
aimer(jean,tableaux,[],[],['un peu'],[[],[]],'l').
aimer(jean,pommes,[],[],[],[[],[]],'l'). 

% Q: exalog(aimer(jean,_x1,[],[],[],[[],[]],'l'),PL,PM,PT,Rep).
*/

%%%%%% Mapping des attributs de prédicats et littéraux %%%%%

/*
aimer('Jean','poires',[],[],[],[[],[]],'l').
aller('Jean','Paris','Rouen','train',[[],[],['à'],['en']],[['NC/NPP'],['NC/NPP'],['NC/NPP'],['NC']],[],[[],[],[],[]],'l').
aller('Jean','Toulouse','Marseille','voiture',[[],[],['à'],['en']],[['NC/NPP'],['NC/NPP'],['NC/NPP'],['NC']],[],[[],[],[],[]],'l').
aller('Jean','Paris','Lyon','voiture',[[],[],['à'],['en']],[['NC/NPP'],['NC/NPP'],['NC/NPP'],['NC']],[],[[],[],[],[]],'l').
aller('Paul','Lyon','Montpellier',[[],[],['à']],[['NC/NPP'],['NC/NPP'],['NC/NPP']],[],[[],[],[]],'l').
aller('Jean','Lyon','Montpellier',[[],[],['à']],[['NC/NPP'],['NC/NPP'],['NC/NPP']],[],[[],[],[]],'l').
*/

% exalog(aller('Jean',_x1,[[],PL],[['NC/NPP'],['NC/NPP']],[],[[],[]],'l'),PL,PM,PT,Rep).
% exalog(aller('Paul',_x1,[[],PL],[['NC/NPP'],['NC/NPP']],[],[[],[]],'l'),PL,PM,PT,Rep).
% exalog(aller('Jean','Rouen',_x1,[[],['à'],PM],[['NC/NPP'],['NC/NPP'],['NC']],[],[[],[],[]],'l'),PL,PM,PT,Rep).
% exalog(aimer('Jean',_x1,[],[],[],[[],[]],'l'),PL,PM,PT,Rep).
%
% exalog(aller('Jean','Paris','Rouen','train',[[],[],['à'],['en']],[['NC/NPP'],['NC/NPP'],['NC/NPP'],['NC']],[],[[],[],[],[]],'l'),PL,PM,PT,Rep).
% exalog(aller('Jean','Paris','Rouen',_x1,[[],[],['à'],['en']],[['NC/NPP'],['NC/NPP'],['NC/NPP'],['NC']],[],[[],[],[],[]],'l'),PL,PM,PT,Rep).
% exalog(aller('Jean','Paris','Rouen','voiture',[[],[],['à'],['en']],[['NC/NPP'],['NC/NPP'],['NC/NPP'],['NC']],[],[[],[]],'l'),PL,PM,PT,Rep).
% exalog(aller('Jean','Lyon',[[],[à]],[['NC/NPP'],['NC/NPP']],[],[[],[]],'l'),PL,PM,PT,Rep).

