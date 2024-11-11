
% option((X,Y),@options(Track,move_left,move_forward,move_right,wait,n,e,s,w))
%     :- cell((X,Y), Track).

% TODO: is the following code faster than the above code?
% track_option(Track,
%               @options(Track,move_left,move_forward,move_right,wait,n,e,s,w))
%     :- cell(_, Track).
option((X,Y),TO) :- track_option(Track,TO),  cell((X,Y), Track).

% at time 0 trains should be found at their starting position
at(train(ID),(X,Y),Dep,Dir) :- time(Dep), start(ID,(X,Y),Dep,Dir).

% TODO: handle situation where train starts on a curve (diff in and out dir)
% action(train(ID),move_forward,Dep) :- at(train(ID),(X,Y),Dep,Dir),
%     option((X,Y),(_,move_forward,Dir)), start(ID,(X,Y),Dep,Dir).

% TODO: should actions be happening at T or T+1? At T=0 no action?

% add actions based on train position and cell options
{ action(train(ID),M,T+1): option((X,Y),(D,M,_)) } = 1 :- at(train(ID),(X,Y),T,D),
    T < ET, end(ID,_,ET), time(T+1).

% TODO: wait handling
% where a train has not taken a move, add a wait action
% action(train(ID),wait,T) :- option((X,Y),(_,_,D)), time(T), train(ID), not action(train(ID),_,T).

% only one action per train and time T
:- M1 != M2, action(train(ID),M1,T), action(train(ID),M2,T).

% only one movement at per train and time T
:- D1 != D2, at(train(ID),(_,_),T,D1), at(train(ID),(_,_),T,D2).
:- ID1 != ID2, at(train(ID1),(X,Y),T,_), at(train(ID2),(X,Y),T,_).

% ensure trains reach their destinations
:- not at(train(ID),(X,Y),_,_), end(ID,(X,Y),_).

% if moving forward add ats to indicate new cell positions
% at(train(ID),(X,Y),T2,D) :- option((X,Y),(D,wait,D)), action(train(ID),wait,T2),
%     at(train(ID),(X,Y),T1,D), T2 = T1 + 1, time(T2), time(T1).

at(train(ID),(X2,Y),T2,n) :- X2 = X1-1, option((X1,Y),(D,M,n)),
    cell((X2,Y),_), action(train(ID),M,T2), at(train(ID),(X1,Y),T1,D),
    T2 = T1 + 1, time(T2), time(T1).

at(train(ID),(X,Y2),T2,e) :- Y2 = Y1+1, option((X,Y1),(D,M,e)),
    cell((X,Y2),_), action(train(ID),M,T2), at(train(ID),(X,Y1),T1,D),
    T2 = T1 + 1, time(T2), time(T1).

at(train(ID),(X2,Y),T2,s) :- X2 = X1+1, option((X1,Y),(D,M,s)),
    cell((X2,Y),_), action(train(ID),M,T2), at(train(ID),(X1,Y),T1,D),
    T2 = T1 + 1, time(T2), time(T1).

at(train(ID),(X,Y2),T2,w) :- Y2 = Y1-1, option((X,Y1),(D,M,w)),
    cell((X,Y2),_), action(train(ID),M,T2), at(train(ID),(X,Y1),T1,D),
    T2 = T1 + 1, time(T2), time(T1).

% TODO: ensure train gets to end cell (and then stops moving?)
% TODO: handle train conflicts

#show action/3.
