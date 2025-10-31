%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% eXaMeta : métarègles et métafaits d'ordre 2 %
% 	           Francis Frydman 25/04/2023     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- discontiguous meta/3.

meta([],T,T) :- !.

% Second ordre, avec foncteur connu
meta([H|T],T1,T2) :- 
	\+var(H),
	length(T,Arite),
	functor(Meta,H,Arite), 
	liste_args(T,1,Meta),
	fs0(Meta),
	flatten([T1,[Meta]],T2).


% Second ordre, avec foncteur inconnu
meta([H|T],_,_) :- 
	var(H),
	find_functor(H,T).


liste_args([],_,P) :- !.

liste_args([H|T],Rang,P) :-
	setarg(Rang,P,H),
	Rang2 is Rang+1,
	liste_args(T,Rang2,P).
	
find_functor(Functor, Args) :-
	length(Args,Len),
	current_functor(Functor,Len),
	Functor \= ':', 
	Term =.. [Functor|Args], 
	\+ predicate_property(Term,built_in),
	clause(Term,true).


% Encapsulation de prédicats
encapsuler(P,M) :-
	P =.. L,	
	functor(M,meta,3),
	liste_args([L,T1,T2],1,M), !.

	
	 	
