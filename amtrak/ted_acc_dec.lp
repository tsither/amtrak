#include "graph/test_envs/test_env_2/test_env_2.lp".
#include "graph/track_option.lp".

time(X) :- end(_,_,T), X=0..T.

option((X,Y),TO) :- track_option(Track,TO),  cell((X,Y), Track). % map the general track options to the current flatland environment in the form of 'option' atoms

% Trains must start at their starting positions at start times
at(train(ID),(X,Y),Dep,Dir) :- time(Dep), start(ID,(X,Y),Dep,Dir).

% Trains wait before and after their start times
action(train(ID),wait,T) :- T < ST, start(ID,_,ST,_), time(T).
action(train(ID),wait,T) :- T > ET, end(ID,_,ET), time(T).
action(train(ID),wait,T) :- T = ST, start(ID,_,ST,_), time(T).


%%%%%%%%%%%% Generation %%%%%%%%%%%%

% add actions based on train position and cell options

{ action(train(ID),M,T+1): option((X,Y),(D,M,_)) } = 1 :-       %for non accelerating trains
    at(train(ID),(X,Y),T,D), T < ET, end(ID,_,ET), time(T+1). 
    not acc(ID,(X,Y)).

{ action(train(ID),M,T2): option((X,Y),(D,M,_)) } = 1 :-       %for accelerating trains
    at(train(ID),(X,Y),T1,D), 
    action(train(ID),wait,T),     %iterate through at atoms before movement
    at(train(ID),(X,Y),T,D), 
    action(train(ID),M,T1),
    T<T1<T2,
    acc(ID,(X,Y)).

    % T < ET, end(ID,_,ET), time(T+1),

% Generate new 'at' atoms based off previous action movements

at(train(ID),(X,Y),T2,D1) :- option((X,Y),(D1,wait,D2)), action(train(ID),wait,T2),    % WAIT : if there is a 'wait' action chosen on this cell, train waits on this timestep
    at(train(ID),(X,Y),T1,D1), T2 = T1 + 1, time(T2), time(T1).                      % modified option(D,_,D)

%no decelerating
at(train(ID),(X2,Y),T2,n) :- X2 = X1-1, option((X1,Y),(D,M,n)),         % action moves train into new cell, create new 'at' atom: if the direction out of a movement is 'north', put train on the next cell facing north
    cell((X2,Y),_), action(train(ID),M,T2), at(train(ID),(X1,Y),T1,D),
    T2 = T1 + 1, time(T2), time(T1), M!=wait, 
    not dec(ID,(X2,Y)), not acc(ID,(X1,Y)).       % Must NOT be a wait, train must move to change cells, must not be decelerating

at(train(ID),(X,Y2),T2,e) :- Y2 = Y1+1, option((X,Y1),(D,M,e)),         % east
    cell((X,Y2),_), action(train(ID),M,T2), at(train(ID),(X,Y1),T1,D),
    T2 = T1 + 1, time(T2), time(T1), M!=wait, 
    not dec(ID,(X,Y2)), not acc(ID,(X,Y1)). 

at(train(ID),(X2,Y),T2,s) :- X2 = X1+1, option((X1,Y),(D,M,s)),         % south
    cell((X2,Y),_), action(train(ID),M,T2), at(train(ID),(X1,Y),T1,D),
    T2 = T1 + 1, time(T2), time(T1), M!=wait,
    not dec(ID,(X2,Y)), not acc(ID,(X1,Y)).

at(train(ID),(X,Y2),T2,w) :- Y2 = Y1-1, option((X,Y1),(D,M,w)),         % west
    cell((X,Y2),_), action(train(ID),M,T2), at(train(ID),(X,Y1),T1,D),
    T2 = T1 + 1, time(T2), time(T1), M!=wait, 
    not dec(ID,(X,Y2)), not acc(ID,(X,Y1)).



%%%%%%%%%%%% Constraining %%%%%%%%%%%%

% only one action per train and time T                                  % no duplicate actions
:- M1 != M2, action(train(ID),M1,T), action(train(ID),M2,T).

% all trains must arrive at end destination
arrived(ID) :- at(train(ID),(X,Y),T,_), end(ID,(X,Y),ET), T<=ET.
:- train(ID), not arrived(ID).

% trains cant double up on cells
double((ID1,ID2,(X,Y),T)) :- at(train(ID1),(X,Y),T,_), at(train(ID2),(X,Y),T,_), ID1<ID2.
:- double(_).

% trains cant jump over each other on adjacent cells        
jumped((ID1,ID2,T)) :- at(train(ID1),(X1,Y1),T,_), at(train(ID2),(X2,Y2),T,_), edge((X1,Y1),(X2,Y2)), at(train(ID1),(X2,Y2),T2,_), at(train(ID2),(X1,Y1),T2,_), T2=T+1, ID1<ID2.
:- jumped(_).

