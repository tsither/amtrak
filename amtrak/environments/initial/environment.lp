time(T) :- T=0..9.

%%%% Grid %%%%%
% cell((0,0), 32800). cell((0,1), 32800).
% cell((1,0), 37408). cell((1,1), 32800).
% cell((2,0), 72).    cell((2,1), 2064).

% original
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
start(1,(0,0),2,w).
end(1,(0,2),9).

train(2).
start(2,(1,0),0,s).
end(2,(0,1),7).

%%%%%%%%%%%%%%%


% action(train(ID), move_left, T):- .
% action(train(ID), move_right, T):- .
% action(train(ID), wait, T):- .
% action(train(ID), move_forward, T):- .
