% add time steps
time(T) :- T=0..EndT, end(_,_,EndT).

%%%%%%%% Mapping Cell Options %%%%%%%%

% add options for movement between connected track cells for each direction
option((X1,Y),(X2,Y),D,M,n) :- track_option(Track1,(D,M,n)),
    track_option(Track2,(n,_,_)), X2 = X1 - 1, cell((X1,Y), Track1),
    cell((X2,Y), Track2), M != wait. % north
option((X,Y1),(X,Y2),D,M,e) :- track_option(Track1,(D,M,e)),
    track_option(Track2,(e,_,_)), Y2 = Y1 + 1, cell((X,Y1), Track1),
    cell((X,Y2), Track2), M != wait. % east
option((X1,Y),(X2,Y),D,M,s) :- track_option(Track1,(D,M,s)),
    track_option(Track2,(s,_,_)), X2 = X1 + 1, cell((X1,Y), Track1),
    cell((X2,Y), Track2), M != wait. % south
option((X,Y1),(X,Y2),D,M,w) :- track_option(Track1,(D,M,w)),
    track_option(Track2,(w,_,_)), Y2 = Y1 - 1, cell((X,Y1), Track1),
    cell((X,Y2), Track2), M != wait. % west

% add options for trains waiting
option((X,Y),(X,Y),D,wait,D) :- track_option(Track,(D,wait,D)),
    cell((X,Y), Track).

%%%%%%%% Movement Generation %%%%%%%%

% until a train's start time step it should wait
action(train(ID),wait,T) :- time(T), T < StartT, start(ID,_,StartT,_).

% on a train's start time it should move forward onto its starting cell
action(train(ID),move_forward,StartT) :- start(ID,_,StartT,_).
at(ID,(X,Y),StartT+1,D) :- start(ID,(X,Y),StartT,D).

% add action atoms based on train position and cell options
{ action(train(ID),M,T): option((X1,Y1),(X2,Y2),D1,M,D2) } = 1 :-
    at(ID,(X1,Y1),T,D1), StartT < T < EndT, end(ID,_,EndT),
    start(ID,_,StartT,_).

% add at atoms for each trains' position at each time step
at(ID,(X2,Y2),T+1,D2) :- action(train(ID),M,T), time(T+1),
    option((X1,Y1),(X2,Y2),D1,M,D2), at(ID,(X1,Y1),T,D1).

% after a train's end time step it should wait
action(train(ID),wait,T) :- done(ID,T).

%%%%%%%% Constraining Movements %%%%%%%%

% trains cannot occupy the same cell
:- ID1 != ID2, at(ID1,(X,Y),T,_), at(ID2,(X,Y),T,_).

% trains cannot jump over eachother to switch places
:- ID1 != ID2, at(ID1,(X2,Y2),T+1,_), at(ID2,(X1,Y1),T+1,_),
    at(ID1,(X1,Y1),T,_), at(ID2,(X2,Y2),T,_).

%%%%%%%% End Destinations %%%%%%%%

% when a train reaches its end destination add a done
done(ID,T) :- at(ID,(X,Y),T,_), end(ID,(X,Y),EndT), T<EndT.

% and add a done for each time step after reaching end destination
done(ID,T+1) :- done(ID,T), end(ID,(X,Y),EndT), T+1<EndT.

% all trains must arrive at its end destination
:- train(ID), not done(ID,_).

%%%%%%%% Optimization %%%%%%%%

#maximize{ 1, ID, T: done(ID,T) }.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#show action/3.

%%% Uncomment lines below to use with utils/edit_output.py %%%
% #show done/2.
% #show at/4.
% #show end/3.
% #show option/5.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
