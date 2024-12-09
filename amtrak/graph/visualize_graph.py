import networkx as nx
import matplotlib.pyplot as plt
import re
import subprocess

def parse_clingo_output(clingo_output):
    nodes = set()
    edges = []

    # Regular expression to capture node coordinates
    node_pattern = r"node\((\d+),(\d+)\)"
    # Regular expression to capture edge coordinates
    edge_pattern = r"edge\(\((\d+),(\d+)\),\s?\((\d+),(\d+)\)\)"

    # Find nodes in the output
    for node_match in re.finditer(node_pattern, clingo_output):
        x, y = node_match.groups()
        nodes.add((int(x), int(y)))

    # Find edges in the output
    for edge_match in re.finditer(edge_pattern, clingo_output):
        x1, y1, x2, y2 = edge_match.groups()
        edges.append(((int(x1), int(y1)), (int(x2), int(y2))))

    return nodes, edges

def visualize_graph(nodes, edges):
    # Create a graph object
    G = nx.Graph()

    # Add nodes and edges to the graph
    G.add_nodes_from(nodes)
    G.add_edges_from(edges)

    # Create a plot
    plt.figure(figsize=(8, 6))

    # Position nodes based on their coordinates (rotate by swapping x and y)
    pos = {node: (node[1], -node[0]) for node in nodes}  # Swap and negate y for clockwise rotation

    # Draw nodes, labels, and edges
    nx.draw_networkx_nodes(G, pos, node_size=700, node_color='lightblue')
    nx.draw_networkx_labels(G, pos, font_size=12, font_weight='bold')
    nx.draw_networkx_edges(G, pos, width=2, alpha=0.5, edge_color='gray')

    plt.title("Rotated Graph Visualization (90 degrees)")
    plt.axis('off')  # Hide axis
    plt.show()

if __name__ == "__main__":
    # Sample clingo output (replace this with actual clingo output)

    # result = subprocess.run(['clingo', '/Users/mymac/Desktop/Trains/flatland/amtrak/graph/node_all.lp'], capture_output=True, text=True)
    # # print(result)

    # atom_pattern = r'\b(edge\([^)]+\)|node\([^)]+\))\b'

    # # Find all matches for the atoms
    # atoms = re.findall(atom_pattern, result.stdout)
    # if result.returncode == 0:
    #     # Regular expression to match the atoms (edge and node facts)
    #     atom_pattern = r'\b(edge\([^)]+\)|node\([^)]+\))\b'

    #     # Find all matches for the atoms
    #     atoms = re.findall(atom_pattern, result.stdout)

    #     # Print the filtered atoms
    # print("Filtered Atoms:")
    # for atom in atoms:
    #     print(atom)
    # else:
    #     print("Clingo command failed")
    #     print("Error message:", result.stderr)
                
    clingo_output = """

    """

    # Parse the clingo output
    nodes, edges = parse_clingo_output(clingo_output)

    # Check that edges are correctly parsed
    print("Nodes:", nodes)
    print("Edges:", edges)

    # Visualize the graph
    visualize_graph(nodes, edges)
