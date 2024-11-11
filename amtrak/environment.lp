time(T) :- T=0..5.

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
start(1,(1,1),0,n).
end(1,(0,2),5).

train(2).
start(2,(1,0),0,s).
end(2,(0,1),9).

%%%%%%%%%%%%%%%


% action(train(ID), move_left, T):- .
% action(train(ID), move_right, T):- .
% action(train(ID), wait, T):- .
% action(train(ID), move_forward, T):- .



track_option(32800,(n,move_forward,n)).
track_option(32800,(s,move_forward,s)).
track_option(1025,(e,move_forward,e)).
track_option(1025,(w,move_forward,w)).
track_option(4608,(n,move_forward,w)).
track_option(4608,(e,move_forward,s)).
track_option(16386,(n,move_forward,e)).
track_option(16386,(w,move_forward,s)).
track_option(72,(s,move_forward,e)).
track_option(72,(w,move_forward,n)).
track_option(2064,(e,move_forward,n)).
track_option(2064,(s,move_forward,w)).
track_option(20994,(n,move_right,e)).
track_option(20994,(n,move_left,w)).
% track_option(20994,(n,wait,n)).
track_option(20994,(e,move_forward,s)).
track_option(20994,(w,move_forward,s)).
track_option(16458,(n,move_forward,e)).
track_option(16458,(s,move_forward,e)).
track_option(16458,(w,move_right,n)).
track_option(16458,(w,move_left,s)).
% track_option(16458,(w,wait,w)).
track_option(2136,(e,move_forward,n)).
track_option(2136,(s,move_left,e)).
track_option(2136,(s,move_right,w)).
% track_option(2136,(s,wait,s)).
track_option(2136,(w,move_forward,n)).
track_option(6672,(n,move_forward,w)).
track_option(6672,(e,move_left,n)).
track_option(6672,(e,move_right,s)).
% track_option(6672,(e,wait,e)).
track_option(6672,(s,move_forward,w)).
track_option(49186,(n,move_forward,n)).
track_option(49186,(n,move_right,e)).
% track_option(49186,(n,wait,n)).
track_option(49186,(s,move_forward,s)).
track_option(49186,(w,move_forward,s)).
track_option(1097,(e,move_forward,e)).
track_option(1097,(s,move_forward,e)).
track_option(1097,(w,move_right,n)).
track_option(1097,(w,move_forward,w)).
% track_option(1097,(w,wait,w)).
track_option(34864,(n,move_forward,n)).
track_option(34864,(e,move_forward,n)).
track_option(34864,(s,move_forward,s)).
track_option(34864,(s,move_right,w)).
% track_option(34864,(s,wait,s)).
track_option(5633,(n,move_forward,w)).
track_option(5633,(e,move_forward,e)).
track_option(5633,(e,move_right,s)).
% track_option(5633,(e,wait,e)).
track_option(5633,(w,move_forward,w)).
track_option(37408,(n,move_forward,n)).
track_option(37408,(n,move_left,w)).
% track_option(37408,(n,wait,n)).
track_option(37408,(e,move_forward,s)).
track_option(37408,(s,move_forward,s)).
track_option(17411,(n,move_forward,e)).
track_option(17411,(e,move_forward,e)).
track_option(17411,(w,move_left,s)).
track_option(17411,(w,move_forward,w)).
% track_option(17411,(w,wait,w)).
track_option(32872,(n,move_forward,n)).
track_option(32872,(s,move_left,e)).
track_option(32872,(s,move_forward,s)).
% track_option(32872,(s,wait,s)).
track_option(32872,(w,move_forward,n)).
track_option(3089,(e,move_left,n)).
track_option(3089,(e,move_forward,e)).
% track_option(3089,(e,wait,e)).
track_option(3089,(s,move_forward,w)).
track_option(3089,(w,move_forward,w)).
track_option(33825,(n,move_forward,n)).
track_option(33825,(e,move_forward,e)).
track_option(33825,(s,move_forward,s)).
track_option(33825,(w,move_forward,w)).
track_option(38433,(n,move_forward,n)).
track_option(38433,(n,move_left,w)).
% track_option(38433,(n,wait,n)).
track_option(38433,(e,move_forward,e)).
track_option(38433,(e,move_right,s)).
% track_option(38433,(e,wait,e)).
track_option(38433,(s,move_forward,s)).
track_option(38433,(w,move_forward,w)).
track_option(50211,(n,move_forward,n)).
track_option(50211,(n,move_right,e)).
% track_option(50211,(n,wait,n)).
track_option(50211,(e,move_forward,e)).
track_option(50211,(s,move_forward,s)).
track_option(50211,(w,move_left,s)).
track_option(50211,(w,move_forward,w)).
% track_option(50211,(w,wait,w)).
track_option(33897,(n,move_forward,n)).
track_option(33897,(e,move_forward,e)).
track_option(33897,(s,move_left,e)).
track_option(33897,(s,move_forward,s)).
% track_option(33897,(s,wait,s)).
track_option(33897,(w,move_right,n)).
track_option(33897,(w,move_forward,w)).
% track_option(33897,(w,wait,w)).
track_option(35889,(n,move_forward,n)).
track_option(35889,(e,move_left,n)).
track_option(35889,(e,move_forward,e)).
% track_option(35889,(e,wait,e)).
track_option(35889,(s,move_forward,s)).
track_option(35889,(s,move_right,w)).
% track_option(35889,(s,wait,s)).
track_option(35889,(w,move_forward,w)).
track_option(38505,(n,move_forward,n)).
track_option(38505,(n,move_left,w)).
% track_option(38505,(n,wait,n)).
track_option(38505,(e,move_forward,e)).
track_option(38505,(e,move_right,s)).
% track_option(38505,(e,wait,e)).
track_option(38505,(s,move_left,e)).
track_option(38505,(s,move_forward,s)).
% track_option(38505,(s,wait,s)).
track_option(38505,(w,move_right,n)).
track_option(38505,(w,move_forward,w)).
% track_option(38505,(w,wait,w)).
track_option(52275,(n,move_forward,n)).
track_option(52275,(n,move_right,e)).
% track_option(52275,(n,wait,n)).
track_option(52275,(e,move_left,n)).
track_option(52275,(e,move_forward,e)).
% track_option(52275,(e,wait,e)).
track_option(52275,(s,move_forward,s)).
track_option(52275,(s,move_right,w)).
% track_option(52275,(s,wait,s)).
track_option(52275,(w,move_left,s)).
track_option(52275,(w,move_forward,w)).
% track_option(52275,(w,wait,w)).