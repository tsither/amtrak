
% Track type 1
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

% Track type 6
track_option(20994,(n,move_right,e)).
track_option(20994,(n,move_left,w)).
track_option(20994,(e,move_forward,s)).
track_option(20994,(w,move_forward,s)).

track_option(16458,(n,move_forward,e)).
track_option(16458,(s,move_forward,e)).
track_option(16458,(w,move_right,n)).
track_option(16458,(w,move_left,s)).

track_option(2136,(e,move_forward,n)).
track_option(2136,(s,move_left,e)).
track_option(2136,(s,move_right,w)).
track_option(2136,(w,move_forward,n)).

track_option(6672,(n,move_forward,w)).
track_option(6672,(e,move_left,n)).
track_option(6672,(e,move_right,s)).
track_option(6672,(s,move_forward,w)).

% Track type 2
track_option(49186,(n,move_forward,n)).
track_option(49186,(n,move_right,e)).
track_option(49186,(s,move_forward,s)).
track_option(49186,(w,move_forward,s)).

track_option(1097,(e,move_forward,e)).
track_option(1097,(s,move_forward,e)).
track_option(1097,(w,move_right,n)).
track_option(1097,(w,move_forward,w)).

track_option(34864,(n,move_forward,n)).
track_option(34864,(e,move_forward,n)).
track_option(34864,(s,move_forward,s)).
track_option(34864,(s,move_right,w)).

track_option(5633,(n,move_forward,w)).
track_option(5633,(e,move_forward,e)).
track_option(5633,(e,move_right,s)).
track_option(5633,(w,move_forward,w)).

track_option(37408,(n,move_forward,n)).
track_option(37408,(n,move_left,w)).
track_option(37408,(e,move_forward,s)).
track_option(37408,(s,move_forward,s)).

track_option(17411,(n,move_forward,e)).
track_option(17411,(e,move_forward,e)).
track_option(17411,(w,move_left,s)).
track_option(17411,(w,move_forward,w)).

track_option(32872,(n,move_forward,n)).
track_option(32872,(s,move_left,e)).
track_option(32872,(s,move_forward,s)).
track_option(32872,(w,move_forward,n)).

track_option(3089,(e,move_left,n)).
track_option(3089,(e,move_forward,e)).
track_option(3089,(s,move_forward,w)).
track_option(3089,(w,move_forward,w)).

% Track type 3
track_option(33825,(n,move_forward,n)).
track_option(33825,(e,move_forward,e)).
track_option(33825,(s,move_forward,s)).
track_option(33825,(w,move_forward,w)).

% Track type 4
track_option(38433,(n,move_forward,n)).
track_option(38433,(n,move_left,w)).
track_option(38433,(e,move_forward,e)).
track_option(38433,(e,move_right,s)).
track_option(38433,(s,move_forward,s)).
track_option(38433,(w,move_forward,w)).

track_option(50211,(n,move_forward,n)).
track_option(50211,(n,move_right,e)).
track_option(50211,(e,move_forward,e)).
track_option(50211,(s,move_forward,s)).
track_option(50211,(w,move_left,s)).
track_option(50211,(w,move_forward,w)).

track_option(33897,(n,move_forward,n)).
track_option(33897,(e,move_forward,e)).
track_option(33897,(s,move_left,e)).
track_option(33897,(s,move_forward,s)).
track_option(33897,(w,move_right,n)).
track_option(33897,(w,move_forward,w)).

track_option(35889,(n,move_forward,n)).
track_option(35889,(e,move_left,n)).
track_option(35889,(e,move_forward,e)).
track_option(35889,(s,move_forward,s)).
track_option(35889,(s,move_right,w)).
track_option(35889,(w,move_forward,w)).

% Track type 5
track_option(38505,(n,move_forward,n)).
track_option(38505,(n,move_left,w)).
track_option(38505,(e,move_forward,e)).
track_option(38505,(e,move_right,s)).
track_option(38505,(s,move_left,e)).
track_option(38505,(s,move_forward,s)).
track_option(38505,(w,move_right,n)).
track_option(38505,(w,move_forward,w)).

track_option(52275,(n,move_forward,n)).
track_option(52275,(n,move_right,e)).
track_option(52275,(e,move_left,n)).
track_option(52275,(e,move_forward,e)).
track_option(52275,(s,move_forward,s)).
track_option(52275,(s,move_right,w)).
track_option(52275,(w,move_left,s)).
track_option(52275,(w,move_forward,w)).

track_option(Track,(D,wait,D)) :- M != wait, track_option(Track,(D,M,_)).
