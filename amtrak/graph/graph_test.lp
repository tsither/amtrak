#include "test_envs/test_env_2/test_env_2.lp".
#include "track_option.lp".

% Next step: 
% - Observe how pathing scales up
% - Include some time measuring device
% - Build simple solution for flatland using actions

 
% connection(Track,NS,EW,NE,ES,SW,WN), cell((X,Y),Track).

%%%% links %%%%%
% Connect adjacent cells to one another, includes outgoing and incoming directions (n,e,s,w)
% NOTE: the directions in the links (e.g. (s,n)) denote on what cardinal end of the cell connects (for link(Cell_1),(Cell_2),(s,n))(s,n) the south point of cell 1 is connected to the north point of cell 2)

link((X1,Y),(X2,Y),(s,n)) :- 
    connection(Track_s, A1, _, _, B1, C1, _), 1{A1=1;B1=1;C1=1}, % Contains south point
    connection(Track_n, A2, _, B2, _, _, C2), 1{A2=1;B2=1;C2=1}, % Contains north point
    cell((X1,Y),Track_s), cell((X2,Y),Track_n),
    X1 = X2 - 1.

link((X2,Y),(X1,Y),(n,s)) :- link((X1,Y),(X2,Y),(s,n)).   % Reverse, if s/n connection exists, then n/s connection exists between adjacent cells

link((X,Y1),(X,Y2),(e,w)) :- 
    connection(Track_e, _, A1, B1, C1, _, _), 1{A1=1;B1=1;C1=1},          %  contains east point
    connection(Track_w, _, A2, _, _, B2, C2), 1{A2=1;B2=1;C2=1},          %  contains west point
    cell((X,Y1),Track_e),cell((X,Y2),Track_w),
    Y1 = Y2 - 1.

link((X,Y2),(X,Y1),(w,e)) :- link((X,Y1),(X,Y2),(e,w)).     % Reverse


%%%%%%%% edges %%%%%%%%%
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
    edge_step((S,OUT), _, F, IN, L), node(F,_).


%%%%%%%% Paths %%%%%%%%
% begin condition for recursive case, S is start node, F is end node, (S,A) is intermediate steps
% path_step(ID, 1, (S,F), (S, A), L) :- 
%     start(ID,S,_,OUT), end(ID,F,_), edge( S, A, (OUT,_), L). % Train must go in direction its facing.


% path_step(ID, INDEX, (S,F), (B, C), TL) :-     % (B,C) represents intermediate nodes on the way to the (F)inish node
%     end(ID,_,ET),
%     not TL>=ET,         %stopping condition, TL can't be more steps than the end time step T
%     path_step(ID, PREV_IDX, (S,F),(A, B), L1),      % Retrieve previous path
%     not path_step(ID, _, (S,F),(C, B),_),           % Path step doesnt already exist for this edge reversed
%     edge(A, B, (_,IN_B), _),        
%     edge(B,C,(OUT_B,_),L2),                                 % If edge exists in this next path_step
%     INDEX=PREV_IDX+1,   % update index
%     F!=B,                                           % Ensure stop condition on train's 'end' cell
%     TL=L1+L2,           % update total path length 
%     node(B,(IN_B,OUT_B)).   %the intermediate node 'B' that connects edges A and C MUST have the correct connection to connect A and C!
%     % cell_count(CC),
%     % TL<=CC.             % Hard code a stopping condition


% path(ID,(S,F),L) :- path_step(ID, _, (S,F), (_, F), L).

% #show path/3.
% #show link/3.
#show edge/4.
% #show edge_step/5.
% #show path_step/5.
% #show bad_connection/3.

