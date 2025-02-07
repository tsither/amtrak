#include "graph_weighted.lp".
#include "test_envs/test_env_2/test_env_2.lp".

% Next step: 
% - Observe how pathing scales up
% - Include some time measuring device
% - Build simple solution for flatland using actions



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
    % cell_count(CC),
    % TL<=CC.             % Hard code a stopping condition


path(ID,(S,F),L) :- path_step(ID, _, (S,F), (_, F), L).

#show path/3.
% #show edge/4.