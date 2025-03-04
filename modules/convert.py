from random import choice
from flatland.envs.rail_env import RailEnv
from flatland.envs.rail_env import RailEnvActions
from flatland.utils.rendertools import RenderTool, AgentRenderVariant


def convert_to_clingo(env, num_stops=0) -> str:
    """
    converts Flatland environment to clingo facts
    """
    # environment properties
    rail_map = env.rail.grid
    height, width, agents = env.height, env.width, env.agents
    clingo_str = f"% clingo representation of a Flatland environment\n% height: {height}, width: {width}, agents: {len(agents)}\n"
    clingo_str += f"\nglobal({env._max_episode_steps}).\n"

    # save start and end positions for each agent
    dir_map = {0: "n", 1: "e", 2: "s", 3: "w"}

    possible_stops = []
    cells_str = ""
    # create an atom for each cell in the environment
    # row_num = len(rail_map) - 1
    for row, row_array in enumerate(rail_map):
        for col, cval in enumerate(row_array):
            cells_str += f"cell(({row},{col}), {cval}).\n"
            if cval != 0:
                possible_stops.append(f"({row},{col})")
        # row_num -= 1
        cells_str += "\n"

    for agent_num, agent_info in enumerate(env.agents):
        init_y, init_x = agent_info.initial_position
        goal_y, goal_x = agent_info.target
        min_start, max_end = agent_info.earliest_departure, agent_info.latest_arrival
        # inverse, e.g. 1/2 --> 2, 1/4 --> 4 etc.
        speed = int(1/agent_info.speed_counter.speed)

        direction = dir_map[agent_info.initial_direction]
        clingo_str += f"\ntrain({agent_num}). "
        clingo_str += f"start({agent_num},({init_y},{init_x}),{min_start},{direction}). "
        clingo_str += f"end({agent_num},({goal_y},{goal_x}),{max_end}). "
        clingo_str += f"speed({agent_num},{speed}).\n"
        not_stops = [f"({init_y},{init_x})", f"({goal_y},{goal_x})"]

        for _ in range(num_stops):
            stop_to_add = choice(possible_stops)
            if stop_to_add in not_stops:
                continue
            clingo_str += f"stop({agent_num},{stop_to_add}). "
            not_stops.append(stop_to_add)

    clingo_str += "\n"
    clingo_str += cells_str

    return (clingo_str)


def convert_formers_to_clingo(actions) -> str:
    # change back to the clingo names
    mapping = {RailEnvActions.MOVE_FORWARD: "move_forward", RailEnvActions.MOVE_RIGHT: "move_right",
               RailEnvActions.MOVE_LEFT: "move_left", RailEnvActions.STOP_MOVING: "wait"}
    for index, dict in enumerate(actions):
        for key in dict.keys():
            actions[index][key] = mapping[actions[index][key]]

    facts = []
    # change from dictionary into facts
    for index, dict in enumerate(actions):
        for key in dict.keys():
            # remove: can this be a list of strings or should it be one long string?
            facts.append(
                f':- not action(train({key}),{actions[index][key]},{index}).\n')

    return (facts)


def convert_malfunctions_to_clingo(malfs, timestep) -> str:
    # mapping = {RailEnvActions.MOVE_FORWARD:"move_forward", RailEnvActions.MOVE_RIGHT:"move_right", RailEnvActions.MOVE_LEFT:"move_left", RailEnvActions.STOP_MOVING:"wait"}
    facts = []
    for m in malfs:
        train, duration = m[0], m[1]
        facts.append(f'malfunction({train},{duration},{timestep}).\n')
        # remove: make sure this duration should be included (aka remove +1 or keep it?)
        for t in range(timestep+1, timestep+1+m[1]):
            # remove: can this be a list of strings or should it be one long string?
            facts.append(f':- not action(train({train}),wait,{t}).\n')

    return (facts)


def convert_futures_to_clingo(actions) -> str:
    # change back to the clingo names
    mapping = {RailEnvActions.MOVE_FORWARD: "move_forward", RailEnvActions.MOVE_RIGHT: "move_right",
               RailEnvActions.MOVE_LEFT: "move_left", RailEnvActions.STOP_MOVING: "wait"}
    for index, dict in enumerate(actions):
        for key in dict.keys():
            actions[index][key] = mapping[actions[index][key]]

    facts = []
    # change from dictionary into facts
    for index, dict in enumerate(actions):
        for key in dict.keys():
            # remove: can this be a list of strings or should it be one long string?
            facts.append(
                f'planned_action(train({key}),{actions[index][key]},{index}).\n')

    return (facts)


def convert_actions_to_flatland(actions) -> list:
    mapping = {"move_forward": RailEnvActions.MOVE_FORWARD, "move_right": RailEnvActions.MOVE_RIGHT,
               "move_left": RailEnvActions.MOVE_LEFT, "wait": RailEnvActions.STOP_MOVING}
    for index, dict in enumerate(actions):
        for key in dict.keys():
            actions[index][key] = mapping[actions[index][key]]
    return (actions)
