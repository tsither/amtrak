#include "test_envs/test_env_2/test_env_2.lp".
#include "track_option.lp".


%               connection(ID,  N/S, W/E, N/E, E/S, S/W, W/N)
% has_south(N) :- connection(Track, A, _, _, B, C, _), cell(N,Track), 1{A=1;B=1;C=1}.          %  contains south point
% has_north(N) :- connection(Track, A, _, B, _, _, C), cell(N,Track), 1{A=1;B=1;C=1}.          %  contains north point
% has_east(N) :-  connection(Track, _, A, B, C, _, _), cell(N,Track), 1{A=1;B=1;C=1}.          %  contains east point
% has_west(N) :-  connection(Track, _, A, _, _, B, C), cell(N,Track), 1{A=1;B=1;C=1}.          %  contains west point

link((X1,Y),(X2,Y),(s,n)) :- 
    connection(Track_s, A1, _, _, B1, C1, _), 1{A1=1;B1=1;C1=1}, % Contains south point
    connection(Track_n, A2, _, B2, _, _, C2), 1{A2=1;B2=1;C2=1}, % Contains north point
    cell((X1,Y),Track_s), cell((X2,Y),Track_n),
    X1 = X2 - 1.

link((X2,Y),(X1,Y),(n,s)) :- link((X1,Y),(X2,Y),(s,n)).   % Reverse, if s/n connection exists, then n/s connection exists between adjacent cells

link((X,Y1),(X,Y2),(w,e)) :- 
    connection(Track_e, _, A1, B1, C1, _, _), 1{A1=1;B1=1;C1=1},          %  contains east point
    connection(Track_w, _, A2, _, _, B2, C2), 1{A2=1;B2=1;C2=1},          %  contains west point
    cell((X,Y1),Track_e),cell((X,Y2),Track_w),
    Y1 = Y2 - 1.

link((X,Y2),(X,Y1),(e,w)) :- link((X,Y1),(X,Y2),(w,e)).     % Reverse


% Previous linking using 'option' atom
% link((X1,Y),(X2,Y),(n,s)) :- option((X1,Y),(_,_,n)), option((X2,Y),(n,_,_)), 
%     X2 = X1 - 1.

% link((X,Y1),(X,Y2),(e,w)) :- option((X,Y1),(_,_,e)), option((X,Y2),(e,_,_)), 
%     Y2 = Y1 + 1.

% link((X1,Y),(X2,Y),(s,n)) :- option((X1,Y),(_,_,s)), option((X2,Y),(s,_,_)), 
%     X2 = X1 + 1.

% link((X,Y1),(X,Y2),(w,e)) :- option((X,Y1),(_,_,w)), option((X,Y2),(w,_,_)), 
%     Y2 = Y1 - 1.

#show link/3.