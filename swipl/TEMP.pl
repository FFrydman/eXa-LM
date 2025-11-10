:-style_check(-discontiguous).
:-style_check(-singleton).
:- use_module('EXALOG').
:- dynamic(estun/8).

:- table estun/8.

:- include('LIBRARY.pl').

estun('numpus','wumpus',[[],[]],[['NC'],['NC']],[],[[],[]],'chaque/chaque/DET numpus estun/MHYPONYME wumpus','l').
estun('wumpus','tumpus',[[],[]],[['NC'],['NC']],[],[[],[]],'chaque/chaque/DET numpus estun/MHYPONYME wumpus','l').
estun('tumpus','dumpus',[[],[]],[['NC'],['NC']],[],[[],[]],'chaque/chaque/DET tumpus estun/MHYPONYME dumpus','l').
estun('dumpus','yumpus',[[],[]],[['NC'],['NC']],[],[[],[]],'chaque/chaque/DET dumpus estun/MHYPONYME yumpus','l').
estun('yumpus','zumpus',[[],[]],[['NC'],['NC']],[],[[],[]],'chaque/chaque/DET yumpus estun/MHYPONYME zumpus','l').
estun('zumpus','impus',[[],[]],[['NC'],['NC']],[],[[],[]],'chaque/chaque/DET yumpus estun/MHYPONYME zumpus','l').
estun('impus','rumpus',[[],[]],[['NC'],['NC']],[],[[],[]],'chaque/chaque/DET rumpus estun/MHYPONYME vumpus','l').
estun('rumpus','vumpus',[[],[]],[['NC'],['NC']],[],[[],[]],'chaque/chaque/DET rumpus estun/MHYPONYME vumpus','l').
estun('Sam','dumpus',[[],[]],[['NC/NPP'],['NC']],[],[[],[]],'Sam/NPP estun/MHYPONYME dumpus','l').
not(être('numpus','opaque',[[],[]],[['NC'],['ADJ']],[],[[],[]],'chaque/chaque/DET numpus ne/ne/ADV est/être/V pas/pas|pas/ADV-* opaque/opaque/ADJ','l')).
être('wumpus','fougueux',[[],[]],[['NC'],['ADJ']],[],[[],[]],'chaque/chaque/DET wumpus est/être/V fougueux/fougueux/ADJ','l').
être('tumpus','fruité',[[],[]],[['NC'],['ADJ']],[],[[],[]],'les tumpus sont/être/V fruité/fruité/ADJ','l').
être('dumpus','bois',[[],[en]],[['NC'],['NC']],[],[[],[]],'chaque/chaque/DET dumpus est/être/V en/cll/CLO|en/P bois/boire/V|bois|boire/VIMP','l').
être('yumpus','bleu',[[],[]],[['NC'],['ADJ']],[],[[],[]],'les yumpus sont/être/V bleus/bleu|bleu/ADJ-*','l').
épicer('zumpus',[[]],[['NC']],[],[[chaque]],'chaque/chaque/DET zumpus est/être/V épicé/épicer/ADJ|épicer/VPP-*','l').
not(être('impus','gentil',[[],[]],[['NC'],['ADJ']],[],[[],[]],'chaque/chaque/DET impus ne/ne/ADV est/être/V pas/pas|pas/ADV-* gentil/gentil/ADJ|gentil-*','l')).
not(être('jompus','terne',[[],[]],[['NC'],['ADJ']],[],[[],[]],'les jompus ne/ne/ADV sont/être/V pas/pas|pas/ADV-* terne/terne/ADJ','l')).
être('rumpus','terne',[[],[]],[['NC'],['ADJ']],[],[[],[]],'chaque/chaque/DET rumpus est/être/V terne/terne/ADJ','l').

a :-
setup_call_cleanup(
open('C:\\Users\\ffff_\\source\\repos\\WindowsApp1\\bin\\x64\\Release\\Installable pour article eXa\\swipl\\output.txt', write, Out),
forall((exalog(être('Sam','terne',[[],[]],[['NC/NPP'],['ADJ']],[],[[],[]],_,'l'),PL,PM,PT,Rep,[],Trace)),
csv_write_stream(Out, [row('Sam','terne',Rep), row('TRACE=',Trace)], [])),
close(Out)).
