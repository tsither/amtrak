import matplotlib.pyplot as plt
import networkx as nx

# Create a directed graph
G = nx.DiGraph()

# Add nodes with positions
nodes = [
    ((0, 0), 'n'), ((0, 0), 's'),
    ((1, 0), 'e'), ((1, 0), 'n'), ((1, 0), 's'),
    ((2, 0), 'n'), ((2, 0), 's'),
    ((1, 1), 'e'), ((1, 1), 'w'),
    ((0, 2), 'n'), ((0, 2), 's'),
    ((1, 2), 'w'), ((1, 2), 'n'), ((1, 2), 's'),
    ((2, 2), 'n'), ((2, 2), 's')
]

# Assign unique node IDs and positions
for i, ((x, y), direction) in enumerate(nodes):
    G.add_node(f"node{i}_{direction}", pos=(x, y))

# Add edges
edges = [
    ("node7_e", "node2_n", "h"), ("node2_n", "node7_e", "h"),
    ("node12_n", "node7_e", "h"), ("node7_e", "node12_n", "h"),
    ("node2_n", "node0_n", "v"), ("node0_n", "node2_n", "v"),
    ("node5_n", "node2_n", "v"), ("node2_n", "node5_n", "v"),
    ("node12_n", "node9_n", "v"), ("node9_n", "node12_n", "v"),
    ("node15_n", "node12_n", "v"), ("node12_n", "node15_n", "v")
]

# Add edges to the graph
for edge in edges:
    G.add_edge(edge[0], edge[1], label=edge[2])

# Extract positions for plotting
pos = nx.get_node_attributes(G, 'pos')

# Plot the graph
plt.figure(figsize=(10, 6))
nx.draw(
    G, pos,
    with_labels=True,
    node_size=500,
    node_color='skyblue',
    edge_color='gray',
    arrowsize=20
)

# Draw edge labels
edge_labels = nx.get_edge_attributes(G, 'label')
nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels)

plt.title("Graph Representation of Atoms and Edges")
plt.show()
