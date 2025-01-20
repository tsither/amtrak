
% #include "test_envs/test_env_1/test_env_1.lp".
#include "test_envs/test_env_2/test_env_2.lp".
#include "track_option.lp".



node((X,Y)) :- cell((X,Y),Track), turn(Track). 

link((X1,Y),(X2,Y)) :- option((X1,Y),(_,_,s)), option((X2,Y),(s,_,_)), X2 = X1 + 1.
link((X,Y1),(X,Y2)) :- option((X,Y1),(_,_,e)), option((X,Y2),(e,_,_)), Y2 = Y1 + 1.
link((X,Y1),(X,Y2)) :- option((X,Y1),(_,_,w)), option((X,Y2),(w,_,_)), Y2 = Y1 - 1.
link((X1,Y),(X2,Y)) :- option((X1,Y),(_,_,n)), option((X2,Y),(n,_,_)), X2 = X1 - 1.


path_step(A, B, 1) :- 
    link(A, B), 
    node(A).

path_step(A, C, L) :-
    path_step(A,B,L1),
    link(B,C),
    not visited(A,C),
    L=L1+1.

% Mark visited cells to prevent cycles
visited(A, B) :- path_step(A, B, _).

path(A, B, L) :-
    node(A),
    node(B),
    path_step(A, B, L),
    A != B.

% #show node/2.
% #show link/2.
#show path_step/3.
#show path/3.
% #show visited/2.
% #show option/2.

