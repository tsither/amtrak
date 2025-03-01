

(3,6) to (11,6) : Distance = 22

#p_node_action(train(#b(2)),#b((3,6)),#p,(#p,#p,#b(w)),#b((11,6)),(dep(#b(41)),dist(#p),arr(#b(191)))):-node_action(train(2),(3,6),move_forward,(s,n,w),(11,6),(dep(41),dist(150),arr(191))).

#p_node_action(train(#b(2)),#b((3,6)),#p,(#p,#p,#b(w)),#b((11,6)),(dep(#b(39)),dist(#p),arr(#b(189)))):-node_action(train(2),(3,6),move_forward,(s,n,w),(11,6),(dep(39),dist(150),arr(189))).

#p_node_action(train(#b(2)),#b((3,6)),#p,(#p,#p,#b(w)),#b((11,6)),(dep(#b(37)),dist(#p),arr(#b(187)))):-node_action(train(2),(3,6),move_forward,(s,n,w),(11,6),(dep(37),dist(150),arr(187))).

#p_node_action(train(#b(2)),#b((3,6)),#p,(#p,#p,#b(w)),#b((11,6)),(dep(#b(35)),dist(#p),arr(#b(185)))):-node_action(train(2),(3,6),move_forward,(s,n,w),(11,6),(dep(35),dist(150),arr(185))).

#p_node_action(train(#b(2)),#b((3,6)),#p,(#p,#p,#b(w)),#b((11,6)),(dep(#b(33)),dist(#p),arr(#b(183)))):-node_action(train(2),(3,6),move_forward,(s,n,w),(11,6),(dep(33),dist(150),arr(183))).

#p_node_action(train(#b(2)),#b((3,6)),#p,(#p,#p,#b(w)),#b((11,6)),(dep(#b(31)),dist(#p),arr(#b(181)))):-node_action(train(2),(3,6),move_forward,(s,n,w),(11,6),(dep(31),dist(150),arr(181))).





(26,7) to (27,7) Distance = 1
#p_node_action(train(#b(1)),#b((26,7)),#p,(#p,#p,#b(n)),#b((27,7)),(dep(#b(159)),dist(#p),arr(#b(160)))):-node_action(train(1),(26,7),move_forward,(w,s,n),(27,7),(dep(159),dist(1),arr(160))).

#p_node_action(train(#b(1)),#b((26,7)),#p,(#p,#p,#b(n)),#b((27,7)),(dep(#b(161)),dist(#p),arr(#b(162)))):-node_action(train(1),(26,7),move_forward,(w,s,n),(27,7),(dep(161),dist(1),arr(162))).

#p_node_action(train(#b(1)),#b((26,7)),#p,(#p,#p,#b(n)),#b((27,7)),(dep(#b(163)),dist(#p),arr(#b(164)))):-node_action(train(1),(26,7),move_forward,(w,s,n),(27,7),(dep(163),dist(1),arr(164))).

#p_node_action(train(#b(1)),#b((26,7)),#p,(#p,#p,#b(n)),#b((27,7)),(dep(#b(165)),dist(#p),arr(#b(166)))):-node_action(train(1),(26,7),move_forward,(w,s,n),(27,7),(dep(165),dist(1),arr(166))).





Another example of this kind of thing: (why is the next_possible_node atoms generating all these different distance value? it should only be 'next_possible_node(at((21,6)),(s,n,s),move_forward,next((12,6)),(dist(9),time(9)))') and it shows that it's correct in the output if I show it (#show next_possible_node/5.)


(21,6) to (12,6) : Distance = 9
{node_action(train(1),(21,6),move_forward,(s,n,s),(12,6),(dep(151),dist(41),arr(192)))}:-#p_node_action(train(#b(1)),#b((22,6)),#p,(#p,#p,#b(s)),#b((21,6)),(dep(#b(150)),dist(#p),arr(#b(151)))),next_possible_node(at((21,6)),(s,n,s),move_forward,next((12,6)),(dist(41),time(41))).

{node_action(train(1),(21,6),move_forward,(s,n,s),(12,6),(dep(151),dist(39),arr(190)))}:-#p_node_action(train(#b(1)),#b((22,6)),#p,(#p,#p,#b(s)),#b((21,6)),(dep(#b(150)),dist(#p),arr(#b(151)))),next_possible_node(at((21,6)),(s,n,s),move_forward,next((12,6)),(dist(39),time(39))).

