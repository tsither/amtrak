
% #include "/Users/mymac/Desktop/Trains/flatland/envs/lp/env_009--4_3.lp".
% #include "graph.lp".

%%%%%%%% edges %%%%%%%%%
% Connects nodes together, where nodes are 1. start and 2. end positions of agents and 3. switch tracks
node(A,B) :- node(A,B).
% Build edge steps into edges
% N = start node; OUT = outgoing direction from that edge; B = next cell on edge; IN = Incoming direction to B
edge_step((N,OUT), N, B, IN, 1) :- % Cells adjacent to nodes (Length of 1)
    link(N, B, (OUT,IN)),   % for all links that exit a node, create a step
    node(N,_),
    N!=B.
    % node(N).

% N is starting node, A, B are the cells on the edge at each step, IN is direction into cell C
edge_step((N,OUT), B, C, IN, L) :- 
    edge_step((N,OUT), A, B, _, L1),        % retrieve previous edge step
    link(B, C, (_,IN)),
    not edge_step((N,OUT), C, B, _, _),     
    not node(B,_), 
    % not node(B), 
    L=L1+1,                         % adjust total length
    L <= CC,                    % include hard stop 
    B!=C,
    cell_count(CC). 

% Create an edge from successfully built edge steps 
edge(S, F, (OUT,IN), L) :-       % S = start node ; F = end node ; OUT = outgoing direction of start node; IN = incoming direction to end node; L = length of node
    edge_step((S,OUT), _, F, IN, L), 
    node(F,_),
    S!=F.

#show edge/4.