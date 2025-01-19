% #include "test_envs/test_env_1/test_env_1.lp".
#include "test_envs/test_env_2/test_env_2.lp".
#include "track_option.lp".

% Build nodes on every cell %

% every cell is its own node
node((X,Y)) :- cell((X,Y),Track).

% connect nodes with edges, retain necessary action to traverse 
edge((X1,Y),A,(X2,Y)) :- option((X1,Y),(_,A,n)), option((X2,Y),(n,_,_)), X2=X1-1.
edge((X1,Y),A,(X2,Y)) :- option((X1,Y),(_,A,s)), option((X2,Y),(s,_,_)), X2=X1+1.

edge((X,Y1),A,(X,Y2)) :- option((X,Y1),(_,A,e)), option((X,Y2),(e,_,_)), Y2=Y1+1.
edge((X,Y1),A,(X,Y2)) :- option((X,Y1),(_,A,w)), option((X,Y2),(w,_,_)), Y2=Y1-1.



#show edge/3.


% #show option/2.



% unit((X,Y),D) :- cell((X,Y),Track), Track>0, option((X,Y),(_,_,D)). 

% node((X,Y),IN,OUT) :- option((X,Y),(IN,_,OUT)), cell((X,Y),Track), turn(Track). 

% % Case 1 : edges leaving nodes
% edge((X1,Y),(X2,Y),0) :- node((X1,Y),_,D2), option((X2,Y),(D2,_,_)), |X2-X1|=1, not node((X2,Y),_,_).
% edge((X,Y1),(X,Y2),0) :- node((X,Y1),_,D2), option((X,Y2),(D2,_,_)), |Y2-Y1|=1, not node((X,Y2),_,_).

% visited_cell(X,Y) :- edge(_,(X,Y),_), not node((X,Y),_,_).

% % Case 2 : Edges to edges
% edge((X2,Y),(X3,Y),C2) :- not node((X2,Y),_,_), not node((X3,Y),_,_),
%     option((X2,Y),(_,_,D)), option((X3,Y),(D,_,_)),
%     |X2-X3|=1,
%     edge(CELL,(X2,Y),C), 
%     CELL!=(X3,Y),
%     C2=C+1,
%     not visited_cell(X3,Y).


% edge((X,Y2),(X,Y3),C2) :- not node((X,Y2),_,_), not node((X,Y3),_,_),
%     option((X,Y2),(_,_,D)), option((X,Y3),(D,_,_)),
%     |Y2-Y3|=1,
%     edge(CELL,(X,Y2),C), 
%     CELL!=(X,Y3),
%     C2=C+1,
%     not visited_cell(X,Y3).


% need some kind of visited atom?

% edge((X,Y1),(X,Y2),0) :- node((X,Y1),_,D2), option((X,Y2),(D2,_,_)), |Y2-Y1|=1, not node((X,Y2),_,_).


% Case 3 : Edges to nodes
% edge((X2,Y),(X3,Y),C2) :- not node((X2,Y),_,_), node((X3,Y),_,_),
%     option((X2,Y),(_,_,D)), option((X3,Y),(D,_,_)),
%     |X2-X3|=1,
%     edge(CELL,(X2,Y),C), 
%     CELL!=(X3,Y),
%     C2=C+1,
%     not visited_cell(X3,Y).

% Case 4 : Nodes to nodes


% edge((X1,Y),v,(X2,Y)) :- node((X1,Y),D), node((X2,Y),D), |X2-X1|=1, ns(D).
% edge((X1,Y),v,(X2,Y)) :- node((X1,Y),D), node((X2,Y),D), |X2-X1|=1, ns(D).
% edge((X,Y1),h,(X,Y2)) :- node((X,Y1),D), node((X,Y2),D), |Y2-Y1|=1, ew(D).

% edge((X,Y),,(X,Y)) :- node((X,Y),D2), node((X,Y,D2))





% edge((X,Y),D,(X,Y)) :- turn(Track), option((X,Y),n,_,s)
% edge((X,Y),D,(X,Y)) :- turn(Track), option((X,Y),s,_,n)

% edge((X,Y),D,(X,Y)) :- turn(Track), option((X,Y),n,_,s)


% #show option/2.
% #show node/3.
% #show edge/3.
% #show visited_cell/2.
% #show dir/1.
% #show turn/1.