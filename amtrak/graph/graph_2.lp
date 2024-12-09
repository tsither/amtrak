% #include "test_envs/test_env_1/test_env_1.lp".
#include "test_envs/test_env_2/test_env_2.lp".
#include "track_option.lp".


node(X,Y) :- cell((X,Y),Track), turn(Track). 

link((X1,Y),(X2,Y)) :- option((X1,Y),(_,_,s)), option((X2,Y),(s,_,_)), X2 = X1 + 1.
link((X2,Y),(X1,Y)) :- link((X1,Y),(X2,Y)).

% link((X1,Y),(X2,Y)) :- option((X1,Y),(_,_,n)), option((X2,Y),(n,_,_)), X2 = X1 - 1.

link((X,Y1),(X,Y2)) :- option((X,Y1),(_,_,e)), option((X,Y2),(e,_,_)), Y2 = Y1 + 1.
link((X,Y2),(X,Y1)) :- link((X,Y1),(X,Y2)).

path((X_start, Y_start), (X_end, Y_end),1) :- link((X_start, Y_start), (X_end, Y_end)), node(X_start,Y_start), node(X_end,Y_end).


% path((X_start, Y_start), (X_end, Y_end), D) :-
%     link((X_start, Y_start), (X_intermediate, Y_intermediate)),
%     path((X_intermediate, Y_intermediate), (X_end, Y_end), D1),
%     D = D1 + 1.


% path((X_start, Y_start), (X_end, Y_end)) :-
%     link((X_start, Y_start), (X_intermediate, Y_intermediate)),
%     link((X_intermediate, Y_intermediate), (X_end, Y_end)),
%     node(X_start,Y_start), node(X_end,Y_end), X_start != X_end.


% edge((X1,Y1),(X2,Y2),D) :- path((X1, Y1), (X2, Y2)), D = #count{X: link(X)}.


% % #show link/2.
% #show path/2.
% #show edge/3.



% path((X_start, Y_start), (X_end, Y_end)) :-
%     link((X_start, Y_start), (X_intermediate, Y_intermediate)),
%     link((X_intermediate, Y_intermediate), (X_end, Y_end)),
%     node(X_start,Y_start), node(X_end,Y_end).

