%%%%%%% flatland multi-shot solution using weighted graph representation %%%%%%%

#script (python)
"""
Python script grounds and solves the 'graph' portion of the instances, effectively build the edges.
The edges for that instance are then passed to the main program as facts.
This 2-part multi-shot solving process greatly reduces grounding and solving times. 

* Required to change instance path in python script and larger file (line 54)
"""

import clingo

def main(prg):
    instance = "/Users/mymac/Desktop/Trains/flatland/envs/lp/env_025--10_3.lp"      # Choose instance

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
            #if atom.name == "edge":
                #edge_atoms.append(atom)
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


#include "/Users/mymac/Desktop/Trains/flatland/envs/lp/env_025--10_3.lp".       % Choose instance, also necessary


% Represents a train on a node and a time step, 'IN' is incoming direction, necessary for correct node transitions
at_node(train(ID),Start_Node, IN, Time+1) :- start(ID,Start_Node,Time,OUT), d(IN,OUT). % use 'd' to get incoming direction on start nodes

%% Node actions are precursor to 'actions' atom

% First node action, from start node
node_action(train(ID), Start_Node, IN, move_forward) :- start(ID,Start_Node,Time,OUT), d(IN,OUT).


% Can only wait if edge is greater than 1 (NO WAITING ON NODES)
at_node(train(ID), Current_Node, IN_Current, Current_Time ) :- 

    at_node(train(ID), Prev_Node, IN_Prev, Prev_Time),  Current_Time = Prev_Time + 1,

    node_action(train(ID), Prev_Node, IN_Prev, Action),

    end(ID,End_Node,End_time),
    Current_Time <= End_time,
    next_possible_node(at(Prev_Node), (IN_Prev,OUT_Prev,IN_Current), Action, next(Current_Node), dist(1)).


% Allowed to wait if edge > 1
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


% Two trains can't be on the same node at once
node_collision :- ID1>ID2,               
    at_node(train(ID1), Current_Node, _, Current_Time),
    at_node(train(ID2), Current_Node, _, Current_Time).

% % Trains can't overlap on edges, causes collision
edge_collision :- ID1 != ID2,
    at_node(train(ID1), NodeA, IN_A_1, DepTime1),   
    at_node(train(ID1), NodeB, IN_B_1, ArrTime1),

    at_node(train(ID2), NodeB, IN_B_2, DepTime2),
    at_node(train(ID2), NodeA, IN_A_2, ArrTime2),

    node_action(train(ID1), NodeA, IN_A_1, Action1),
    node_action(train(ID2), NodeB, IN_B_2, Action2),

    next_possible_node(at(NodeA), (IN_A_1,_,_), Action1, next(NodeB), dist(Dist)),
    next_possible_node(at(NodeB), (IN_B_2,_,_), Action2, next(NodeA), dist(Dist)),

    DepTime1 < ArrTime2,
    DepTime2 < ArrTime1.


:- node_collision.
% :- edge_collision.        % enforcing edge collisions leads to grounding explosion on real Flatland environments

% Trains must arrive at end station
:- not arrived(ID,_), train(ID).

:- delayed(ID).

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
