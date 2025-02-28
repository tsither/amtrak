import re
import subprocess
import logging

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)
logging.basicConfig(filename='output.log', level=logging.DEBUG)

ENV = 'envs/lp/env_001--2_2'

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


encoded_result = subprocess.run(['clingo', 'amtrak/base_solution.lp', 'amtrak/wait/track_option_wait_all.lp',
                                 f'{ENV}.lp'],
                                stdout=subprocess.PIPE)

# encoded_result = subprocess.run(['python3', 'solve.py', f'{ENV}.pkl'],
#                                 stdout=subprocess.PIPE)

full_results = encoded_result.stdout.decode('utf-8')
try:
    full_results_split = full_results.split('Optimization:')
    results = process(full_results_split[-2])
except:
    raise Exception(full_results)


print('\n'.join(log_strs))
# logging.info('\n'.join(log_strs))


# encoded_result = subprocess.run(['clingo', 'amtrak/base_solution.lp', 'amtrak/wait/track_option_wait_all.lp',
#                                  'envs/lp/env_002--2_2.lp'],
#                                 stdout=subprocess.PIPE)

# full_results = encoded_result.stdout.decode('utf-8')
# full_results = full_results.split('Optimization:')

# trying_to_find_str = '''
# end(0,(18,8),36) end(1,(8,20),36) at(0,(7,20),0,w) at(1,(19,8),0,e) at(1,(19,8),1,e) action(train(1),wait,0) at(0,(7,19),1,w) action(train(0),move_forward,0) action(train(0),move_forward,1) at(0,(7,18),2,w) at(1,(19,8),2,e) action(train(1),wait,1) at(1,(19,8),3,e) action(train(1),wait,2) at(0,(8,18),3,s) action(train(0),move_left,2) at(0,(8,18),4,s) action(train(0),wait,3) at(1,(19,8),4,e) action(train(1),wait,3) at(1,(19,8),5,e) action(train(1),wait,4) at(0,(8,17),5,w) action(train(0),move_forward,4) action(train(0),wait,5) at(0,(8,17),6,w) at(1,(19,8),6,e) action(train(1),wait,5) at(1,(19,8),7,e) action(train(1),wait,6) action(train(0),wait,6) at(0,(8,17),7,w) at(0,(7,17),8,n) action(train(0),move_right,7) at(1,(19,9),8,e) action(train(1),move_forward,7) action(train(1),wait,8) at(1,(19,9),9,e) at(0,(7,17),9,n) action(train(0),wait,8) at(0,(7,16),10,w) action(train(0),move_forward,9) action(train(1),wait,9) at(1,(19,9),10,e) at(1,(19,10),11,e) action(train(1),move_forward,10) action(train(0),wait,10) at(0,(7,16),11,w) at(0,(7,15),12,w) action(train(0),move_forward,11) action(train(1),wait,11) at(1,(19,10),12,e) action(train(1),wait,12) at(1,(19,10),13,e) action(train(0),wait,12) at(0,(7,15),13,w) action(train(0),wait,13) at(0,(7,15),14,w) at(1,(19,11),14,e) action(train(1),move_forward,13) at(1,(18,11),15,n) action(train(1),move_forward,14) at(0,(7,14),15,w) action(train(0),move_forward,14) action(train(0),wait,15) at(0,(7,14),16,w) at(1,(18,12),16,e) action(train(1),move_forward,15) at(1,(18,13),17,e) action(train(1),move_forward,16) action(train(0),wait,16) at(0,(7,14),17,w) action(train(0),wait,17) at(0,(7,14),18,w) at(1,(17,13),18,n) action(train(1),move_left,17) at(1,(16,13),19,n) action(train(1),move_forward,18) at(0,(7,13),19,w) action(train(0),move_forward,18) at(0,(8,13),20,s) action(train(0),move_forward,19) at(1,(15,13),20,n) action(train(1),move_forward,19) at(1,(14,13),21,n) action(train(1),move_forward,20) at(0,(9,13),21,s) action(train(0),move_forward,20) at(0,(10,13),22,s) action(train(0),move_forward,21) at(1,(14,14),22,e) action(train(1),move_right,21) action(train(1),move_left,22) at(1,(13,14),23,n) at(0,(11,13),23,s) action(train(0),move_forward,22) action(train(1),wait,24) at(0,(12,13),24,s) action(train(0),move_forward,23) at(1,(12,14),24,n) action(train(1),move_forward,23) at(1,(12,14),25,n) at(0,(13,13),25,s) at(0,(14,13),26,s) at(1,(11,14),26,n) at(1,(10,14),27,n) at(0,(15,13),27,s) action(train(0),move_forward,24) at(0,(16,13),28,s) at(1,(9,14),28,n) at(1,(8,14),29,n) at(0,(17,13),29,s) action(train(0),move_forward,25) action(train(1),move_forward,25) action(train(1),move_forward,26) action(train(0),move_forward,26) at(0,(18,13),30,s) at(1,(8,15),30,e) at(1,(8,16),31,e) at(0,(18,12),31,w) action(train(0),move_forward,27) action(train(1),move_forward,27) action(train(1),move_forward,28) action(train(0),move_forward,28) at(0,(18,11),32,w) at(1,(8,17),32,e) at(1,(8,18),33,e) at(0,(18,10),33,w) action(train(0),move_forward,29) action(train(1),move_forward,29) action(train(1),move_forward,30) action(train(0),move_forward,30) at(0,(18,9),34,w) at(1,(8,19),34,e) done(1,36) done(0,36) action(train(1),wait,35) action(train(0),wait,35) at(1,(8,20),35,e) at(0,(18,8),35,w) action(train(0),move_forward,31) action(train(1),move_forward,31) action(train(1),move_forward,32) action(train(0),move_forward,32) action(train(0),wait,36) action(train(1),wait,36) at(0,(18,8),36,w) at(1,(8,20),36,e) action(train(0),move_forward,33) action(train(1),move_forward,33) action(train(1),move_forward,34) action(train(0),move_forward,34)
# '''

# trying_to_find = process(trying_to_find_str)


# record = {}
# for i, full_result in enumerate(full_results):
#     possible_result = process(full_result)
#     shared = {}
#     shared_str = ''
#     for key, value in possible_result.items():
#         # shared_items = {k: x[k] for k in x if k in y and x[k] == y[k]}
#         shared[key] = [x for x in trying_to_find[key] if x in value]

#         # shared_str = f'{shared_str} "{key}" {len(shared[key])}/{len(trying_to_find[key])}'
#         if len(shared[key]) == len(trying_to_find[key]) and 'done' not in key:
#             curr_record = record.get(i, [])
#             curr_record.append(key)
#             record[i] = curr_record

# log_strs.append(record)
