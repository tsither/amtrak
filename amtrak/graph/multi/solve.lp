%%%%%%% flatland multi-shot solution using weighted graph representation %%%%%%%

#script (python)
"""
Python script grounds and solves the 'graph' portion of the instances, effectively build the edges.
The edges for that instance are then passed to the main program as facts.
This 2-part multi-shot solving process greatly reduces grounding and solving times. 
"""

import clingo

def main(prg):
    instance = "/Users/mymac/Desktop/Trains/flatland/envs/lp/env_009--4_3.lp"
    #instance = "/Users/mymac/Desktop/Trains/flatland/envs/lp/env_010--4_3.lp"
    #instance =  "../test_envs/test_env_2/test_env_2.lp"

    graph = "/Users/mymac/Desktop/Trains/flatland/amtrak/graph/multi/graph.lp"
    edge_builder = "/Users/mymac/Desktop/Trains/flatland/amtrak/graph/multi/build_edges.lp"

    # First compute the edge atoms
    graph_builder = clingo.Control()
    graph_builder.load(instance)
    graph_builder.load(graph)
    graph_builder.load(edge_builder)
    graph_builder.ground([("base", [])])

    edge_atoms = []
    def on_model(model):
        nonlocal edge_atoms
        for atom in model.symbols(shown=True):
            if atom.name == "edge":
                edge_atoms.append(atom)

    graph_builder.solve(on_model=on_model)

    # Now add these edge atoms as facts to the main program
    for atom in edge_atoms:
        prg.add("base", [], str(atom) + ".")

    # Ground and solve the main program
    prg.ground([("base", [])])
    prg.solve()
#end.



#include "/Users/mymac/Desktop/Trains/flatland/envs/lp/env_009--4_3.lp".
% #include "/Users/mymac/Desktop/Trains/flatland/envs/lp/env_010--4_3.lp".
% #include "../test_envs/test_env_2/test_env_2.lp".
#include "/Users/mymac/Desktop/Trains/flatland/amtrak/graph/multi/graph.lp".




% First node action from starting node to first node
{ node_action(train(ID), Start_Node, move_forward, ("N/A", OUT_Current, IN_Next), Next_Node, (dep(Start_Time),dist(Edge_Length), arr(Start_Time + Wait_Time + Edge_Length))) : wait_time(Wait_Time)} = 1 :- 
    edge(Start_Node, Next_Node, (OUT_Current,IN_Next), Edge_Length), 
    start(ID,Start_Node,Start_Time,OUT_Current),
    Edge_Length>1.

node_action(train(ID), Start_Node, move_forward, ("N/A", OUT_Current, IN_Next), Next_Node, (dep(Start_Time),dist(1), arr(Start_Time + 1)))  :- 
    edge(Start_Node, Next_Node, (OUT_Current,IN_Next), 1), 
    start(ID,Start_Node,Start_Time,OUT_Current).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Generate next possible nodes from current position %%%%%%%%%%

% If node is a 'decision point', agent has multiple next nodes it can reach (depending on the action)
% IF LENGTH IS > 1, TRAIN CAN WAIT
next_possible_node(at(Current_Node), (IN_Current,OUT_Current,IN_Next), Action, next(Next_Node), (dist(Next_Length), time(Next_Length))) :- 

        edge(_, Current_Node, (_,IN_Current), _), 
        edge(Current_Node, Next_Node, (OUT_Current,IN_Next), Next_Length),
        Next_Length > 1,
            node(Current_Node, (IN_Current,OUT_Current)), 
            move(IN_Current, OUT_Current, Action),      % Get action if decision point
                decision_point(Current_Node,in(IN_Current)).

% IF EDGE LENGTH BETWEEN TWO NODES IS 1, NO OPTION FOR WAITING, TRAIN MUST MOVE FORWARD
next_possible_node(at(Current_Node), (IN_Current,OUT_Current,IN_Next), Action, next(Next_Node), (dist(Next_Length), time(Next_Length))) :- 

        edge(_, Current_Node, (_,IN_Current), _), 
        edge(Current_Node, Next_Node, (OUT_Current,IN_Next), Next_Length),
        Next_Length = 1,
            node(Current_Node, (IN_Current,OUT_Current)), 
            move(IN_Current, OUT_Current, Action),      % Get action if decision point
                decision_point(Current_Node,in(IN_Current)).


% agents must move forward at nodes that aren't decision points
next_possible_node(at(Current_Node), (IN_Current,OUT_Current,IN_Next), move_forward, next(Next_Node), (dist(Next_Length), time(Next_Length))) :- 

        edge(_, Current_Node, (_,IN_Current), _), 
        edge(Current_Node, Next_Node, (OUT_Current,IN_Next), Next_Length),
        Next_Length > 1,
            node(Current_Node, (IN_Current,OUT_Current)), 
            % move(IN_Current, OUT_Current, Action),
                not decision_point(Current_Node,in(IN_Current)).


