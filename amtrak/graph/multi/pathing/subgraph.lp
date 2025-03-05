#include "pathing.lp".


% sedge(Node1,Node2,(OUT_Current,IN_Next),Length) :- 
%     node_action(train(ID), Current_Node, Action, (_,OUT_Current,IN_Next), Next_Node, (_,dist(Length), _)),
%     edge(Node1, Node2, (OUT_Current,IN_Next), Length).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Generate next possible nodes from entire graph %%%%%%%%%%

% If node is a 'decision point', agent has multiple next nodes it can reach (depending on the action)
% IF LENGTH IS > 1, TRAIN CAN WAIT

% snext_possible_node(at(Current_Node), (IN_Current,OUT_Current,IN_Next), Action, next(Next_Node), (dist(Next_Length))) :- 

%         sedge(_, Current_Node, (_,IN_Current), _), 
%         sedge(Current_Node, Next_Node, (OUT_Current,IN_Next), Next_Length),
%         Next_Length > 1,
%             node(Current_Node, (IN_Current,OUT_Current)), 
%             move(IN_Current, OUT_Current, Action),      % Get action if decision point
%                 decision_point(Current_Node,in(IN_Current)).

% % IF EDGE LENGTH BETWEEN TWO NODES IS 1, NO OPTION FOR WAITING, TRAIN MUST MOVE FORWARD
% snext_possible_node(at(Current_Node), (IN_Current,OUT_Current,IN_Next), Action, next(Next_Node), (dist(Next_Length))) :- 

%         sedge(_, Current_Node, (_,IN_Current), _), 
%         sedge(Current_Node, Next_Node, (OUT_Current,IN_Next), Next_Length),
%         Next_Length = 1,
%             node(Current_Node, (IN_Current,OUT_Current)), 
%             move(IN_Current, OUT_Current, Action),      % Get action if decision point
%                 decision_point(Current_Node,in(IN_Current)).


% % agents must move forward at nodes that aren't decision points
% snext_possible_node(at(Current_Node), (IN_Current,OUT_Current,IN_Next), move_forward, next(Next_Node), (dist(Next_Length))) :- 

%         sedge(_, Current_Node, (_,IN_Current), _), 
%         sedge(Current_Node, Next_Node, (OUT_Current,IN_Next), Next_Length),
%         Next_Length > 1,
%             node(Current_Node, (IN_Current,OUT_Current)), 
%                 not decision_point(Current_Node,in(IN_Current)).


% snext_possible_node(at(Current_Node), (IN_Current,OUT_Current,IN_Next), move_forward, next(Next_Node), (dist(Next_Length))) :- 

%         sedge(_, Current_Node, (_,IN_Current), _), 
%         sedge(Current_Node, Next_Node, (OUT_Current,IN_Next), Next_Length),
%         Next_Length=1,
%             node(Current_Node, (IN_Current,OUT_Current)), 
%                 not decision_point(Current_Node,in(IN_Current)).

% #show 

n_sedge(N) :- N=#count{A,B,C,D:sedge(A,B,C,D)}.
n_edge(N) :- N=#count{A,B,C,D:edge(A,B,C,D)}.
% n_snpn(N) :- N=#count{A,B,C,D,E:next_possible_node(A,B,C,D,E)}.
% n_npn(N) :- N=#count{A,B,C,D:snext_possible_node(A,B,C,D,E)}.

% #show sedge/4.
% #show edge/4.
% #show n_snpn/1.
% #show n_npn/1.
#show n_edge/1.
#show n_sedge/1.