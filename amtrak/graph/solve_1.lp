#include "graph_weighted.lp".
% #include "test_envs/test_env_2/test_env_2.lp".

% Vanilla flatland solution using graphs 


node_action(train(ID), Start_Node, move_forward, ("N/A", OUT_Current, IN_Next), Next_Node, (dep(Start_Time),arr(Arrival_Time))) :- 
    edge(Start_Node, Next_Node, (OUT_Current,IN_Next), L), 
    start(ID,Start_Node,Start_Time,OUT_Current),
    Arrival_Time = Start_Time + L.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Generate next possible nodes from current position %%%%%%%%%%
next_possible_node(at(Current_Node), (IN_Current,OUT_Current,IN_Next), Action, next(Next_Node)) :- 

    node_action(train(ID), _, _, (_,_,IN_Current), Current_Node, _),
        edge(_, Current_Node, (_,IN_Current), _), 
        edge(Current_Node, Next_Node, (OUT_Current,IN_Next), L),
            node(Current_Node, (IN_Current,OUT_Current)), 
            move(IN_Current, OUT_Current, Action),
                decision_point(Current_Node,in(IN_Current)).

next_possible_node(at(Current_Node), (IN_Current,OUT_Current,IN_Next), move_forward, next(Next_Node)) :- 

    node_action(train(ID), _, _, (_,_,IN_Current), Current_Node, _),
        edge(_, Current_Node, (_,IN_Current), _), 
        edge(Current_Node, Next_Node, (OUT_Current,IN_Next), L),
            node(Current_Node, (IN_Current,OUT_Current)), 
            move(IN_Current, OUT_Current, Action),
                not decision_point(Current_Node,in(IN_Current)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Generate Node actions, precursor to 'actions' atom %%%%%%%%%%%%%%%%%%%%%%

{node_action(train(ID), Current_Node, Action, (IN_Current,OUT_Current,IN_Next), Next_Node, (dep(Current_Time),arr(Next_Time))) } :- % ******* How to make this rule more efficient?
 
    % Get next possible nodes given current position
    next_possible_node(at(Current_Node), (IN_Current,OUT_Current,IN_Next), Action, next(Next_Node)),

    % Get Current_Node
    node_action(train(ID), Prev_Node, _, (_,_,IN_Current), Current_Node, (dep(Prev_time),arr(Current_Time))), 
    node(Current_Node,(IN_Current,OUT_Current)),

    % Get Next_Time
    edge(Current_Node, Next_Node, (OUT_Current,IN_Next), Next_L),
    end(ID,End_node,End_time),
    Next_Time = Current_Time + Next_L,

    % Stopping condition
    Next_Time <= End_time,
    Current_Node!=End_node.

% There can't be two actions on the same node at the same time              ---> How to put this constraint into head of previous rule? 
:- node_action(train(ID), Current_Node, A1, _, _, (dep(Time),_)), node_action(train(ID), Current_Node, A2, _, _, (dep(Time),_)), A1!=A2.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Generate 'action' atoms %%%%%%%%%%%%%%%%%%%%%%

% % Generate actions at all nodes (starting cell, ending cell, junctions)
action(train(ID), Action, Current_Time) :- node_action(train(ID), Current_Node, Action, _, Next_Node, (dep(Current_Time),arr(Next_Time))).

% Generate actions for all movements in between nodes
action(train(ID), move_forward, T) :- 
    node_action(train(ID), _, Action, _, _, (dep(Current_Time),arr(Next_Time))),
    T = Current_Time+1..Next_Time-1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Mark a train as arrived 
arrived(ID,Arrival_Time) :- end(ID,End_node,End_time), node_action(train(ID), _, _, _, End_node, (_,arr(Arrival_Time))).

% Trains must arrive at end station
:- not arrived(ID,_), train(ID).


% Mark a train as delayed if it went beyond its time horizon
delayed(ID) :- arrived(ID,Arrival_Time), end(ID,End_node,End_time), Arrival_Time>=End_time.

:- delayed(ID).



% #show action_node/3.
% #show action/3.
% #show action_test/3.
% #show node_action/6.
% #show next_possible_node/4.
% #show aaction/4.
% #show edge/4.
#show arrived/2.