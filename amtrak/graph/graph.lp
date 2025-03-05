% #include "../test_envs/test_env_2/test_env_2.lp".
% #include "/Users/mymac/Desktop/Trains/flatland/envs/lp/env_009--4_3.lp".
% #include "/Users/mymac/Desktop/Trains/flatland/amtrak/graph/saved_outputs/test_custom.lp".
% #include "build_edges.lp".


% This file builds a weighted graph from a flatland environment .lp

% each track ID is given a set of connections
% connection(ID, N/S, W/E, N/E, E/S, S/W, W/N)

% Track Type 1 - Straight
connection(32800,   1, 0, 0, 0, 0, 0).  % north to south
connection(1025,    0, 1, 0, 0, 0, 0).  % west to east

% Track Type 8 - Curve
connection(4608,    0, 0, 0, 0, 1, 0).  % south to west    
connection(16386,   0, 0, 0, 1, 0, 0).  % east to south
connection(72,      0, 0, 1, 0, 0, 0).  % north to east
connection(2064,    0, 0, 0, 0, 0, 1).  % west to north

% Track Type 2 - Simple switch (left)
connection(37408,   1, 0, 0, 0, 1, 0).
connection(17411,   0, 1, 0, 1, 0, 0).
connection(32872,   1, 0, 1, 0, 0, 0).
connection(3089,    0, 1, 0, 0, 0, 1).

% Track Type 9 - Simple switch (right)
connection(49186,   1, 0, 0, 1, 0, 0).
connection(1097,    0, 1, 1, 0, 0, 0).
connection(34864,   1, 0, 0, 0, 0, 1).
connection(5633,    0, 1, 0, 0, 1, 0).

% Track Type 3 - Diamond crossing
connection(33825,   1, 1, 0, 0, 0, 0).

% Track Type 4 - Single-slip switch
connection(38433,   1, 1, 0, 0, 1, 0).
connection(50211,   1, 1, 0, 1, 0, 0).
connection(33897,   1, 1, 1, 0, 0, 0).
connection(35889,   1, 1, 0, 0, 0, 1).

% Track Type 5 - Double-slip switch
connection(38505,   1, 1, 1, 0, 1, 0).
connection(52275,   1, 1, 0, 1, 0, 1).

% Track Type 6 - Symmetrical switch
connection(20994,   0, 0, 0, 1, 1, 0).
connection(16458,   0, 0, 1, 1, 0, 0).
connection(2136,    0, 0, 1, 0, 0, 1).
connection(6672,    0, 0, 0, 0, 1, 1).

cell_count(C) :- C = #count{ XY: cell((XY), Track), Track != 0}.



%%%% links %%%%%
% Connect adjacent cells to one another, includes outgoing and incoming directions (n,e,s,w)
% NOTE: the directions in the links (e.g. (s,n)) denote on what cardinal end of the cell connects (for link(Cell_1),(Cell_2),(s,n))(s,n) the south point of cell 1 is connected to the north point of cell 2)

link((X1,Y),(X2,Y),(s,n)) :- 
    connection(Track_s, A1, _, _, B1, C1, _), 
    1{A1=1;B1=1;C1=1}, % Contains south point
    % A1+B1+C1>0,
    connection(Track_n, A2, _, B2, _, _, C2), 
    1{A2=1;B2=1;C2=1}, % Contains north point
    % A2+B2+C2>0,
    cell((X1,Y),Track_s), cell((X2,Y),Track_n),
    X1 = X2 - 1.

link((X2,Y),(X1,Y),(n,s)) :- link((X1,Y),(X2,Y),(s,n)).   % Reverse, if s/n connection exists, then n/s connection exists between adjacent cells

link((X,Y1),(X,Y2),(e,w)) :- 
    connection(Track_e, _, A1, B1, C1, _, _), 1{A1=1;B1=1;C1=1},          %  contains east point
    connection(Track_w, _, A2, _, _, B2, C2), 1{A2=1;B2=1;C2=1},          %  contains west point
    cell((X,Y1),Track_e),cell((X,Y2),Track_w),
    Y1 = Y2 - 1.

link((X,Y2),(X,Y1),(w,e)) :- link((X,Y1),(X,Y2),(e,w)), Y1!=Y2.     % Reverse



%%%%%%%%%%%%% Misc Tools %%%%%%%%%%%%%

actions(move_forward).
actions(move_left).
actions(move_right).

