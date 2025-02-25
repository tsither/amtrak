% #include "test_envs/test_env_2/test_env_2.lp".
% #include "/Users/mymac/Desktop/Trains/flatland/amtrak/environments/lp/env_01.lp".


% This file builds a weighted graph from a flatland environment .lp
% Includes the ability to wait on adjacent cells around nodes, not nodes themselves


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

node_track(T) :- connection(T, A, B, C, D, E, F), A+B+C+D+E+F>1, T!=33825.

cell_count(C) :- C = #count{ XY: cell((XY), Track), Track != 0}.

% node( N ) :- cell(N,Track), node_track(Track).
% node( N ) :- cell(N,Track), start(_,N,_,_).
% node( N ) :- cell(N,Track), end(_,N,_).


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


%%%%%%%% edges %%%%%%%%%
% Connects nodes together, where nodes are 1. start and 2. end positions of agents and 3. switch tracks

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
    % node(F).

% :- #count{S,F,OUT,IN : edge(S, F, (OUT,IN), L)} >1.

% :- edge(S1, S2, (_), _), S1=S2.  

%%%%%%%%%%%%% Wait nodes %%%%%%%%%%%%%
% cells that are adjacent to real nodes that allows 'wait' actions


wait_node( cell(Cell), D, node(Node)) :- node(Node,_), link(Node,Cell,(D,_)), not node(Cell,_).

% wait_node( cell(Cell), D, node(Node)) :- node(Node), link(Node,Cell,(D,_)), not node(Cell).

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





wait_time(0).
% wait_time(1).
% wait_time(2).
% wait_time(4).
% wait_time(6).
% wait_time(8).
% wait_time(10).


% Mark all locations on environment where a decision can be made
% decision_point(Node,in(IN_Current)) :- #count{OUT : node(Node,(IN_Current,OUT))}>1, node(Node,(IN_Current,_)). 

node_track(T) :- connection(T, A, B, C, D, E, F), 2{A=1;B=1;C=1;D=1;E=1;F=1}, T!=33825.


%                         connection(ID, N/S, W/E, N/E, E/S, S/W, W/N)

decision_point(Node,in(n)) :- connection(T, A, B, C, D, E, F), A + C + F > 1, cell(Node,T).

decision_point(Node,in(e)) :- connection(T, A, B, C, D, E, F), B + C + D > 1, cell(Node,T).

decision_point(Node,in(s)) :- connection(T, A, B, C, D, E, F), A + D + E > 1, cell(Node,T).

decision_point(Node,in(w)) :- connection(T, A, B, C, D, E, F), B + E + F > 1, cell(Node,T).

% n_nodes(N) :- N = #count{Node : node(Node, _)}.
% n_edges_total(N) :- N = #count{S,F:edge(S,F,_,L)}.


% n_edges_undirected(X) :- n_edges_total(N), X=N/2.

% density(D) :- n_edges_total(E), n_nodes(N), D = ((100 * E) / (N * (N - 1))).

% decision_point(Node,in(IN_Current)) :- #sum{A, B, C, D, E, F : connection(T, A, B, C, D, E, F)}     > 1, cell(Node,T).


% %                                                  connection(ID, N/S, W/E, N/E, E/S, S/W, W/N)
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

% #show start/4.

% #show edge/4.
% #show node/2.