%%%%%% edges %%%%%% 
% create edges between cells, include movement type to get to second cell, and the direction in between
edge((X1,Y),(X2,Y)) :- option((X1,Y), (_,M,s)), option((X2,Y), (s,_,_)), X2 = X1 + 1. %D = "s".
edge((X1,Y),(X2,Y)) :- option((X1,Y), (_,M,n)), option((X2,Y), (n,_,_)), X2 = X1 - 1. %D = "n".
edge((X,Y1),(X,Y2)) :- option((X,Y1), (_,M,w)), option((X,Y2), (w,_,_)), Y2 = Y1 - 1. %D = "w".
edge((X,Y1),(X,Y2)) :- option((X,Y1), (_,M,e)), option((X,Y2), (e,_,_)), Y2 = Y1 + 1. %D = "e".
%%%%%% %%%%%% %%%%%% %%%%%% 



%%%%%%%% Dec into stations %%%%%%%%

% mark cells that lead into stations
adj_station((X1,Y1),(X,Y)) :- end(_,(X,Y),_), edge((X,Y),(X1,Y1)). 

% mark train number and the cells in will need to decelerate
dec(ID,ADJ) :- train(ID), end(ID,STA,T), adj_station(ADJ,STA).

% decelerating
at(train(ID),(X2,Y),T2,n) :- X2 = X1-1, option((X1,Y),(D,M,n)),         % action moves train into new cell, create new 'at' atom: if the direction out of a movement is 'north', put train on the next cell facing north
    cell((X2,Y),_), action(train(ID),M,T2), at(train(ID),(X1,Y),T1,D),
    T2 = T1 + 2, time(T2), time(T1), M!=wait, 
    dec(ID,(X2,Y)).                           

at(train(ID),(X,Y2),T2,e) :- Y2 = Y1+1, option((X,Y1),(D,M,e)),         % east
    cell((X,Y2),_), action(train(ID),M,T2), at(train(ID),(X,Y1),T1,D),
    T2 = T1 + 2, time(T2), time(T1), M!=wait, 
    dec(ID,(X,Y2)). 

at(train(ID),(X2,Y),T2,s) :- X2 = X1+1, option((X1,Y),(D,M,s)),         % south
    cell((X2,Y),_), action(train(ID),M,T2), at(train(ID),(X1,Y),T1,D),
    T2 = T1 + 2, time(T2), time(T1), M!=wait, 
    dec(ID,(X2,Y)).

at(train(ID),(X,Y2),T2,w) :- Y2 = Y1-1, option((X,Y1),(D,M,w)),         % west
    cell((X,Y2),_), action(train(ID),M,T2), at(train(ID),(X,Y1),T1,D),
    T2 = T1 + 2, time(T2), time(T1), M!=wait, 
    dec(ID,(X,Y2)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%% Acc from start and waiting %%%%%%%%

% mark cells that lead out of start cells
% adj_start((X1,Y1),(X,Y)) :- start(_,(X,Y),_,_), edge((X,Y),(X1,Y1)). 

% mark train number and the cells that will need to accelerate in
acc(ID,S) :- train(ID), start(ID,S,_,_).

% accelerating
at(train(ID),(X2,Y),T2,n) :- X2 = X1-1, option((X1,Y),(D,M,n)),         % action moves train into new cell, create new 'at' atom: if the direction out of a movement is 'north', put train on the next cell facing north
    cell((X2,Y),_), action(train(ID),M,T2), at(train(ID),(X1,Y),T1,D),
    T2 = T1 + 2, time(T2), time(T1), M!=wait, 
    acc(ID,(X1,Y)).                            

at(train(ID),(X,Y2),T2,e) :- Y2 = Y1+1, option((X,Y1),(D,M,e)),         % east
    cell((X,Y2),_), action(train(ID),M,T2), at(train(ID),(X,Y1),T1,D),
    T2 = T1 + 2, time(T2), time(T1), M!=wait, 
    acc(ID,(X,Y1)). 

at(train(ID),(X2,Y),T2,s) :- X2 = X1+1, option((X1,Y),(D,M,s)),         % south
    cell((X2,Y),_), action(train(ID),M,T2), at(train(ID),(X1,Y),T1,D),
    T2 = T1 + 2, time(T2), time(T1), M!=wait, 
    acc(ID,(X1,Y)).

at(train(ID),(X,Y2),T2,w) :- Y2 = Y1-1, option((X,Y1),(D,M,w)),         % west
    cell((X,Y2),_), action(train(ID),M,T2), at(train(ID),(X,Y1),T1,D),
    T2 = T1 + 2, time(T2), time(T1), M!=wait, 
    acc(ID,(X,Y1)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


#show acc/2.

% #show dec/2.
% #show adj_station/2.

% #show arrived/1.
% #show option/2.
% #show edge/2.
% #show jumped/1.
% #show double/1.

#show at/4.
#show action/3.



%%%%%%%% Optimization %%%%%%%%
% optimal optimization, do in one line to reduce grounding
% #minimize{ 1:  action(ID,wait,T)}.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


