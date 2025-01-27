
% #include "test_envs/test_env_1/test_env_1.lp".
#include "test_envs/test_env_2/test_env_2.lp".
#include "track_option.lp".

cell_count(C) :- C = #count{ XY: cell((XY), Track), Track != 0}.
node((X,Y)) :- cell((X,Y),Track), node_track(Track). 

link((X1,Y),(X2,Y)) :- option((X1,Y),(_,_,s)), option((X2,Y),(s,_,_)), X2 = X1 + 1.
link((X,Y1),(X,Y2)) :- option((X,Y1),(_,_,e)), option((X,Y2),(e,_,_)), Y2 = Y1 + 1.
link((X,Y1),(X,Y2)) :- option((X,Y1),(_,_,w)), option((X,Y2),(w,_,_)), Y2 = Y1 - 1.
link((X1,Y),(X2,Y)) :- option((X1,Y),(_,_,n)), option((X2,Y),(n,_,_)), X2 = X1 - 1.


path_step(A, A, B, 1) :- 
    link(A, B), 
    node(A).

<<<<<<< HEAD
path_step(A, C, L) :-
    path_step(A,B,L1),
    link(B,C),
    not visited(A,C),
    L=L1+1.

visited(A, B) :- path_step(A, B, _).
=======
% N is starting node, A, B are the cells in the path at each step
path_step(N, B, C, L) :-
    link(B, C),
    path_step(N, A, B, L1),
    not path_step(N, C, B, _),
    not node(B),
    L=L1+1,
    L <= CC,
    cell_count(CC).
>>>>>>> 66590ea326691b797f3dbd7d22c95517309abe8b

path(A, B, L) :-
    path_step(A, _, B, L),
    node(A),
    node(B).

% #show node/1.
% #show link/2.
% #show cell_count/1.
% #show path_step/4.
#show path/3.
% #show visited/2.
% #show option/2.

