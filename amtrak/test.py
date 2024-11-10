tracks = {
    0: ' ',
    32800: '|',
    1025: '-',
    '-1-': '-',
    4608: '⌝',
    16386: '⌜',
    72: '⌞',
    2064: '⌟',
    '-2-': '-',
    20994: 'T',
    16458: '⊢',
    2136: '┴',
    6672: '⊣',
    '-3-': '-',
    49186: '|⌜',
    1097: '_⌞_',
    34864: '⌟|',
    5633: '‾⌝‾',
    '-4-': '-',
    37408: '⌝|',
    17411: '‾⌜‾',
    32872: '|⌞',
    3089: '_⌟_',
    '-5-': '-',
    33825: '+',
    '-6-': '-',
    38433: '⌝+',
    50211: '+⌜',
    33897: '+⌞',
    35889: '⌟+',
    '-7-': '-',
    38505: '⌝+⌞',
    52275: '⌟+⌜',
}


def display_bitmaps():
    print('\n\n')
    for track, symbol in tracks.items():
        if isinstance(track, str):
            print('------')
            continue
        bit_str = '{0:016b}'.format(track)
        bit_str = ' '.join(
            [bit_str[i : i + 4] for i in range(0, len(bit_str), 4)]
        )
        print(f'{track}\t{bit_str} - {symbol}')
    print('\n\n')


# For example, in case of no diagonal transitions on the grid, the 16 bits
# of the transition bitmaps are organized in 4 blocks of 4 bits each, the
# direction that the agent is facing.
# E.g., the most-significant 4-bits represent the possible movements (NESW)
# if the agent is facing North, etc...

# agent's direction:            North    East   South   West
# agent's allowed movements:   [nesw]   [nesw] [nesw]  [nesw]
# example:                      1000     0000   0010    0000

# In the example, the agent can move from North to South and viceversa.


def options(t):
    print(t)
    t_bit = '{0:016b}'.format(t)

    directions = {
        0: 'n',
        1: 'e',
        2: 's',
        3: 'w',
    }

    options = []

    cell = {}
    for i in range(0, 4):
        in_dir = directions[i]
        section = list(t_bit[4 * i : 4 * (i + 1)])
        print(section, section.count('1'))
        if section.count('1') == 0:
            continue
        if section.count('1') == 1:
            options.append(
                [
                    in_dir,
                    'move_forward',
                    directions[section.index('1')],
                ]
            )
        else:
            moves = {
                i - 1 if i != 0 else 3: 'move_left',
                i: 'move_forward',
                i + 1 if i != 3 else 0: 'move_right',
            }
            print(i, moves)
            for j, subsection in enumerate(section):
                if subsection == '1':
                    options.append([in_dir, moves[j], directions[j]])
            options.append([in_dir, 'wait', in_dir])

    return options


# display_bitmaps()

print(options(72))
print(options(2064))

print(options(32800))
print(options(37408))
