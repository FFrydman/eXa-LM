nbreglessynonymie(2).

nbsorties(_).
liste([_x1|_x2],_x1,_x2) :- nbsorties(2).


synonyme_syntaxique(_x1,_x2,N) :- synonyme_syntaxique_(_x1,X,[],N), atomic_list_concat(X,',_,',Y), atomic_list_concat(_x2,',',Y).

% x est différent de y  est synonyme de dif ( x,y )
c1(['est'|_x2],_x2).
c2(['différent'|_x2],_x2).
c3(['de'|_x2],_x2).
c4(['$dif'|_x2],_x2).
synonyme_syntaxique_(_x1,_x0,_x3,5) :- sousliste(_x1,5,[],X), liste(X,_x4,_x5), liste(_x6,_x4,_x7), c1(_x5,_x8), c2(_x8,_x9), c3(_x9,_x7), c4(_x2,_x6), flatten(_x2,_x0).
% la somme de x et y est z  est synonyme de plus ( x,y,z )
c1(['la'|_x2],_x2).
c2(['somme'|_x2],_x2).
c3(['de'|_x2],_x2).
c4(['et'|_x2],_x2).
c5(['est'|_x2],_x2).
c6(['$plus'|_x2],_x2).
synonyme_syntaxique_(_x1,_x0,_x3) :- c1(_x1,_x4), c2(_x4,_x5), c3(_x5,_x6), liste(_x6,_x7,_x8), liste(_x9,_x7,_x10), liste(_x10,_x11,_x12), liste(_x13,_x11,_x14), c4(_x8,_x13), c5(_x14,_x12), c6(_x2,_x9), flatten(_x2,_x0).

% relation0x est différent de y  est synonyme de dif ( x,y )
c1(['relation0x'|_x2],_x2).
c2(['est'|_x2],_x2).
c3(['différent'|_x2],_x2).
c4(['de'|_x2],_x2).
c5(['$dif'|_x2],_x2).
c6(['x'|_x2],_x2).
synonyme_syntaxique_(_x1,_x2,_x3) :- c1(_x1,_x4), c2(_x4,_x5), c3(_x5,_x6), c4(_x6,_x7), c5(_x2,_x8), c6(_x8,_x7), synonyme_syntaxique_(_x1,_x2,_x3).
