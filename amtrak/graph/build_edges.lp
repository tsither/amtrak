% Construct second-order graph of flatland instance

%%%%%%%% edges %%%%%%%%%
% Build edge steps into edges
% N = start node; OUT = outgoing direction from that edge; B = next cell on edge; IN = Incoming direction to B
edge_step((N,OUT), N, B, IN, 1) :- % Cells adjacent to nodes (Length of 1)
    link(N, B, (OUT,IN)),   % for all links that exit a node, create a step
    node(N,_),
    N!=B.

% N is starting node, A, B are the cells on the edge at each step, IN is direction into cell C
edge_step((N,OUT), B, C, IN, L) :- 
    edge_step((N,OUT), A, B, _, L1),        % retrieve previous edge step
    link(B, C, (_,IN)),
    not edge_step((N,OUT), C, B, _, _),     
    not node(B,_), 
    L=L1+1,                         % adjust total length
    L <= CC,                    % include hard stop 
    B!=C,
    cell_count(CC). 

% Create an edge from successfully built edge steps 
edge(S, F, (OUT,IN), L) :-       % S = start node ; F = end node ; OUT = outgoing direction of start node; IN = incoming direction to end node; L = length of node
    edge_step((S,OUT), _, F, IN, L), 
    node(F,_),
    S!=F.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Generate next possible nodes from entire graph %%%%%%%%%%%%%%

% If node is a 'decision point', agent has multiple next nodes it can reach (depending on the action)
next_possible_node(at(Current_Node), (IN_Current,OUT_Current,IN_Next), Action, next(Next_Node), dist(Next_Length)) :- 

        edge(_, Current_Node, (_,IN_Current), _), 
        edge(Current_Node, Next_Node, (OUT_Current,IN_Next), Next_Length),
            node(Current_Node, (IN_Current,OUT_Current)), 
            move(IN_Current, OUT_Current, Action),      % Get possible actions if decision point
                decision_point(Current_Node,in(IN_Current)).


% agents must move forward at nodes that aren't decision points
next_possible_node(at(Current_Node), (IN_Current,OUT_Current,IN_Next), move_forward, next(Next_Node), dist(Next_Length)) :- 

        edge(_, Current_Node, (_,IN_Current), _), 
        edge(Current_Node, Next_Node, (OUT_Current,IN_Next), Next_Length),
            node(Current_Node, (IN_Current,OUT_Current)), 
                not decision_point(Current_Node,in(IN_Current)).
