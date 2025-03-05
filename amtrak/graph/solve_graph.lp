#include "../graph.lp".
#include "../build_edges.lp".
% #include "../test_envs/custom_test3.lp".
#include "../test_envs/test_env_2/test_env_2.lp".
% #include "/Users/mymac/Desktop/Trains/flatland/envs/lp/env_009--4_3.lp".
% #include "/Users/mymac/Desktop/Trains/flatland/envs/lp/env_010--4_3.lp".


%%%%%%% flatland solution using weighted graph representation %%%%%%%



%%%%%%%%%%%%%%%%%%%%% Generate Node actions, precursor to 'actions' atom %%%%%%%%%%%%%%%%%%%%%%



wait_time(0).
wait_time(1).
% wait_time(2).
% wait_time(3).
% wait_time(4).
% wait_time(6).
% wait_time(8).
% wait_time(10).
d(s,n).
d(n,s).
d(e,w).
d(w,e).

% Represents a train on a node and a time step, 'IN' is incoming direction, necessary for correct node transitions
at_node(train(ID),Start_Node, IN, Time+1) :- start(ID,Start_Node,Time,OUT), d(IN,OUT).

node_action(train(ID), Start_Node, IN, move_forward) :- start(ID,Start_Node,Time,OUT), d(IN,OUT).



% Can only wait if edge is greater than 1
at_node(train(ID), Current_Node, IN_Current, Current_Time ) :- 

    at_node(train(ID), Prev_Node, IN_Prev, Prev_Time),  Current_Time = Prev_Time + 1,

    node_action(train(ID), Prev_Node, IN_Prev, Action),

    end(ID,End_Node,End_time),
    Current_Time <= End_time,
    next_possible_node(at(Prev_Node), (IN_Prev,OUT_Prev,IN_Current), Action, next(Current_Node), dist(1)).



% Can only wait if edge is greater than 1
{at_node(train(ID), Current_Node, IN_Current, Current_Time + Wait_Time) : wait_time(Wait_Time) } = 1 :- 

    % Retrieve previous time
    at_node(train(ID), Prev_Node, IN_Prev, Prev_Time),  Current_Time = Prev_Time + Dist,

    % Previous node action maps us to 'next_possible_node' lookup table
    node_action(train(ID), Prev_Node, IN_Prev, Action),
    Dist>1,
    end(ID,End_Node,End_time),
    Current_Time <= End_time,

    % Transition function or lookup table, give us distance of previous edge
    next_possible_node(at(Prev_Node), (IN_Prev,OUT_Prev,IN_Current), Action, next(Current_Node), dist(Dist)).


% Trains can choose only 1 action of possible available actions on each node
{ node_action(train(ID), Current_Node, IN_Current, Action) : next_possible_node(at(Current_Node), (IN_Current,_,_), Action, next(_), dist(Dist)) } = 1 :-  

    at_node(train(ID), Current_Node, IN_Current, Current_Time),
    end(ID,End_Node,End_time),
    Current_Node!=End_Node,
    Current_Time < End_time.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Necessary Constraints %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Mark a train as arrived 
arrived(ID,Arrival_Time) :- end(ID,End_Node,End_time), at_node(train(ID),End_Node,_,Arrival_Time).

% Mark a train as delayed if it went beyond its time horizon
delayed(ID) :- arrived(ID,Arrival_Time), end(ID,_,End_time), Arrival_Time>End_time.


% Two types of conflicts : 'collisions' on nodes and on edges...
% Two trains can't be on the same node at once
node_collision :- ID1>ID2,               
    at_node(train(ID1), Current_Node, _, Current_Time),
    at_node(train(ID2), Current_Node, _, Current_Time).


% No collisions on edges
edge_collision :- ID1 != ID2, 

    at_node(train(ID1), NodeA, IN_A_1, Dep_Time_1),
    at_node(train(ID1), NodeB, IN_B_1, Arr_Time_1),

    node_action(train(ID1), NodeA, IN_B_1, Action1),

    next_possible_node(at(NodeA), (IN_A_1,_,IN_B_1), Action1, next(NodeB), dist(Dist)),
    
    at_node(train(ID2), NodeB, IN_B_2, Dep_Time_2),
    at_node(train(ID2), NodeA, IN_A_2, Arr_Time_2),

    node_action(train(ID2), NodeB, IN_B_1, Action2),

    next_possible_node(at(NodeB), (IN_B_2,_,IN_A_2), Action2, next(NodeA), dist(Dist)),

    % Dep_Time_1 < Arr_Time_2,
    % Arr_Time_1 > Dep_Time_2.

    Dep_Time_1 < Arr_Time_2,
    Dep_Time_2 < Arr_Time_1.


% :- node_collision.
% :- edge_collision.

% Trains must arrive at end station
:- not arrived(ID,_), train(ID).

% :- delayed(ID).

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






























% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%% Generate 'action' atoms %%%%%%%%%%%%%%%%%%%%%%


% % 1. Actions LEAVING all nodes
% action(train(ID), Action, Current_Time) :- 
%     node_action(train(ID), (Current_Node,Next_Node), Action, _, (dep(Current_Time), _, _)),
%     end(ID,End_Node,_),                     
%     Current_Node!= End_Node.    

% #show action/3.




% % 2.  Populating node to node - IF NO WAITING
% action(train(ID), move_forward, T) :- 
%     node_action(train(ID), Current_Node, Action, _, Next_Node, (dep(Current_Time),dist(Dist), arr(Arrival_Time))),
%     Dist + Current_Time = Arrival_Time,         % implies NO WAITING
%     T = Current_Time+1..Arrival_Time-1.         % Iterate over entire edge length 

% % 3.  Node to wait cel




% { edge_time(train(ID), (NodeA,NodeB), time(Dist + T)) : wait_time(T) } = 1:- 
%     next_possible_node(at(NodeA), _, _, next(NodeB), (dist(Dist))),
%     % next_possible_node(at(NodeB), _, _, next(NodeA), (dist(Dist))),

%     train(ID).


% :- edge_time(train(ID), (NodeA,NodeB), time(Edge_Time1)), edge_time(train(ID), (NodeB,NodeA), time(Edge_Time2)), Edge_Time1>Edge_Time2, 
%     next_possible_node(at(NodeA), _, _, next(NodeB), (dist(Dist))), next_possible_node(at(NodeB), _, _, next(NodeA), (dist(Dist))).


