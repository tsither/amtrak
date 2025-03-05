#include "pathing.lp". % This file give use 'node_action' atoms, which give us the optimal routes for each train


%%%%%%% Mark Conflicts in Schedule %%%%%%%%

% Two types of conflicts : collisions on nodes and collisions on edges...

node_collision :- ID1>ID2,               % Standard node conflict: two agents can't arrive on the same node at the same time

    node_action(train(ID1), _, _, _, Node, (_,_,arr(Arrival_Time))),  
    node_action(train(ID2), _, _, _, Node, (_,_,arr(Arrival_Time))).

node_collision :- ID1>ID2,               % Standard node conflict: two agents can't arrive on the same node at the same time

    node_action(train(ID1), _, _, _, Node, (dep(Time),_,_)),  
    node_action(train(ID2), _, _, _, Node, (dep(Time),_,_)).


% No collisions on edges
edge_collision:- 
    node_action(train(ID1), NodeA, _, _, NodeB, (dep(DepTime1),_,arr(ArrTime1))),  
    node_action(train(ID2), NodeB, _, _, NodeA, (dep(DepTime2),_,arr(ArrTime2))),  
    ID1 != ID2, 
    DepTime1 < ArrTime2, ArrTime1 > DepTime2.



% General conflict rule
conflict(edge_collision) :- edge_collision.
conflict(node_collision) :- node_collision.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%% SOLUTION %%%%%%%%%%

% % If there are no conflicts in the environment, proceed easily with suggested schedule from pathing
node_schedule(train(ID), (Current_Node, Next_Node), Action, (dep(Current_Time),dist(Dist), arr(Arrival_Time))) :- 
    node_action(train(ID), Current_Node, Action, _, Next_Node, (dep(Current_Time), dist(Dist), arr(Arrival_Time))),
    not conflict(_).

%%%%%ZZZZZZ

% First node action from starting node to first node, option to wait if edge is larger than 1, otherwise train must move forward (no waiting on nodes, ever)
{node_schedule(train(ID), (Start_Node, Next_Node), move_forward, (dep(Start_Time),dist(Dist), arr(Original_Arr_Time + Wait_Time))) : wait_time(Wait_Time) } = 1 :- 
    conflict(_),
    node_action(train(ID), Start_Node, move_forward, _, Next_Node, (dep(Start_Time),dist(Dist), arr(Original_Arr_Time))),
    start(ID,Start_Node,Start_Time,OUT_Current),
    Dist>1.

node_schedule(train(ID), (Start_Node, Next_Node), move_forward, (dep(Start_Time),dist(1), arr(Original_Arr_Time))):- 
    conflict(_),

    node_action(train(ID), Start_Node, move_forward, _, Next_Node, (dep(Start_Time),dist(1), arr(Original_Arr_Time))),
    start(ID,Start_Node,Start_Time,OUT_Current).



% Node to Node pathing - generated using shortest path (nodes taken from 'node_action'), only solving across time dimension
{ node_schedule(train(ID), (Current_Node, Next_Node), Action, (dep(Current_Node_Arr_Time),dist(Dist), arr(Original_Arr_Time + Wait_Time))) : wait_time(Wait_Time) } = 1 :- 
    conflict(_),
    node_schedule(train(ID), (_, Current_Node), _, (dep(_),dist(_), arr(Current_Node_Arr_Time))),
    node_action(train(ID), Current_Node, Action, _, Next_Node, (dep(Original_Dep_Time),dist(Dist), arr(Original_Arr_Time))).

#show node_schedule/4.
% #show node_action/6.

%%%%%ZZZZZZ

% Two trains can't be on the same node at the same time
:- node_schedule(train(ID1), (NodeA,_),_,(dep(Time),_,_)), 
   node_schedule(train(ID2), (NodeA,_),_,(dep(Time),_,_)), 
   ID1 != ID2.

% Trains can't arrive on the same node at the same time
:- node_schedule(train(ID1), (_,NodeB),_,(_,_,arr(Time))), 
   node_schedule(train(ID2), (_,NodeB),_,(_,_,arr(Time))), 
   ID1 != ID2.

% No collisions on edges
:- node_schedule(train(ID1), (NodeA,NodeB),_,(dep(DepTime1),_,arr(ArrTime1))), 
   node_schedule(train(ID2), (NodeB,NodeA),_,(dep(DepTime2),_,arr(ArrTime2))), 
   ID1 != ID2, 
   DepTime1 < ArrTime2, ArrTime1 > DepTime2.

% #show node_schedule/4.

% % Generate actions at all nodes (starting cell, ending cell, junctions)

% 1. Actions leaving nodes
% action(train(ID), Action, Current_Time) :- 
%     node_schedule(train(ID), (Current_Node, Next_Node), Action, (dep(Current_Time), dist(Dist), arr(Arrival_Time))),
%     end(ID,End_Node,_),                     
%     Current_Node!= End_Node.        


% % 2. Actions - NO WAITING
% action(train(ID), move_forward, T) :- 
%     node_schedule(train(ID), (Current_Node, Next_Node), Action, (dep(Current_Time), dist(Dist), arr(Arrival_Time))),
%     Current_Time + Dist = Arrival_Time,
%     T = Current_Time+1..Arrival_Time-2.         % Iterate over entire edge length 


% % 3.  Train needs to move forward to last node before Arrival time runs out, regardless if waiting or not
% action(train(ID), move_forward, Arrival_Time-1) :- 
%     node_schedule(train(ID), (Current_Node, Next_Node), _, (dep(Current_Time), dist(Dist), arr(Arrival_Time))).



% % 4. Actions - when trains should wait on edges
% {action(train(ID), Action, T) : edge_action(Action) } = 1 :- 
%     node_schedule(train(ID), (Current_Node, Next_Node), _, (dep(Current_Time), dist(Dist), arr(Arrival_Time))),
%     Diff = Arrival_Time - Current_Time - Dist,
%     Diff > 0,       %implying waiting needs to be done on this edge
%     T = Current_Time+1..Arrival_Time-2.         % Iterate over entire edge length -1 


% % Constraint to determine the necessary number of wait atoms on each edge!




% % Trains can't have multiple actions at same time step
% :- action(train(ID1), A1, T), action(train(ID1), A2, T), A1!=A2.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%