{node_action(train(1),(21,6),move_forward,(s,n,s),(12,6),(dep(151),dist(37),arr(188)))}:-#p_node_action(train(#b(1)),#b((22,6)),#p,(#p,#p,#b(s)),#b((21,6)),(dep(#b(150)),dist(#p),arr(#b(151)))),next_possible_node(at((21,6)),(s,n,s),move_forward,next((12,6)),(dist(37),time(37))).

{node_action(train(1),(21,6),move_forward,(s,n,s),(12,6),(dep(151),dist(35),arr(186)))}:-#p_node_action(train(#b(1)),#b((22,6)),#p,(#p,#p,#b(s)),#b((21,6)),(dep(#b(150)),dist(#p),arr(#b(151)))),next_possible_node(at((21,6)),(s,n,s),move_forward,next((12,6)),(dist(35),time(35))).

{node_action(train(1),(21,6),move_forward,(s,n,s),(12,6),(dep(151),dist(33),arr(184)))}:-#p_node_action(train(#b(1)),#b((22,6)),#p,(#p,#p,#b(s)),#b((21,6)),(dep(#b(150)),dist(#p),arr(#b(151)))),next_possible_node(at((21,6)),(s,n,s),move_forward,next((12,6)),(dist(33),time(33))).

{node_action(train(1),(21,6),move_forward,(s,n,s),(12,6),(dep(151),dist(31),arr(182)))}:-#p_node_action(train(#b(1)),#b((22,6)),#p,(#p,#p,#b(s)),#b((21,6)),(dep(#b(150)),dist(#p),arr(#b(151)))),next_possible_node(at((21,6)),(s,n,s),move_forward,next((12,6)),(dist(31),time(31))).

















Tuesday


{node_action(train(0),(32,16),move_forward,(n,s,s),(32,10),(dep(68),dist(156),arr(224)))}:-
#p_node_action(train(#b(0)),#b((31,11)),#p,(#p,#p,#b(n)),#b((32,16)),(dep(#b(22)),dist(#p),arr(#b(68)))),
next_possible_node(at((32,16)),(n,s,s),move_forward,next((32,10)),(dist(156),time(156))).

{node_action(train(0),(32,16),move_forward,(n,s,s),(32,10),(dep(70),dist(156),arr(226)))}:-
#p_node_action(train(#b(0)),#b((31,11)),#p,(#p,#p,#b(n)),#b((32,16)),(dep(#b(22)),dist(#p),arr(#b(70)))),
next_possible_node(at((32,16)),(n,s,s),move_forward,next((32,10)),(dist(156),time(156))).

{node_action(train(0),(32,16),move_forward,(n,s,s),(32,10),(dep(72),dist(156),arr(228)))}:-
#p_node_action(train(#b(0)),#b((31,11)),#p,(#p,#p,#b(n)),#b((32,16)),(dep(#b(22)),dist(#p),arr(#b(72)))),
next_possible_node(at((32,16)),(n,s,s),move_forward,next((32,10)),(dist(156),time(156))).

{node_action(train(0),(32,16),move_forward,(n,s,s),(32,10),(dep(70),dist(158),arr(228)))}:-
#p_node_action(train(#b(0)),#b((31,11)),#p,(#p,#p,#b(n)),#b((32,16)),(dep(#b(20)),dist(#p),arr(#b(70)))),
next_possible_node(at((32,16)),(n,s,s),move_forward,next((32,10)),(dist(158),time(158))).







{node_action(train(0),(32,16),move_forward,(n,s,s),(32,10),(dep(52),dist(150),arr(202)))}:-
#p_node_action(train(#b(0)),#b((31,11)),#p,(#p,#p,#b(n)),#b((32,16)),(dep(#b(22)),dist(#p),arr(#b(52)))),
next_possible_node(at((32,16)),(n,s,s),move_forward,next((32,10)),(dist(150),time(150))).

{node_action(train(0),(32,16),move_forward,(n,s,s),(32,10),(dep(54),dist(150),arr(204)))}:-
#p_node_action(train(#b(0)),#b((31,11)),#p,(#p,#p,#b(n)),#b((32,16)),(dep(#b(22)),dist(#p),arr(#b(54)))),
next_possible_node(at((32,16)),(n,s,s),move_forward,next((32,10)),(dist(150),time(150))).

{node_action(train(0),(32,16),move_forward,(n,s,s),(32,10),(dep(56),dist(150),arr(206)))}:-
#p_node_action(train(#b(0)),#b((31,11)),#p,(#p,#p,#b(n)),#b((32,16)),(dep(#b(22)),dist(#p),arr(#b(56)))),
next_possible_node(at((32,16)),(n,s,s),move_forward,next((32,10)),(dist(150),time(150))).