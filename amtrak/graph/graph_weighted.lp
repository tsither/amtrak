
% #include "test_envs/test_env_1/test_env_1.lp".
#include "test_envs/test_env_2/test_env_2.lp".
#include "track_option.lp".


node(X,Y) :- cell((X,Y),Track), turn(Track). 

% Leaving nodes
link((X1,Y),(X2,Y),0) :- option((X1,Y),(_,_,s)), option((X2,Y),(s,_,_)), X2 = X1 + 1, node(X1,Y).
link((X,Y1),(X,Y2),0) :- option((X,Y1),(_,_,e)), option((X,Y2),(e,_,_)), Y2 = Y1 + 1, node(X,Y1).
link((X,Y1),(X,Y2),0) :- option((X,Y1),(_,_,w)), option((X,Y2),(w,_,_)), Y2 = Y1 - 1, node(X,Y1).
link((X1,Y),(X2,Y),0) :- option((X1,Y),(_,_,n)), option((X2,Y),(n,_,_)), X2 = X1 - 1, node(X1,Y).

% visited_cell(X,Y) :- link(_,(X,Y),_).

% case 1: Edge to Edge
link((X1,Y1),(X2,Y2),C2) :- 
    option((X1,Y1),(_,_,D)), 
    option((X2,Y2),(D,_,_)), 
    link((_,_),(X1,Y1),C1), 
    |(X1+Y1) - (X2+Y2)|=1,
    not node(X2,Y2),
    C2=C1+1.

% Case 2: Ends on node
% link((X,Y2),(X,Y3),C2) :- option((X,Y2),(_,_,D)), option((X,Y3),(D,_,_)), link((_,_),(X,Y2),C1), 
%     Y3 = Y2 + 1, C2=C1+1, C1>1,
%     D=e,
%     node(X,Y3). 


% link((X2,Y),(X3,Y),C2) :- option((X2,Y),(_,_,D)), option((X3,Y),(D,_,_)), link((_,_),(X2,Y),C1), 
%     X3 = X2 + 1, C2=C1+1, C1>1,
%     D=s,
%     node(X3,Y). 

% link((X,Y2),(X,Y3),C2) :- option((X,Y2),(_,_,D)), option((X,Y3),(D,_,_)), link((_,_),(X,Y2),C1), 
%     Y3 = Y2 - 1, C2=C1+1, C1>1,
%     D=w,
%     node(X,Y3).

% #show node/2.
#show link/3.
#show visited_cell/2.
% #show option/2.