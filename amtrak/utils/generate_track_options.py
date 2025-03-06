WAIT_GEN = 'track_option(Track,(D,wait,D)) :- M != wait, track_option(Track,(D,M,_)).\n'

TRACKS = [
    0,  # Track type 0
    '% Track type 1',
    32800,  # |
    1025,  # -
    4608,  # ⌝
    16386,  # ⌜
    72,  # ⌞
    2064,  # ⌟
    '\n% Track type 6',
    20994,  # T
    16458,  # ⊢
    2136,  # ┴
    6672,  # ⊣
    '\n% Track type 2',
    49186,  # |⌜
    1097,  # _⌞_
    34864,  # ⌟|
    5633,  # ‾⌝‾
    37408,  # ⌝|
    17411,  # ‾⌜‾
    32872,  # |⌞
    3089,  # _⌟_
    '\n% Track type 3',
    33825,  # +
    '\n% Track type 4',
    38433,  # ⌝+
    50211,  # +⌜
    33897,  # +⌞
    35889,  # ⌟+
    '\n% Track type 5',
    38505,  # ⌝+⌞
    52275,  # ⌟+⌜
]


def options(t):
    t_bit = '{0:016b}'.format(t)

    dirs = {
        0: 'n',
        1: 'e',
        2: 's',
        3: 'w',
    }

    opts = []

    for i in range(0, 4):
        in_dir = dirs[i]
        section = list(t_bit[4 * i: 4 * (i + 1)])
        if section.count('1') == 0:
            continue
        if section.count('1') == 1:
            opts.append(
                [
                    in_dir,
                    'move_forward',
                    dirs[section.index('1')],
                ]
            )
        else:
            moves = {
                i - 1 if i != 0 else 3: 'move_left',
                i: 'move_forward',
                i + 1 if i != 3 else 0: 'move_right',
            }
            for j, subsection in enumerate(section):
                if subsection == '1':
                    opts.append([in_dir, moves[j], dirs[j]])

    return opts


def main():
    opts_str = ''
    for track in TRACKS:
        if isinstance(track, str):
            opts_str = f'{opts_str}{track}'
            continue
        for opt in options(track):
            track_opt = f'track_option({track},({opt[0]},{opt[1]},{opt[2]})).'
            opts_str = f'{opts_str}\n{track_opt}'
        opts_str = f'{opts_str}\n'

    opts_str = f'{opts_str}\n{WAIT_GEN}'
    with open('amtrak/track_options.lp', 'w') as f:
        f.write(opts_str)


if __name__ == '__main__':
    main()
