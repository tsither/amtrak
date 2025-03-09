
% Populate edges with 'action' atoms ; waiting is only allowed on edges adjacent to nodes
% Not currently implemented to due to scaling issues in 'solve'.lp


% Different cases to create action atoms: 

% 1. Generate actions departing all nodes
% 2. Populate move_forwards from node to node if train doesn't wait
% 3. Populate move_forwards from nodes to wait_nodes if train waits at some point
% 4. Add last move_forward from wait_node to next_node if train waits
% 5. Add appropriate number of waiting actions if train waits


% Generate actions at all nodes (starting cell, ending cell, junctions)

% 1. Actions LEAVING all nodes
action(train(ID), Action, Current_Time) :- 
    node_action(train(ID), Current_Node, Action, _, Next_Node, (dep(Current_Time), dist(Dist), arr(Next_Time))),
    end(ID,End_Node,_),                     
    Current_Node!= End_Node.            
    
% 2.  Populating node to node - IF NO WAITING
action(train(ID), move_forward, T) :- 
    node_action(train(ID), Current_Node, Action, _, Next_Node, (dep(Current_Time),dist(Dist), arr(Arrival_Time))),
    Dist + Current_Time = Arrival_Time,         % implies NO WAITING
    T = Current_Time+1..Arrival_Time-1.         % Iterate over entire edge length 

% 3.  Node to wait cell - IF WAITING
action(train(ID), move_forward, T) :- 
    node_action(train(ID), Current_Node, Action, _, Next_Node, (dep(Current_Time),dist(Dist), arr(Arrival_Time))),
    Dist + Current_Time < Arrival_Time,         % implies WAITING   
    Start_forward = Current_Time + 1,
    End_forward = Current_Time + Dist - 2,
    T = Start_forward..End_forward.                 % Iterate from after train has left node to the distance of the wait cell

% 4. Waiting on wait cell - IF WAITING
action(train(ID), wait, T) :- 
    node_action(train(ID), Current_Node, Action, _, Next_Node, (dep(Current_Time),dist(Dist), arr(Arrival_Time))),
    Current_Time + Dist < Arrival_Time,                        % implies WAITING
    End_forward = Current_Time + Dist - 2,                       % Populate wait actions between the time steps where the arrival time for that edge is greater than the Length of that edge
    T = End_forward+1..Arrival_Time-2.    

% 5.  Wait cell to node - IF WAITING
action(train(ID), move_forward, T) :- 
    node_action(train(ID), Current_Node, Action, _, Next_Node, (dep(Current_Time),dist(Dist), arr(Arrival_Time))),
    Dist + Current_Time < Arrival_Time,         % implies WAITING
    T = Arrival_Time-1.                         % Must be a move_forward before arriving at next node from wait cell



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



