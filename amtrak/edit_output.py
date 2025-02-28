import re
import subprocess
import logging

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)
logging.basicConfig(filename='output.log', level=logging.DEBUG)

ENV = 'env_001--2_2'

log_strs = []


def process(result):
    log_strs.append(
        '-----------------------------------------------------------')
    ends = re.findall(r'end\(([\d+,\(\)]+)\)', result)
    trains = set([])
    for end in ends:
        train, end_cell_x, end_cell_y, time = end.split(',')
        log_strs.append(str(train))
        trains.add(train)
        log_strs.append(f'END: {train} {end_cell_x},{end_cell_y} {time}')

        dones = re.findall(r'done\({},(\d+)\)'.format(train), result)
        # assert all([done <= time for done in dones])
        log_strs.append(f'train {train} done times: {dones} <= {time}')

        ats = re.findall(r'at\({},\{},{}\),(\d+),\w\)'.format(
            train, end_cell_x, end_cell_y[:-1]), result)
        # assert all([at <= time for at in ats])
        log_strs.append(f'train {train} at times: {ats} <= {time}')
        log_strs.append(' ')

    if not trains:
        raise Exception(result)
    # result = result.split('\n')
    # result.sort()

    # for r in result:
    #     log_strs.append(r)

    output = result.strip().split(' ')
    # output.sort()

    sorted_atoms = {
        'at': {},
        'action': {},
        'done': {},
        'stopped': {},
        'option': {}
    }
    for train in trains:
        sorted_atoms['at'][f'at({train},'] = []
        sorted_atoms['action'][f'action(train({train}),'] = []
        sorted_atoms['done'][f'done({train},'] = []
        sorted_atoms['stopped'][f'stopped({train},'] = []
        sorted_atoms['option']['option(('] = []

    log_strs.append('\n   ATOMS:\n------------')

    for line in output:
        for short_key in sorted_atoms.keys():
            for key in sorted_atoms[short_key].keys():
                if line[:len(key)] == key:
                    sorted_atoms[short_key][key].append(f'{line}.')

    options = sorted_atoms.pop('option')
    options = options['option((']
    options.sort()

    for short_key in sorted_atoms.keys():
        log_strs.append(' ')
        keys = list(sorted_atoms[short_key].keys())
        # log_strs.append(keys)
        max_len = max([len(sorted_atoms[short_key][key])
                       for key in sorted_atoms[short_key]])
        for key in sorted_atoms[short_key].keys():
            sorted_atoms[short_key][key].extend(
                [' '] * (max_len-len(sorted_atoms[short_key][key])))

        for i in range(max_len):
            log_strs.append('{0:40}  {1}'.format(
                sorted_atoms[short_key][keys[0]][i], sorted_atoms[short_key][keys[1]][i]))

    # log_strs.append('\n\n----- options -----\n')
    # for option in options:
    #     log_strs.append(option)

    return sorted_atoms


# encoded_result = subprocess.run(['clingo', 'amtrak/base_solution.lp', 'amtrak/wait/track_option_wait_all.lp',
#                                  f'envs/lp/{ENV}.lp'],
#                                 stdout=subprocess.PIPE)

encoded_result = subprocess.run(['python3', 'solve.py', f'envs/pkl/{ENV}.pkl'],
                                stdout=subprocess.PIPE)

full_results = encoded_result.stdout.decode('utf-8')
try:
    full_results_split = full_results.split('Optimization:')
    if len(full_results_split) == 1:
        results = process(full_results_split[0])
    else:
        results = process(full_results_split[-2])
except IndexError:
    raise Exception(full_results)


print('\n'.join(log_strs))
# logging.info('\n'.join(log_strs))
