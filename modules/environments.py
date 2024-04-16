# Python libraries --
import os
import re
from argparse import ArgumentParser, Namespace

# Custom functions --
from create_environments.save import save_lp, save_png, save_pkl
from create_environments.generate import generate_env
from create_environments.convert import convert_to_clingo

def get_args():
    """
    capture command line inputs
    """
    parser = ArgumentParser()

    parser.add_argument('num_envs', type=int, default=0, nargs='?', help='the number of environments to create according to the given parameters')
    parser.add_argument('height', type=int, default=30, nargs='?', help='the height of each environment')
    parser.add_argument('width', type=int, default=30, nargs='?', help='the width of each environment')
    parser.add_argument('num_trains', type=int, default=2, nargs='?', help='the number of trains placed in each environment')
    parser.add_argument('num_cities', type=int, default=2, nargs='?', help='the number of cities in each environment, where trains can begin or end their journeys')
    parser.add_argument('grid_mode', type=int, default=1, nargs='?', help='if 1, cities will be arranged in a grid-like fashion;\nif 0, cities will be arranged unevenly throughout')
    parser.add_argument('max_rails_between', type=int, default=2, nargs='?', help='the maximum number of rails connecting any two cities')
    parser.add_argument('max_rails_within', type=int, default=2, nargs='?', help='the maximum number of pairs of parallel tracks within one city')

    return(parser.parse_args())


def find_max_env(dir):
    """
    find the maximum environment number in the current directory
    """
    max_env = -1
    for f in os.listdir(dir + 'pkl/'):
        env_num = int(re.match('env_(\d+)\.pkl', f)[1])
        if env_num > max_env:
            max_env = env_num
    return(max_env)


def main():
    # create directory
    file_location = '../envs/'
    os.makedirs(file_location, exist_ok=True)
    os.makedirs(file_location + 'lp/', exist_ok=True)
    os.makedirs(file_location + 'png/', exist_ok=True)
    os.makedirs(file_location + 'pkl/', exist_ok=True)

    # find maximum env number
    start_idx = find_max_env(file_location) + 1
    
    # capture arguments
    args: Namespace = get_args()

    # generate environments
    for idx in range(start_idx, args.num_envs + start_idx):
        env = generate_env(width=args.width, height=args.height, nr_trains=args.num_trains, 
                    cities_in_map=args.num_cities, seed=1, grid_distribution_of_cities=args.grid_mode, 
                    max_rails_between_cities=args.max_rails_between, max_rail_in_cities=args.max_rails_within)

        # save files
        save_lp(convert_to_clingo(env), idx, file_location)
        save_png(env, idx, file_location)
        save_pkl(env, idx, file_location)


if __name__ == "__main__":
    main()