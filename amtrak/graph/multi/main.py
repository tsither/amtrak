import clingo
import time

class BuildGraph:
    def __init__(self, instance_file, edge_builder_file="build_edges.lp", graph='graph.lp'):
        self.graph_edges = []
        self.graph_control = clingo.Control()
        
        # Load multiple files: both the instance file and the graph logic
        self.graph_control.load(instance_file)  # Load the instance-specific data
        self.graph_control.load(edge_builder_file)     # Load the graph generation rules
        self.graph_control.load(graph)
        
        # Ground the program
        self.graph_control.ground([("base", [])])
        
        # Solve and collect edges
        self.graph_control.solve(on_model=self.collect_graph)

        print(f"Computed {len(self.graph_edges)} graph edges")
    
    def collect_graph(self, model):
        """Collect edge atoms from the model with the format edge(A,B,(OUT,IN),Length)"""
        for atom in model.symbols(shown=True):
            if atom.name == "edge" and len(atom.arguments) == 4:
                # Check if the third argument is a tuple (OUT,IN)
                if atom.arguments[2].type == clingo.SymbolType.Function and len(atom.arguments[2].arguments) == 2:
                    self.graph_edges.append(atom)
    
    def get_edges(self):
        """Return the collected edges"""
        return self.graph_edges
    
    def print_edges(self):
        """Print the edges in a readable format"""
        for edge in self.graph_edges:
            a = edge.arguments[0]
            b = edge.arguments[1]
            out_in = edge.arguments[2]
            length = edge.arguments[3]
            print(f"Edge from {a} to {b}, ports ({out_in.arguments[0]},{out_in.arguments[1]}), length {length}")

model_count = 0

def on_model(model):
        global model_count
        model_count += 1
        print("\n=== Solution Found ===")
        
        # Get all shown atoms
        shown_atoms = model.symbols(shown=True)
        
        # Filter for only 'action' atoms
        action_atoms = [atom for atom in shown_atoms if atom.name == "action"]
        
        if action_atoms:
            print(f"Found {len(action_atoms)} action atoms:")
            
            # Group actions by time step
            actions_by_time = {}
            for atom in action_atoms:
                # Assuming the last argument is time
                time = atom.arguments[-1].number
                if time not in actions_by_time:
                    actions_by_time[time] = []
                actions_by_time[time].append(atom)
            
            # Print actions grouped by time step
            for time in sorted(actions_by_time.keys()):
                print(f"\nTime step {time}:")
                for atom in actions_by_time[time]:
                    # Format the output as desired
                    # Assuming action(agent, move, time)
                    agent = atom.arguments[0]
                    move = atom.arguments[1]
                    print(f"  Agent {agent}: {move}")
        else:
            print("No 'action' atoms found in the solution.")


        print("======================\n")
        return True

# Example usage:
if __name__ == "__main__":
    # Create a graph builder that loads both the instance and graph logic
    # graph_builder = BuildGraph("../test_envs/test_env_2/test_env_2.lp")
    start_time = time.perf_counter()

    graph_builder = BuildGraph("/Users/mymac/Desktop/Trains/flatland/envs/lp/env_009--4_3.lp")

    # Get the computed edges
    edges = graph_builder.get_edges()
    
    # Print edges in a readable format
    # graph_builder.print_edges()
    
    # Now you can use these edges with a TSP solver
    flatland = clingo.Control()
    flatland.load('graph.lp')
    flatland.load("/Users/mymac/Desktop/Trains/flatland/envs/lp/env_009--4_3.lp")
    flatland.load("solve.lp")
    # flatland.load('graph.lp')
    # flatland.load("/Users/mymac/Desktop/Trains/flatland/envs/lp/env_009--4_3.lp")

    for edge in edges:
        # Create an external declaration for this specific edge
        flatland.add("base", [], f"#external {edge}.")
        # print(f"Added external declaration for {edge}")

    flatland.ground([("base", [])])
    
    # Assign external atoms for each edge
    for edge in edges:
        flatland.assign_external(edge, True)
        # print(f"Assigned external {edge} to True")

    # Solve with the detailed callback
    print("\nSolving TSP problem...")
    # flatland.configuration.solve.models = 1

    # result = flatland.solve(on_model=on_model)
    flatland.configuration.solve.models = 1
    with flatland.solve(yield_=True) as handle:
        for model in handle:
            on_model(model)
    
# Get the solve result
        result = handle.get()
    # Print solving statistics
    
    print(f"\nTotal number of stable models found: {model_count}")
    print(f"Solving finished with result: {result}")
    end_time = time.perf_counter()
    print(f"Execution time: {end_time - start_time:.6f} seconds")
