
time(T) :- T=0..ET, end(_,_,ET). %iterate from timestep 0 to end time

option((X,Y),TO) :- track_option(Track,TO),  cell((X,Y), Track). % map the general track options to the current flatland environment in the form of 'option' atoms

% Trains must start at their starting positions at start times
at(train(ID),(X,Y),Dep,Dir) :- time(Dep), start(ID,(X,Y),Dep,Dir).

% add wait actions before and after trains' start and end times         % maybe not necessary?
% action(train(ID),wait,T) :- T < ST, start(ID,_,ST,_), time(T).
% action(train(ID),wait,T) :- T > ET, end(ID,_,ET), time(T).



%%%%%%%%%%%% Generation %%%%%%%%%%%%


% TODO: should actions be happening at T or T+1? At T=0 no action?

% add actions based on train position and cell options
{ action(train(ID),M,T+1): option((X,Y),(D,M,_)) } = 1 :-
    at(train(ID),(X,Y),T,D), T < ET, end(ID,_,ET), time(T+1).


% Generate new 'at' atoms based off previous action movements

at(train(ID),(X,Y),T2,D1) :- option((X,Y),(D1,wait,D2)), action(train(ID),wait,T2),    % WAIT : if there is a 'wait' action chosen on this cell, train waits on this timestep
    at(train(ID),(X,Y),T1,D1), T2 = T1 + 1, time(T2), time(T1).                      % modified option(D,_,D)

at(train(ID),(X2,Y),T2,n) :- X2 = X1-1, option((X1,Y),(D,M,n)),         % action moves train into new cell, create new 'at' atom: if the direction out of a movement is 'north', put train on the next cell facing north
    cell((X2,Y),_), action(train(ID),M,T2), at(train(ID),(X1,Y),T1,D),
    T2 = T1 + 1, time(T2), time(T1), M!=wait.                           % Must NOT be a wait, train must move to change cells

at(train(ID),(X,Y2),T2,e) :- Y2 = Y1+1, option((X,Y1),(D,M,e)),         % east
    cell((X,Y2),_), action(train(ID),M,T2), at(train(ID),(X,Y1),T1,D),
    T2 = T1 + 1, time(T2), time(T1), M!=wait.

at(train(ID),(X2,Y),T2,s) :- X2 = X1+1, option((X1,Y),(D,M,s)),         % south
    cell((X2,Y),_), action(train(ID),M,T2), at(train(ID),(X1,Y),T1,D),
    T2 = T1 + 1, time(T2), time(T1), M!=wait.

at(train(ID),(X,Y2),T2,w) :- Y2 = Y1-1, option((X,Y1),(D,M,w)),         % west
    cell((X,Y2),_), action(train(ID),M,T2), at(train(ID),(X,Y1),T1,D),
    T2 = T1 + 1, time(T2), time(T1), M!=wait.



%%%%%%%%%%%% Constraining %%%%%%%%%%%%


% only one action per train and time T                                  % no duplicate actions
:- M1 != M2, action(train(ID),M1,T), action(train(ID),M2,T).

% only one at movement per train and time T                          
:- D1 != D2, at(train(ID),(_,_),T,D1), at(train(ID),(_,_),T,D2).        % no two 'at's that have same train, time, and direction
:- ID1 != ID2, at(train(ID1),(X,Y),T,_), at(train(ID2),(X,Y),T,_).      % no two trains on same cell at same time

% ensure trains reach their destinations
:- not at(train(ID),(X,Y),_,_), end(ID,(X,Y),_).                        % trains must reach destination



% TO DO: implement waiting, deadlocks, crossing paths, jumping trains


% Trains can't jump over each other
%  action(train(ID1),M,T), action(train(ID),M,T), 
:- at(train(ID1),(X1,Y1),T,_), at(train(ID2),(X2,Y2),T,_), ID1!=ID2, X1=X2+1, Y1=Y2,
    at(train(ID1),(X2,Y2),T2,_), at(train(ID2),(X1,Y1),T2,_), T2 = T + 1.

:- at(train(ID1),(X1,Y1),T,_), at(train(ID2),(X2,Y2),T,_), ID1!=ID2, Y1=Y2+1, X1=X2,
    at(train(ID1),(X2,Y2),T2,_), at(train(ID2),(X1,Y1),T2,_), T2 = T + 1.




% TODO: max-/minimize statement could be based on num of waits within each
%     trains' accepted movement timeframe?
% #maximize{ 1,T,M,N: at(train(ID),(X,Y2),T2,w) }.






%%%%% Notes for Ted %%%%%%%%
% - There is an 'at' atom generated at timestep 0 for a train on the start cell
% - actions are generated after beginning T = 1, trains have 'wait' actions before they are generated
% - action timesteps are aligned with the 'at' atom it MOVES INTO
%
%
%

#show at/4.
% #show action/3.
