import logging
import os
import signal
import subprocess

from progressbar import progressbar


logging.basicConfig(filename='amtrak/utils/output2.log',
                    level=logging.DEBUG)
logger = logging.getLogger()


LEAVE = [
    'env_001--2_2.lp',
    'env_002--2_2.lp',
    'env_003--2_2.lp',
    'test.lp',
    'env_001--2_2.pkl',
    'env_002--2_2.pkl',
    'env_003--2_2.pkl',
    'test.pkl',
    'env_001--2_2.png',
    'env_002--2_2.png',
    'env_002--4_2.png',
    'env_003--2_2.png',
    'env_003--4_2.png',
    'env_004--4_2.png',
    'env_005--4_2.png',
    'env_006--4_2.png',
    'env_007--4_2.png',
    'test.png',
]


def generate_params(width, height, stops):
    return f'''# basic parameters
width = {width}
height = {height}
number_of_agents = 2
number_of_stops = {stops}
max_num_cities = 2
seed = 1
grid_mode = False
max_rails_between_cities = 2
max_rail_pairs_in_city = 2
remove_agents_at_target = True

# speed
# speed_ratio_map={{1 : 1}}
speed_ratio_map = {{
    1:   0.50,
    1/2: 0.00,
    1/3: 0.00,
    1/4: 0.50
}}

# malfunctions
malfunction_rate = 0/30
min_duration = 2
max_duration = 6
'''


def get_files(path='envs/lp'):
    files = os.listdir('envs/lp')
    for file_to_leave in LEAVE:
        if file_to_leave in files:
            files.remove(file_to_leave)
    return files


def build(num_builds):
    for i in progressbar(range(num_builds)):
        try:
            encoded_results = subprocess.run(['python3', 'build.py', '1'],
                                             stdout=subprocess.PIPE, check=True)
            full_results = encoded_results.stdout.decode('utf-8')
            if full_results != '':
                raise Exception(
                    f'BUILD: Should be an empty string:\n{full_results}')
        except Exception as e:
            logger.warning(e)


def call_solver(curr_env):
    encoded_results = subprocess.run(
        ['clingo', 'amtrak/station_stops_solution.lp',
         'amtrak/track_options.lp',
         curr_env
         ], stdout=subprocess.PIPE)
    full_results = encoded_results.stdout.decode('utf-8')
    return full_results


# register a handler for the timeout
def handler(signum, frame):
    logger.warning('Clingo ran out of time!')
    raise Exception('Clingo ran out of time!')


# TODO: change output file before running
def solve_problem_lps():
    unsat_count = 0
    timeout_count = 0
    solved_count = 0
    files = get_files('envs/problem_lps')
    logger.info('\n\n\n\n')
    for i in progressbar(range(len(files))):
        signal.signal(signal.SIGALRM, handler)
        signal.alarm(120)
        logger.info('--------------------------------------------------')
        # curr_env = 'envs/lp/env_stop_{:03d}--2_2.lp'.format(i+1)
        curr_env = f'envs/problem_lps/{files[i]}'
        try:
            full_results = call_solver(curr_env)
            if 'UNSATISFIABLE' in full_results:
                unsat_count += 1
            else:
                solved_count += 1
            logger.info('\n'.join(full_results.split('\n')[-8:-1]))
        except Exception as exc:
            timeout_count += 1
            # print(curr_env, '-', exc)
            logger.warning(curr_env)
        count_str = f'unsat={unsat_count}, timeout={timeout_count}, solved={solved_count} out of {len(files)}'
        logger.info(f'\tCounts: {count_str}')
    return count_str


def solve(dim, stops):
    unsat_count = 0
    timeout_count = 0
    solved_count = 0
    files = get_files()
    for i in progressbar(range(len(files))):
        signal.signal(signal.SIGALRM, handler)
        signal.alarm(dim*3)
        logger.info('--------------------------------------------------')
        # curr_env = 'envs/lp/env_stop_{:03d}--2_2.lp'.format(i+1)
        curr_env = f'envs/lp/{files[i]}'
        logger.info(f'{dim} x {dim}, {stops}')
        try:
            full_results = call_solver(curr_env)
            if 'UNSATISFIABLE' in full_results:
                unsat_count += 1
            else:
                solved_count += 1
            logger.info('\n'.join(full_results.split('\n')[-8:-1]))
        except Exception as exc:
            timeout_count += 1
            # print(curr_env, '-', exc)
            logger.warning(
                f'{curr_env} --> envs/problem_lps/{dim}_{stops}_{files[i]}')
            os.rename(curr_env, f'envs/problem_lps/{dim}_{stops}_{files[i]}')
            os.rename(f'envs/png/{files[i][:-3]}.png',
                      f'envs/problem_lps/{dim}_{stops}_{files[i][:-3]}.png')
        count_str = f'unsat={unsat_count}, timeout={timeout_count}, solved={solved_count} out of {len(files)}'
        logger.info(f'\tCounts: {count_str}')
    return count_str


def clean_up():
    for path in [
        'envs/lp/',
        'envs/pkl/',
        'envs/png/',
        # 'envs/problem_lps/',
    ]:
        files = os.listdir(path)
        for file in files:
            if file not in LEAVE:
                file_path = f'{path}{file}'
                encoded_results = subprocess.run(['rm', '-rf', file_path],
                                                 stdout=subprocess.PIPE)
                if encoded_results.returncode != 0:
                    print(f'Error deleting file: {file_path}')


def main(n=50):
    for (dim, stops) in [
        (40, 0),
        (40, 1),
        (40, 2),
        (40, 3),
        (40, 4),
        (40, 5),
        (40, 6),

        (50, 0),
        (50, 1),
        (50, 2),
        (50, 3),
        (50, 4),
        (50, 5),
        (50, 6),

        (60, 0),
        (60, 1),
        (60, 2),
        (60, 3),
        (60, 4),
        (60, 5),
        (60, 6),

    ]:
        logger.info('\n\n\n\n')
        with open('envs/params.py', 'w') as f:
            f.write(generate_params(dim, dim, stops))

        build(n)
        count_str = solve(dim, stops)

        final_count_str = f'FINAL COUNTS: {dim} x {dim}, {stops} stops\n{count_str}'
        hash_line = '########################################################'

        print('\n', final_count_str)
        logger.info(f'\n{hash_line}\n{final_count_str}\n{hash_line}')
        clean_up()


if __name__ == '__main__':
    clean_up()
    main()
    # solve_problem_lps()
    # clean_up()
