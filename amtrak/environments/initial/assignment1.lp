time(T) :- T=1..9.

%%%% Grid %%%%%
cell((0,0), 16386).
cell((1,0), 33825).
cell((2,0), 72).

cell((0,1), 20994).
cell((1,1), 33825).
cell((2,1), 2064).

cell((0,2), 4608).
cell((1,2), 34864).
cell((2,2), 32800).
%%%%%%%%%%%%%%%

%%%% Trains %%%%
train(1).
start(1,(1,0),0,e).
end(1,(1,0),9).

train(2). 
start(2,(2,2),0,n).
end(2,(2,2),9).
%%%%%%%%%%%%%%%


% action(train(ID), move left, T):- .
% action(train(ID), move right, T):- .
% action(train(ID), wait, T):- .
% action(train(ID), move forward, T):- .

