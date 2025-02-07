
% #include "test_envs/test_env_1/test_env_1.lp".
#include "graph/test_envs/test_env_2/test_env_2.lp".
#include "graph/track_option.lp".



%count all cells in environment
cell_count(C) :- C = #count{ XY: cell((XY), Track), Track != 0}.

% define nodes
node((X,Y)) :- cell((X,Y),Track), node_track(Track).    % Nodes are tracks that contain switches
node((X,Y)) :- start(_,(X,Y),_,_).                      % Nodes are start and ends points of trains
node((X,Y)) :- end(_,(X,Y),_).

% Links connect adjacent tracks
link((X1,Y),(X2,Y)) :- option((X1,Y),(_,_,s)), option((X2,Y),(s,_,_)), X2 = X1 + 1.
link((X,Y1),(X,Y2)) :- option((X,Y1),(_,_,e)), option((X,Y2),(e,_,_)), Y2 = Y1 + 1.
link((X,Y1),(X,Y2)) :- option((X,Y1),(_,_,w)), option((X,Y2),(w,_,_)), Y2 = Y1 - 1.
link((X1,Y),(X2,Y)) :- option((X1,Y),(_,_,n)), option((X2,Y),(n,_,_)), X2 = X1 - 1.

cell_count(C) :- C = #count{ XY: cell((XY), Track), Track != 0}.

%%%%%%% Build edges from graph %%%%%%%
% Path steps connect links between paths
edge_step(A, A, B, 1) :- 
    link(A, B), 
    node(A).

% N is starting node, A, B are the cells in the path at each step
edge_step(N, B, C, L) :-
    link(B, C),
    edge_step(N, A, B, L1),
    not edge_step(N, C, B, _),
    not node(B),
    L=L1+1,
    L <= CC,
    cell_count(CC).

% A path is a connection between two nodes
edge(A, B, L) :-        %changed from 'path' to 'edge'
    edge_step(A, _, B, L),
    node(A),
    node(B).


%%%%%%% Build paths for each agent from edges %%%%%%%
path_step(ID, (S,F), S, A, L) :- start(ID,S,_,_), end(ID,F,_), edge(S,A,L), not edge(S,F,_).

path_step(ID, (S,F), B, C, TL) :- 
    path_step(ID, (S,F), A, B, L1),
    not path_step(ID, (S,F), C, B,_),  % path step doesnt already exist for this edge  
    edge(B,C,L2),
    F!=B,               % make sure you stop at the end node
    TL=L1+L2,
    cell_count(CC),
    TL<=CC.

path(ID,S,F,L) :- path_step(ID, (S,F), _, F, L).



%%%%%%%%%%%%%% First path issue %%%%%%%%%%%%%%
%Train starts on node, two paths from there, only 1 should be possible
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% surrounding_tracks(node(A),N) :- link(A,N), node(A).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%% Inside Nodes %%%%%%%%%%%%%%
% Map paths within nodes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inside_node(node((X,Y)), (NS,EW,NE,ES,SW,WN)) :- node((X,Y)), 
    connection(Track,NS,EW,NE,ES,SW,WN), cell((X,Y),Track).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% % Graph density %
% num_edges(D) :- D = #count { X,Y: edge(X,Y) }.
% num_nodes(N) :- N= #count { X : node((X)) }.

% density(D) :- num_edges(E), num_nodes(N), V1 = (1000*E), V2 = N*(N-1), D = V1 / V2.




% #show density/1.
% #show num_edges/1.
% #show num_nodes/1.

#show path/4.
