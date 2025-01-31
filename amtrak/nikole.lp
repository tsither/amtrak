
time(T) :- T=0..EndT, end(_,_,EndT).

option((X,Y),TO) :- track_option(Track,TO),  cell((X,Y), Track).

% at time 0 trains should be found at their starting position
at(ID,(X,Y),Dep,Dir) :- time(Dep), start(ID,(X,Y),Dep,Dir).

% add actions based on train position and cell options
{ action(train(ID),M,T+1): option((X,Y),(D,M,_)) } = 1 :-
    at(ID,(X,Y),T,D), T < EndT, end(ID,_,EndT), time(T+1).

% only one action per train and time T
:- M1 != M2, action(train(ID),M1,T), action(train(ID),M2,T).

% only one at movement per train and time T
:- D1 != D2, at(ID,(_,_),T,D1), at(ID,(_,_),T,D2).
:- ID1 != ID2, at(ID1,(X,Y),T,_), at(ID2,(X,Y),T,_).
% :- XY1 != XY2, at(ID,XY1,T,_), at(ID,XY2,T,_).

% if moving forward add ats to indicate new cell positions
at(ID,(X,Y),T2,D) :- option((X,Y),(D,wait,D)), action(train(ID),wait,T2),
    at(ID,(X,Y),T1,D), T2 = T1 + 1, time(T2), time(T1).

at(ID,(X2,Y),T2,n) :- X2 = X1-1, option((X1,Y),(D,M,n)),
    cell((X2,Y),_), action(train(ID),M,T2), at(ID,(X1,Y),T1,D),
    T2 = T1 + 1, time(T2), time(T1).

at(ID,(X,Y2),T2,e) :- Y2 = Y1+1, option((X,Y1),(D,M,e)),
    cell((X,Y2),_), action(train(ID),M,T2), at(ID,(X,Y1),T1,D),
    T2 = T1 + 1, time(T2), time(T1).

at(ID,(X2,Y),T2,s) :- X2 = X1+1, option((X1,Y),(D,M,s)),
    cell((X2,Y),_), action(train(ID),M,T2), at(ID,(X1,Y),T1,D),
    T2 = T1 + 1, time(T2), time(T1).

at(ID,(X,Y2),T2,w) :- Y2 = Y1-1, option((X,Y1),(D,M,w)),
    cell((X,Y2),_), action(train(ID),M,T2), at(ID,(X,Y1),T1,D),
    T2 = T1 + 1, time(T2), time(T1).

% all trains must arrive at end destination
arrived(ID,T,(X,Y),EndT) :- at(ID,(X,Y),T,_), end(ID,(X,Y),EndT), T<=EndT.
:- train(ID), not arrived(ID,_,_,_).

% add links between connected track cells
link((X1,Y),(X2,Y)) :- option((X1,Y),(_,_,s)), option((X2,Y),(s,_,_)), X2 = X1 + 1.
link((X,Y1),(X,Y2)) :- option((X,Y1),(_,_,e)), option((X,Y2),(e,_,_)), Y2 = Y1 + 1.
link((X,Y1),(X,Y2)) :- option((X,Y1),(_,_,w)), option((X,Y2),(w,_,_)), Y2 = Y1 - 1.
link((X1,Y),(X2,Y)) :- option((X1,Y),(_,_,n)), option((X2,Y),(n,_,_)), X2 = X1 - 1.

% TODO: make sure this works, maybe refine a bit
% trains cant jump over each other on adjacent cells
jumped(ID1,ID2,T) :- at(ID1,(X1,Y1),T,_), at(ID2,(X2,Y2),T,_),
    link((X1,Y1),(X2,Y2)), at(ID1,(X2,Y2),T2,_),
    at(ID2,(X1,Y1),T2,_), T2=T+1, ID1<ID2.
:- jumped(_,_,_).


#minimize{ 1:  action(ID,wait,T)}.

#show action/3.
