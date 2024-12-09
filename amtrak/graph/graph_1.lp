% #include "test_envs/test_env_1/test_env_1.lp".
#include "test_envs/test_env_2/test_env_2.lp".
#include "track_option.lp".

% Build nodes on every entry and exit point in cell


node((X,Y),D) :- cell((X,Y),Track), Track>0, option((X,Y),(_,_,D)). 


% edge((X1,Y),v,(X2,Y)) :- node((X1,Y),D), node((X2,Y),D), |X2-X1|=1, ns(D).


edge((X1,Y),v,(X2,Y)) :- node((X1,Y),D), node((X2,Y),D), |X2-X1|=1, ns(D).
edge((X,Y1),h,(X,Y2)) :- node((X,Y1),D), node((X,Y2),D), |Y2-Y1|=1, ew(D).


% edge((X,Y),D,(X,Y)) :- turn(Track), option((X,Y),n,_,s)
% edge((X,Y),D,(X,Y)) :- turn(Track), option((X,Y),s,_,n)

% edge((X,Y),D,(X,Y)) :- turn(Track), option((X,Y),n,_,s)


% #show option/2.
% #show node/2.
% #show link/2.
#show edge/3.
% #show dir/1.
% #show turn/1.