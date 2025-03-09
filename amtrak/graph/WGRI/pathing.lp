
% This file is an intermediary that calculates the possible paths and the shortest paths for each train to their respective destinations

#script (python)
"""
Build graph representation of flatland instance in isolated environment. 
Send graph representation in the form of 'next_possible_node' atoms to main lp file for further operation.

* Required to change instance path in python script and larger file (line 54)

"""

import clingo

def main(prg):
    
    instance = "/Users/mymac/Desktop/Trains/flatland/envs/lp/env_009--4_3.lp"      # Choose instance

    graph = "/Users/mymac/Desktop/Trains/flatland/amtrak/graph/multi/graph.lp"                  # Required
    edge_builder = "/Users/mymac/Desktop/Trains/flatland/amtrak/graph/multi/build_edges.lp"     # Required

    # First compute the edge atoms
    graph_builder = clingo.Control()
    graph_builder.load(instance)
    graph_builder.load(graph)
    graph_builder.load(edge_builder)
    graph_builder.ground([("base", [])])

    edge_atoms = []
    npn_atoms = []
    def on_model(model):
        nonlocal edge_atoms
        nonlocal npn_atoms
        for atom in model.symbols(shown=True):
            if atom.name == "edge":
                edge_atoms.append(atom)
            if atom.name == "next_possible_node":
                npn_atoms.append(atom)

    graph_builder.solve(on_model=on_model)

    # Now add these edge atoms as facts to the main program
    for atom in edge_atoms:
        prg.add("base", [], str(atom) + ".")
    
    for npn in npn_atoms:
        prg.add("base", [], str(npn) + ".")

    # Ground and solve the main program
    prg.ground([("base", [])])
    prg.solve()
#end.

#include "/Users/mymac/Desktop/Trains/flatland/envs/lp/env_009--4_3.lp".         % Choose instance, also necessary


%%%%%%% Paths %%%%%%%%
% begin condition for recursive case, S is start node, F is end node, (S,A) is intermediate steps


path_step(ID, 1, (S,F), IN_Next,(S, A), L) :- 
    start(ID,S,_,OUT_Current), end(ID,F,_),  % Train must go in direction its facing.
    next_possible_node(at(S), (_,OUT_Current,IN_Next), _, next(A), (dist(L))).



path_step(ID, INDEX, (S,F), IN_Next, (B, C), TL) :-     % (B,C) represents intermediate nodes on the way to the (F)inish node
    end(ID,_,ET),
    not TL>=ET,         %stopping condition, TL can't be more steps than the end time step T
    path_step(ID, PREV_IDX, (S,F), IN_Current, (A, B), L1),      % Retrieve previous path
    % not path_step(ID, _, _, (S,F),(C, B),_),           % Path step doesnt already exist for this edge reversed

        next_possible_node(at(B), (IN_Current,_,IN_Next), _, next(C), (dist(L2))),

    INDEX=PREV_IDX+1,   % update index
    F!=B,                                           % Ensure stop condition on train's 'end' cell
    TL=L1+L2.          % update total path length 



path(ID, (S, F), IN, L) :- path_step(ID, INDEX, (S,F), IN, (_, F), L).


% Calculate the shortest possible path length for each train
shortest_path_length(ID,S,L) :- path(ID,S,_,L), L = #min { Length : path(ID,_,_,Length) }.



%%%%%% GENERATE SHORTEST PATHS FOR EACH TRAIN %%%%%%%

% First node action from starting node to first node
node_action(train(ID), Start_Node, move_forward, ("N/A", OUT_Current, IN_Next), Next_Node, (dep(Start_Time),dist(Edge_Length), arr(Start_Time +  Edge_Length))) :- 
    edge(Start_Node, Next_Node, (OUT_Current,IN_Next), Edge_Length), 
    start(ID,Start_Node,Start_Time,OUT_Current).

% Node to Node path creation
{node_action(train(ID), Current_Node, Action, (IN_Current,OUT_Current,IN_Next), Next_Node, (dep(Current_Time),dist(Next_Length), arr(Current_Time + Next_Length)))} :- 

    % Get next possible nodes given current position
    next_possible_node(at(Current_Node), (IN_Current,OUT_Current,IN_Next), Action, next(Next_Node), (dist(Next_Length))),

    % Get Current_Node & incoming direction
    node_action(train(ID), Prev_Node, _, (_,_,IN_Current), Current_Node, (dep(Prev_time), dist(_), arr(Current_Time))), 
    
    % Get Next_Time
    start(ID,_,Start_Time,_),
    end(ID,End_node,End_time),

    shortest_path_length(ID,_,Shortest),

     % Stopping condition
    Current_Time + Next_Length <= Shortest + Start_Time,       % To ensure this is the shortest path, the time can't be over the previously calculated shortest path length 
    Current_Node!=End_node,
    not node_action(train(ID), End_node, _, _, _, (_,_,_)).

% There can't be two actions on the same node at the same time              
:- node_action(train(ID), Current_Node, A1, _, _, (dep(Time),_,_)), node_action(train(ID), Current_Node, A2, _, _, (dep(Time),_,_)), A1!=A2.

% Mark a train as arrived 
arrived(ID,Arrival_Time) :- end(ID,End_node,End_time), node_action(train(ID), _, _, _, End_node, (_,_,arr(Arrival_Time))).

% Trains must arrive at end station
:- not arrived(ID,_), train(ID).

