% #include "../graph_weighted_wait.lp".
% #include "../test_envs/test_env_2/test_env_2.lp".
% #include "/Users/mymac/Desktop/Trains/flatland/amtrak/environments/lp/env_01.lp".

#script (python)
import clingo

def main(prg):
    instance = "/Users/mymac/Desktop/Trains/flatland/envs/lp/env_009--4_3.lp"
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
#include "/Users/mymac/Desktop/Trains/flatland/amtrak/graph/multi/graph.lp".

%%%%%%% Paths %%%%%%%%
% begin condition for recursive case, S is start node, F is end node, (S,A) is intermediate steps
path_step(ID, 1, (S,F), (S, A), L) :- 
    start(ID,S,_,OUT), end(ID,F,_), edge( S, A, (OUT,_), L). % Train must go in direction its facing.


path_step(ID, INDEX, (S,F), (B, C), TL) :-     % (B,C) represents intermediate nodes on the way to the (F)inish node
    end(ID,_,ET),
    not TL>=ET,         %stopping condition, TL can't be more steps than the end time step T
    path_step(ID, PREV_IDX, (S,F),(A, B), L1),      % Retrieve previous path
    not path_step(ID, _, (S,F),(C, B),_),           % Path step doesnt already exist for this edge reversed
    edge(A, B, (_,IN_B), _),        
    edge(B,C,(OUT_B,_),L2),                                 % If edge exists in this next path_step
    INDEX=PREV_IDX+1,   % update index
    F!=B,                                           % Ensure stop condition on train's 'end' cell
    TL=L1+L2,           % update total path length 
    node(B,(IN_B,OUT_B)).   %the intermediate node 'B' that connects edges A and C MUST have the correct connection to connect A and C!


    
path(ID, (S, F), (A), L) :- 
    start(ID,S,_,OUT), end(ID,F,_), edge( S, A, (OUT,_), L). % Train must go in direction its facing.


% path(ID, (S, F), (A,B), L1+L2) :- 
%     path(ID, (S, F), (A), L1),
%     edge( S, A, (_,IN), L1),
%     edge( A, B, (OUT,_), L2),
%     node(A,(IN,OUT)).

% #show path_step/5.
#show path/4.

% #show arrived/2.