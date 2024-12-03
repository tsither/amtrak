#include "test_env_1.lp".
#include "amtrak/wait/track_option_wait_all.lp".


option((X,Y),TO) :- track_option(Track,TO),  cell((X,Y), Track). % map the general track options to the current flatland environment in the form of 'option' atoms


% Trains must start at their starting positions at start times
at(train(ID),(X,Y),Dep,Dir) :- start(ID,(X,Y),Dep,Dir).


%%%%%% edges %%%%%% 
% create edges between cells, include movement type to get to second cell, and the direction in between
edge((X1,Y1),(X2,Y2)) :- option((X1,Y1), (_,M,D)), option((X2,Y2), (D,_,_)), Y2=Y1, X2 = X1 + 1. %D = "s".
edge((X1,Y1),(X2,Y2)) :- option((X1,Y1), (_,M,D)), option((X2,Y2), (D,_,_)), Y2=Y1, X2 = X1 - 1. %D = "n".
edge((X1,Y1),(X2,Y2)) :- option((X1,Y1), (_,M,D)), option((X2,Y2), (D,_,_)), X2=X1, Y2 = Y1 - 1. %D = "w".
edge((X1,Y1),(X2,Y2)) :- option((X1,Y1), (_,M,D)), option((X2,Y2), (D,_,_)), X2=X1, Y2 = Y1 + 1. %D = "e".
%%%%%% %%%%%% %%%%%% %%%%%% 

% time_limit(ID,T) :- start(ID,(_,_),START_T,_), end(ID,_,END_T), T = END_T - START_T.

path(ID, (X1,Y1),(X2,Y2))  :- start(ID,(X1,Y1),_,_), edge((X1,Y1),(X2,Y2)).

{ path(ID, (X2,Y2),(X3,Y3)) : edge((X2,Y2),(X3,Y3)) } :- path(ID, (X1,Y1),(X2,Y2)).

:- not path(ID, (_,_),(X2,Y2)), end(ID,(X2,Y2),_).



% #minimize{ 1: path(ID, _,_)}.




% #show first_at/4.
#show path/3.
% #show n_moves/2.
% #show time_limit/2.