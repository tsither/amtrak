time(T) :- T=0..4.

% original
%%%% Grid %%%%%
% cell((0,0), 16386).
% cell((0,1), 33825).
% cell((0,2), 72).

% cell((1,0), 20994).
% cell((1,1), 33825).
% cell((1,2), 2064).

% cell((2,0), 4608).
% cell((2,1), 34864).
% cell((2,2), 32800).
%%%%%%%%%%%%%%%


cell((0,0), 32800). cell((1,0), 32800).
cell((0,1), 37408). cell((1,1), 32800).
cell((0,2), 72).    cell((1,2), 2064).


%%%% Trains %%%%
train(1).
start(1,(0,2),0,e).
end(1,(0,2),9).

% train(2).
% start(2,(0,1),0,s).
% end(2,(0,1),9).

% original

% train(2). 
% start(2,(2,2),0,n).
% end(2,(2,2),9).
%%%%%%%%%%%%%%%


% action(train(ID), move_left, T):- .
% action(train(ID), move_right, T):- .
% action(train(ID), wait, T):- .
% action(train(ID), move_forward, T):- .

