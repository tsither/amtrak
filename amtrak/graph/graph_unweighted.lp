% #include "test_envs/test_env_1/test_env_1.lp".
#include "test_envs/test_env_2/test_env_2.lp".
#include "track_option.lp".

%%%%% Build nodes on every cell %%%%%

% every cell is its own node
node((X,Y)) :- cell((X,Y),Track).

% connect nodes with edges, retain necessary action to traverse 
edge((X1,Y),A,(X2,Y)) :- option((X1,Y),(_,A,n)), option((X2,Y),(n,_,_)), X2=X1-1.
edge((X1,Y),A,(X2,Y)) :- option((X1,Y),(_,A,s)), option((X2,Y),(s,_,_)), X2=X1+1.

edge((X,Y1),A,(X,Y2)) :- option((X,Y1),(_,A,e)), option((X,Y2),(e,_,_)), Y2=Y1+1.
edge((X,Y1),A,(X,Y2)) :- option((X,Y1),(_,A,w)), option((X,Y2),(w,_,_)), Y2=Y1-1.

% #show edge/3.


