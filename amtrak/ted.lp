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
                                String(directions[j])]))

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



%creating edges
edge((X1,Y1),(X2,Y2)) :- option((X1,Y1), (_,_,"s")), option((X2,Y2), ("s",_,_)), X2=X1, Y2 = Y1+1. 
% edge((X1,Y1),(X2,Y2)) :- option((X1,Y1), (_,_,"n")), option((X2,Y2), ("n",_,_)), X2=X1, Y2 = Y1-1. 
edge((X1,Y1),(X2,Y2)) :- option((X1,Y1), (_,_,"w")), option((X2,Y2), ("w",_,_)), Y2=Y1, X2 = X1 - 1. 
% edge((X1,Y1),(X2,Y2)) :- option((X1,Y1), (_,_,"e")), option((X2,Y2), ("e",_,_)), Y2=Y1, X2 = X1 + 1. 
edge(A,B) :- edge(B,A).


{ move(ID, (X1,Y1), (X2,Y2), ACT) } :- option((X1,Y1), (_,ACT,_)), option((X2,Y2), (_,_,_)), edge((X1,Y1),(X2,Y2)), train(ID).




% at time 0 trains should be found at thier starting position
at(train(ID),(X,Y),Dep,D) :- time(Dep), compass(Dir, D), start(ID,(X,Y),Dep,Dir).

% :- move(ID, (X1,Y1), (X2,Y2), ACT)

% { action(train(ID),ACT,T+1) } == 1 :- at(train(ID),(X,Y),T,D), option((X,Y),(_,ACT,D)). 

% at(train(ID),(X,Y),T,D) :- action(train(ID),ACT,T), edge((X1,Y1),(X2,Y2)), option((X1,Y1),(D,ACT,_))




% at(train(ID),(X,Y),T,D) :- action(train(ID),ACT,T), at(train(ID),(X1,Y1),T-1,D), option((X,Y),(_,ACT,D)).




count(N) :- N = #count { X, Y : option(X, Y) }.

% #show edge/2.
% #show option/2.
% #show count/1.
% #show at/4.
#show move/4.
% #show action/3.


