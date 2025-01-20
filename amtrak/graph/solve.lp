% #include "test_envs/test_env_1/test_env_1.lp".
% #include "test_envs/test_env_2/test_env_2.lp".
% #include "track_option.lp".
#include "graph_unweighted.lp".



time(T) :- T=0..ET, end(_,_,ET).

% at time 0 trains should be found at their starting position
at(train(ID),(X,Y),Dep,Dir) :- time(Dep), start(ID,(X,Y),Dep,Dir).

% add wait actions before and after trains' start and end times
action(train(ID),wait,T) :- T < ST, start(ID,_,ST,_), time(T).
action(train(ID),wait,T) :- T > ET, end(ID,_,ET), time(T).

{ action(train(ID),M,T+1): option((X,Y),(D,M,_)) } = 1 :-
    at(train(ID),(X,Y),T,D), T < ET, end(ID,_,ET), time(T+1).



% Graph density %
num_edges(D) :- D = #count { X,Y,Z : edge(X,Y,Z) }.
num_nodes(N) :- N= #count { X : node((X)) }.

density(D) :- num_edges(E), num_nodes(N), V1 = (1000*E), V2 = N*(N-1), D = V1 / V2.

#show density/1.

% #show action/3.
% #show at/4.
