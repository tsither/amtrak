%%clingo 0 environment.lp -

#script(python)
from clingo.symbol import String, Number, Tuple_, Function

def cell_options(T, move_left, move_forward, move_right):
    t = T.number
    t_bit = '{0:016b}'.format(t)
    
    options = []
    
    #######################################################
    directions = {
        0: 'n',
        1: 'e',
        2: 's',
        3: 'w',
        4: 'n',
    }
    
    cell = {}
    for i in range(0, 4):           #changed from a range(0,3) to range(0,4)
        in_dir = directions[i]
        section = list(t_bit[4*i:4*(i+1)])
        if section.count('1') == 0:
            continue
        if section.count('1') == 1:
            options.append(
                Tuple_([String(in_dir),
                        move_forward,
                        String(directions[section.index('1')])]))
        else:
            for j, move in [(i-1, move_left), (i, move_forward), (i+1, move_right)]:
                if section[j] == 1:
                    options.append(
                        Tuple_([String(in_dir),
                                move,
                                String(direction[j])]))

    #######################################################
    # for i in range(0, 4):
    #     section = t_bit[4*i:4*(i+1)]
    #     if section != '0000':
    #         move = [String(directions[i])]
    #         for j in range(0, 4):
    #             move.append(Number(int(section[j])))
    #         options.append(Tuple_(move))
    #######################################################

    return options
#end.

compass(n, "n").
compass(e, "e").
compass(s, "s").
compass(w, "w").


%generate option direction atoms for each cell --> possible incoming and outgoing direction for each cell
option((X,Y), @cell_options(Track, move_left, move_forward, move_right)) :- cell((X,Y), Track).


%%%%%% May be useful %%%%%% 
% create edges between cells, include movement type to get to second cell, and the direction in between
edge((X1,Y1),(X2,Y2), M, D) :- option((X1,Y1), (_,M,D)), option((X2,Y2), (D,_,_)), X2=X1, Y2 = Y1 + 1, D = "s".
edge((X1,Y1),(X2,Y2), M, D) :- option((X1,Y1), (_,M,D)), option((X2,Y2), (D,_,_)), X2=X1, Y2 = Y1 - 1, D = "n".
edge((X1,Y1),(X2,Y2), M, D) :- option((X1,Y1), (_,M,D)), option((X2,Y2), (D,_,_)), Y2=Y1, X2 = X1 - 1, D = "w".
edge((X1,Y1),(X2,Y2), M, D) :- option((X1,Y1), (_,M,D)), option((X2,Y2), (D,_,_)), Y2=Y1, X2 = X1 + 1, D = "e".
%%%%%% %%%%%% %%%%%% %%%%%% 




% get max time
max_T(MAXT) :- MAXT = #max { T : time(T) }.



% Attempt 1

%starting train position
at(train(ID),(X,Y),T,D) :- time(T), compass(Dir, D), start(ID,(X,Y),T,Dir).

{ move(ID, (X1,Y1), (X2,Y2), M, T) } = 1 :- at(train(ID),(X1,Y1),T,D), edge((X1,Y1),(X2,Y2),M,D). 

at(train(ID),(X2,Y2),T,D) :- move(ID, (X1,Y1), (X2,Y2), M, T-1), edge((X2,Y2),_,_,D).





% Attempt 2

%starting train position
% at(train(ID),(X,Y),T,D) :- time(T), compass(Dir, D), start(ID,(X,Y),T,Dir).


% { at(train(ID),(X2,Y2),T2,NEWD) } :- at(train(ID),(X1,Y1),T1,D), edge((X1,Y1),(X2,Y2), M, D), edge((X2,Y2),(X3,Y3), M, NEWD), T2=T1+1, T2 <=MAX, max_T(MAX).


% % train can't be two places at once
% :- at(train(ID),(X1,Y1),T1,_), at(train(ID),(X2,Y2),T2,_), T1=T2, X1!=X2, Y1!=Y2.

% :- not at(train(ID),_,0..MAXT,_), max_T(MAXT), train(ID).




count(N) :- N = #count { X, Y, D: edge(X, Y, M, D) }.




% #show edge/4.
% #show option/2.
% #show count/1.
#show at/4.
% #show can_move/4.
#show move/5.
% #show action/3.



% clingo environment.lp ted.lp 0


















% { move(ID, (X2,Y2), (X3,Y3), ACT, T) }  :- option((X2,Y2), (_,ACT,D)), option((X3,Y3), (D,_,_)), edge((X1,Y1),(X2,Y2)), time(T), move(ID, (X1,Y1), (X2,Y2), _, T-1).


% at(train(ID),(X2,Y2),T,D) :- move(ID, (X1,Y1), (X2,Y2), ACT, T), option((X2,Y2), (D,_,_)).

% :- at(train(ID),(X1,Y1),T1,D1), at(train(ID),(X2,Y2),T2,D2), move(ID, (X1,Y1), (X2,Y2), ACT, T), T2 - T1

% :- move(ID, (X1,Y1), (X2,Y2), _, T1), move(ID, (X1,Y1), (X2,Y2), _, T2), 




% %creating edges
% edge((X1,Y1),(X2,Y2)) :- option((X1,Y1), (_,_,"s")), option((X2,Y2), ("s",_,_)), X2=X1, Y2 = Y1+1. 
% % edge((X1,Y1),(X2,Y2)) :- option((X1,Y1), (_,_,"n")), option((X2,Y2), ("n",_,_)), X2=X1, Y2 = Y1-1. 
% edge((X1,Y1),(X2,Y2)) :- option((X1,Y1), (_,_,"w")), option((X2,Y2), ("w",_,_)), Y2=Y1, X2 = X1 - 1. 
% % edge((X1,Y1),(X2,Y2)) :- option((X1,Y1), (_,_,"e")), option((X2,Y2), ("e",_,_)), Y2=Y1, X2 = X1 + 1. 
% edge(A,B) :- edge(B,A).

% :- move(ID, (X1,Y1), (X2,Y2), _, T1), move(ID, (X1,Y1), (X2,Y2), _, T2), T2-T1 < 2.

% at(train(ID),(X2,Y2),T1,D) :- move(ID, (X1,Y1), (X2,Y2), ACT, T),option((X1,Y1), (_,_,D)), option((X2,Y2), (D,_,_)), at(train(ID),(X1,Y1),T,_), T1 = T + 1.

% :- 
% :- move(ID, (X1,Y1), (X2,Y2), ACT)

% { action(train(ID),ACT,T+1) } == 1 :- at(train(ID),(X,Y),T,D), option((X,Y),(_,ACT,D)). 

% at(train(ID),(X,Y),T,D) :- action(train(ID),ACT,T), edge((X1,Y1),(X2,Y2)), option((X1,Y1),(D,ACT,_))




% at(train(ID),(X,Y),T,D) :- action(train(ID),ACT,T), at(train(ID),(X1,Y1),T-1,D), option((X,Y),(_,ACT,D)).

