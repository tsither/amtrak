% #include "test_envs/test_env_2/test_env_2.lp".
#include "track_option.lp".

% Next step: 
% - Observe how pathing scales up
% - Double check edge still scales
% - Include some time measuring device
% - Build simple solution for flatland using actions


% Grid circle_complex
cell((0,0), 16386).
cell((1,0), 32800).
cell((2,0), 72).

cell((0,1), 17411).
cell((1,1), 32800).
cell((2,1), 3089).

cell((0,2), 4608).
cell((1,2), 32800).
cell((2,2), 2064).

train(1).
start(1,(1,0),0,n).
end(1,(0,2),6).


 
% connection(Track,NS,EW,NE,ES,SW,WN), cell((X,Y),Track).

%%%% links %%%%%
% Connect adjacent cells to one another, includes outgoing and incoming directions (n,e,s,w)
link((X1,Y),(X2,Y),(n,s)) :- option((X1,Y),(_,_,n)), option((X2,Y),(n,_,_)), 
    X2 = X1 - 1.

link((X,Y1),(X,Y2),(e,w)) :- option((X,Y1),(_,_,e)), option((X,Y2),(e,_,_)), 
    Y2 = Y1 + 1.

link((X1,Y),(X2,Y),(s,n)) :- option((X1,Y),(_,_,s)), option((X2,Y),(s,_,_)), 
    X2 = X1 + 1.

link((X,Y1),(X,Y2),(w,e)) :- option((X,Y1),(_,_,w)), option((X,Y2),(w,_,_)), 
    Y2 = Y1 - 1.

%%%% edges %%%%%
% Connects nodes together, where nodes are start and end positions of agents and switch tracks

% Build edge steps into edges
% N = start node; OUT = outgoing direction from that edge; B = next cell on edge; IN = Incoming direction to B
edge_step((N,OUT), N, B, IN, 1) :- % Cells adjacent to nodes (Length of 1)
    link(N, B, (OUT,IN)),   % for all links that exit a node, create a step
    node(N,_).

% N is starting node, A, B are the cells on the edge at each step, IN is direction into cell C
edge_step((N,OUT), B, C, IN, L) :- 
    edge_step((N,OUT), A, B, _, L1),        % retrieve previous edge step
    link(B, C, (_,IN)),
    not edge_step((N,OUT), C, B, _, _),     
    not node(B,_),  
    L=L1+1,                         % adjust total length
    L <= CC,                    % include hard stop 
    cell_count(CC). 

% Create an edge from successfully built edge steps 
edge(S, F, (OUT,IN), L) :-       % S = start node ; F = end node ; OUT = outgoing direction of start node; IN = incoming direction to end node; L = length of node
    edge_step((S,OUT), _, F, IN, L).



%%%% Paths %%%%
% begin condition for recursive case, S is start node, F is end node, (S,A) is intermediate steps
path_step(ID, 1, (S,F), (S, A), L) :- 
    start(ID,S,_,OUT), end(ID,F,_), edge( S, A, (OUT,_), L). % Train must go in direction its facing.


path_step(ID, INDEX, (S,F), (B, C), TL) :-     % (B,C) represents intermediate nodes on the way to the (F)inish node
    path_step(ID, PREV_IDX, (S,F),(A, B), L1),      % Retrieve previous path
    not path_step(ID, _, (S,F),(C, B),_),           % Path step doesnt already exist for this edge reversed
    edge(A, B, (_,IN_B), _),        
    edge(B,C,(OUT_B,_),L2),                                 % If edge exists in this next path_step
    INDEX=PREV_IDX+1,   % update index
    F!=B,                                           % Ensure stop condition on train's 'end' cell
    TL=L1+L2,           % update total path length 
    node(B,(IN_B,OUT_B)),   %the intermediate node 'B' that connects edges A and C MUST have the correct connection to connect A and C!
    cell_count(CC),
    TL<=CC.             % Hard code a stopping condition


path(ID,(S,F),L) :- path_step(ID, _, (S,F), (_, F), L).

#show path/3.
% #show path_step/5.
#show bad_connection/3.