next_possible_node(at(Current_Node), (IN_Current,OUT_Current,IN_Next), move_forward, next(Next_Node), (dist(Next_Length), time(Next_Length))) :- 

        edge(_, Current_Node, (_,IN_Current), _), 
        edge(Current_Node, Next_Node, (OUT_Current,IN_Next), Next_Length),
        Next_Length=1,
            node(Current_Node, (IN_Current,OUT_Current)), 
            % move(IN_Current, OUT_Current, Action),
                not decision_point(Current_Node,in(IN_Current)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Generate Node actions, precursor to 'actions' atom %%%%%%%%%%%%%%%%%%%%%%

 {node_action(train(ID), Current_Node, Action, (IN_Current,OUT_Current,IN_Next), Next_Node, (dep(Current_Time),dist(Dist), arr(Current_Time + Next_edge_time))) }  :- 

    % Get next possible nodes given current position
    next_possible_node(at(Current_Node), (IN_Current,OUT_Current,IN_Next), Action, next(Next_Node), (dist(Dist), time(Next_edge_time))),

    % Get Current_Node
    node_action(train(ID), Prev_Node, _, (_,_,IN_Current), Current_Node, (dep(Prev_time), dist(_), arr(Current_Time))), 
    
    % Get Next_Time
    end(ID,End_node,End_time),
    % Stopping condition
    Current_Time + Dist <= End_time,
    Current_Node!=End_node,
    not node_action(train(ID), End_node, _, _, _, (_,_,_)).

% There can't be two actions on the same node at the same time              ---> How to put this constraint into head of previous rule? 
:- node_action(train(ID), Current_Node, A1, _, _, (dep(Time),_,_)), node_action(train(ID), Current_Node, A2, _, _, (dep(Time),_,_)), A1!=A2.

% Two trains cant arrive on the same node at the same time
:- node_action(train(ID1), _, _, _, Next_Node, (_,_,arr(Time))), node_action(train(ID2), _, _, _, Next_Node, (_,_,arr(Time))), ID1!=ID2.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Generate 'action' atoms %%%%%%%%%%%%%%%%%%%%%%

% Different cases to create action atoms: 

% 1. Generate actions departing all nodes
% 2. Populate move_forwards from node to node if train doesn't wait
% 3. Populate move_forwards from nodes to wait_nodes if train waits at some point
% 4. Add last move_forward from wait_node to next_node if train waits
% 5. Add appropriate number of waiting actions if train waits


% Generate actions at all nodes (starting cell, ending cell, junctions)

% 1. Actions LEAVING all nodes
action(train(ID), Action, Current_Time) :- 
    % ID=0,
    node_action(train(ID), Current_Node, Action, _, Next_Node, (dep(Current_Time), dist(Dist), arr(Next_Time))),
    end(ID,End_Node,_),                     
    Current_Node!= End_Node.            
    
% 2.  Populating node to node - IF NO WAITING
action(train(ID), move_forward, T) :- 
    % ID=0,
    node_action(train(ID), Current_Node, Action, _, Next_Node, (dep(Current_Time),dist(Dist), arr(Arrival_Time))),
    Dist + Current_Time = Arrival_Time,         % implies NO WAITING
    T = Current_Time+1..Arrival_Time-1.         % Iterate over entire edge length 

% 3.  Node to wait cell - IF WAITING
action(train(ID), move_forward, T) :- 
    
    node_action(train(ID), Current_Node, Action, _, Next_Node, (dep(Current_Time),dist(Dist), arr(Arrival_Time))),
    Dist + Current_Time < Arrival_Time,         % implies WAITING   
    Start_forward = Current_Time + 1,
    End_forward = Current_Time + Dist - 2,
    T = Start_forward..End_forward.                 % Iterate from after train has left node to the distance of the wait cell

% 4. Waiting on wait cell - IF WAITING
action(train(ID), wait, T) :- 
    ID=0,
    node_action(train(ID), Current_Node, Action, _, Next_Node, (dep(Current_Time),dist(Dist), arr(Arrival_Time))),
    Current_Time + Dist < Arrival_Time,                        % implies WAITING
    End_forward = Current_Time + Dist - 2,                       % Populate wait actions between the time steps where the arrival time for that edge is greater than the Length of that edge
    T = End_forward+1..Arrival_Time-2.    

% 5.  Wait cell to node - IF WAITING
action(train(ID), move_forward, T) :- 
    ID=0,
    node_action(train(ID), Current_Node, Action, _, Next_Node, (dep(Current_Time),dist(Dist), arr(Arrival_Time))),
    Dist + Current_Time < Arrival_Time,         % implies WAITING
    T = Arrival_Time-1.                         % Must be a move_forward before arriving at next node from wait cell



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % Mark a train as arrived 
arrived(ID,Arrival_Time) :- end(ID,End_node,End_time), node_action(train(ID), _, _, _, End_node, (_,_,arr(Arrival_Time))).

% % % Trains must arrive at end station
:- not arrived(ID,_), train(ID).


% % % Mark a train as delayed if it went beyond its time horizon
% delayed(ID) :- arrived(ID,Arrival_Time), end(ID,End_node,End_time), Arrival_Time>=End_time.

% :- delayed(ID).

% #minimize{ 1: action(ID,wait,T) }.


% #show action/3.
% #show node_action/6.
% #show next_possible_node/5.
#show arrived/2.

% at_node(0,Node,Arrival_Time, Action) :- node_action(train(0),_, Action, _, Node, (_,_,arr(Arrival_Time))).
% #show edge/4.
% #show at_node/4.
% #show end/3.