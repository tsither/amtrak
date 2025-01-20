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


% only one action per train and time T
:- M1 != M2, action(train(ID),M1,T), action(train(ID),M2,T).

% only one at movement per train and time T
:- D1 != D2, at(train(ID),(_,_),T,D1), at(train(ID),(_,_),T,D2).
:- ID1 != ID2, at(train(ID1),(X,Y),T,_), at(train(ID2),(X,Y),T,_).

% ensure trains reach their destinations
:- not at(train(ID),(X,Y),_,_), end(ID,(X,Y),_).

% if moving forward add ats to indicate new cell positions
at(train(ID),(X,Y),T2,D) :- option((X,Y),(D,wait,D)), action(train(ID),wait,T2),
    at(train(ID),(X,Y),T1,D), T2 = T1 + 1, time(T2), time(T1).

at(train(ID),(X2,Y),T2,n) :- 
    edge((X1,Y),M,(X2,Y)),
    action(train(ID),M,T2), at(train(ID),(X1,Y),T1,D),
    T2 = T1 + 1, time(T2), time(T1).

at(train(ID),(X,Y2),T2,e) :- Y2 = Y1+1, 
    edge((X,Y1),M,(X,Y2)),
    action(train(ID),M,T2), at(train(ID),(X,Y1),T1,D),
    T2 = T1 + 1, time(T2), time(T1).

at(train(ID),(X2,Y),T2,s) :- X2 = X1+1, 
    edge((X1,Y),M,(X2,Y)),
    action(train(ID),M,T2), at(train(ID),(X1,Y),T1,D),
    T2 = T1 + 1, time(T2), time(T1).

at(train(ID),(X,Y2),T2,w) :- Y2 = Y1-1, 
    edge((X,Y1),M,(X,Y2)),
    action(train(ID),M,T2), at(train(ID),(X,Y1),T1,D),
    T2 = T1 + 1, time(T2), time(T1).

% Graph density %
num_edges(D) :- D = #count { X,Y,Z : edge(X,Y,Z) }.
num_nodes(N) :- N= #count { X : node((X)) }.

density(D) :- num_edges(E), num_nodes(N), V1 = (1000*E), V2 = N*(N-1), D = V1 / V2.

% #show density/1.
#show at/4.
#show action/3.

% #show action/3.
% #show at/4.