edge_action(wait).
edge_action(move_forward).

move(s, w, move_left).
move(w, n, move_left).
move(n, e, move_left).            
move(e, s, move_left).

move(s,e, move_right).
move(e,n, move_right).
move(n,w, move_right).
move(w,s, move_right).

move(s,n, move_forward).
move(w,e, move_forward).
move(e,w, move_forward).
move(n,s, move_forward).


% wait_time(0).
% wait_time(1).
% wait_time(2).
% wait_time(3).
% wait_time(4).
% wait_time(6).
% wait_time(8).
% wait_time(10).

%%%%%%%%%%%%% Misc Tools %%%%%%%%%%%%%



%                             connection(ID, N/S, W/E, N/E, E/S, S/W, W/N)

% Mark all locations on environment where a decision can be made
decision_point(Node,in(n)) :- connection(T, A, B, C, D, E, F), A + C + F > 1, cell(Node,T).

decision_point(Node,in(e)) :- connection(T, A, B, C, D, E, F), B + C + D > 1, cell(Node,T).

decision_point(Node,in(s)) :- connection(T, A, B, C, D, E, F), A + D + E > 1, cell(Node,T).

decision_point(Node,in(w)) :- connection(T, A, B, C, D, E, F), B + E + F > 1, cell(Node,T).


node_track(T) :- connection(T, A, B, C, D, E, F), 2{A=1;B=1;C=1;D=1;E=1;F=1}, T!=33825.

%                                                 connection(ID, N/S, W/E, N/E, E/S, S/W, W/N)
node( N, (n, s)) :- cell(N,Track), node_track(Track), connection(Track, 1, _, _, _, _, _).
node( N, (w, e)) :- cell(N,Track), node_track(Track), connection(Track, _, 1, _, _, _, _).
node( N, (n, e)) :- cell(N,Track), node_track(Track), connection(Track, _, _, 1, _, _, _).
node( N, (e, s)) :- cell(N,Track), node_track(Track), connection(Track, _, _, _, 1, _, _).
node( N, (s, w)) :- cell(N,Track), node_track(Track), connection(Track, _, _, _, _, 1, _).
node( N, (w, n)) :- cell(N,Track), node_track(Track), connection(Track, _, _, _, _, _, 1).

node( N, (n, s)) :- cell(N,Track), start(_,N,_,_), connection(Track, 1, _, _, _, _, _).
node( N, (w, e)) :- cell(N,Track), start(_,N,_,_), connection(Track, _, 1, _, _, _, _).
node( N, (n, e)) :- cell(N,Track), start(_,N,_,_), connection(Track, _, _, 1, _, _, _).
node( N, (e, s)) :- cell(N,Track), start(_,N,_,_), connection(Track, _, _, _, 1, _, _).
node( N, (s, w)) :- cell(N,Track), start(_,N,_,_), connection(Track, _, _, _, _, 1, _).
node( N, (w, n)) :- cell(N,Track), start(_,N,_,_), connection(Track, _, _, _, _, _, 1).

node( N, (n, s)) :- cell(N,Track), end(_,N,_), connection(Track, 1, _, _, _, _, _).
node( N, (w, e)) :- cell(N,Track), end(_,N,_), connection(Track, _, 1, _, _, _, _).
node( N, (n, e)) :- cell(N,Track), end(_,N,_), connection(Track, _, _, 1, _, _, _).
node( N, (e, s)) :- cell(N,Track), end(_,N,_), connection(Track, _, _, _, 1, _, _).
node( N, (s, w)) :- cell(N,Track), end(_,N,_), connection(Track, _, _, _, _, 1, _).
node( N, (w, n)) :- cell(N,Track), end(_,N,_), connection(Track, _, _, _, _, _, 1).

node( N , (B,A)) :- node ( N , (A,B)).


%%%%%%%%%%%%% Wait nodes %%%%%%%%%%%%%
% cells that are adjacent to real nodes that allows 'wait' actions
wait_node( cell(Cell), D, node(Node)) :- node(Node,_), link(Node,Cell,(D,_)), not node(Cell,_).





% n_nodes(N) :- N = #count{Node : node(Node, _)}.
% n_edges_total(N) :- N = #count{S,F:edge(S,F,_,L)}.
% density(D) :- n_edges_total(E), n_nodes(N), D = ((100 * E) / (N * (N - 1))).

