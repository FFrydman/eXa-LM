:-style_check(-discontiguous).
:-style_check(-singleton).
:- use_module('EXALOG').
:- dynamic(estun/8).

:- table estun/8.

:- include('LIBRARY.pl').

estun('Ailton','joueur_de_football',[[],[]],[['NC/NPP'],['NC']],[],[[],[]],'Ailton/NPP Silva/Silva/NPP est/être/V communément/communément/ADV connu/connaître/ADJ|connaître/VPP-* sous/sous/P|sou le nom/nom de Ailton/Ailton/NPP','l').
estun('Ailton','footballeur',[[],[]],[['NC/NPP'],['NC']],[],[[],[brésilien]],'Ailton/NPP estun/MHYPONYME footballeur/footballeur brésilien/brésilien|brésilien/ADJ-*','l').
estun('Nautico','club_de_football',[[],[]],[['NC/NPP'],['NC']],[],[[],[]],'Nautico/NPP estun/MHYPONYME club/club de football/football','l').
estun('Braga','club_de_football',[[],[]],[['NC/NPP'],['NC']],[],[[],[]],'Braga/NPP estun/MHYPONYME club/club de football/football','l').
estun('Fluminense','club_de_football',[[],[]],[['NC/NPP'],['NC']],[],[[],[]],'Fluminense/NPP estun/MHYPONYME club/club de football/football','l').
naître('Ailton_Silva',1995,[[],[en]],[['NC/NPP'],['NUM']],[],[[],[]],'Ailton/NPP Silva/Silva/NPP est/être/V né/naître/VPP en/cll/CLO|en/P 1995/1995/NUM','l').
être('Ailton_Silva','connaître',[[],[sous]],[['NC/NPP'],['ADJ']],['communément'],[[],[]],'Ailton/NPP Silva/Silva/NPP est/être/V communément/communément/ADV connu/connaître/ADJ|connaître/VPP-* sous/sous/P|sou le nom/nom de Ailton/Ailton/NPP','l').
être('Ailton_Silva','nom_de_Ailton',[[],[sous]],[['NC/NPP'],['NC']],['communément'],[[],[]],'Ailton/NPP Silva/Silva/NPP est/être/V communément/communément/ADV connu/connaître/ADJ|connaître/VPP-* sous/sous/P|sou le nom/nom de Ailton/Ailton/NPP','l').
prêter('Ailton','Braga',[[],[à]],[['NC/NPP'],['NC/NPP']],[],[[],[]],'Ailton/NPP a/avoir/V été/été|être/VPP prêté/prêter/VPP|prêter/ADJ|prêté à/à/P Braga/Braga/NPP','l').
jouer('Ailton','Nautico',[[],[pour]],[['NC/NPP'],['NC/NPP']],[],[[],[]],'Ailton/NPP joue/joue|jouer/VS|jouer/V pour/pour/P Nautico/Nautico/NPP','l').

a :-
setup_call_cleanup(
open('C:\\Users\\ffff_\\source\\repos\\WindowsApp1\\bin\\x64\\Release\\Installable pour article eXa\\swipl\\output.txt', write, Out),
forall((exalog(prêter('Ailton','club_de_football',[[],[à]],[['NC/NPP'],['NC']],[],[_,[]],_,'l'),PL,PM,PT,Rep,[],Trace)),
csv_write_stream(Out, [row('Ailton','club_de_football',Rep), row('TRACE=',Trace)], [])),
close(Out)).
