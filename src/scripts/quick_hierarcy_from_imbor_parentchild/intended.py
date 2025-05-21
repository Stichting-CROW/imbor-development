import csv
from collections import defaultdict

def create_tree_view(csv_file):
    # Create a dictionary to store parent-child relationships
    tree = defaultdict(list)
    all_nodes = set()
    
    # Read the CSV and build the tree structure
    with open(csv_file, 'r') as file:
        reader = csv.reader(file, delimiter=';')
        line_count = 0
        for row in reader:
            line_count += 1
            if len(row) < 2:
                print(f"Warning: Invalid row at line {line_count}: {row}")
                continue
            parent, child = row[0].strip(), row[1].strip()
            tree[parent].append(child)
            all_nodes.add(parent)
            all_nodes.add(child)
    
    print(f"Total number of unique nodes: {len(all_nodes)}")
    print(f"Total number of relationships: {line_count}")
    
    # Find root nodes (parents that are never children)
    all_children = set()
    for children in tree.values():
        all_children.update(children)
    root_nodes = set(tree.keys()) - all_children
    
    if not root_nodes:
        print("Warning: No root nodes found. This might indicate a circular dependency.")
        # Use all parent nodes as roots if no clear roots are found
        root_nodes = set(tree.keys())
    
    print(f"Number of root nodes found: {len(root_nodes)}")
    
    # Function to check for circular dependencies
    def check_path(node, path):
        if node in path:
            print(f"Warning: Circular dependency detected: {' -> '.join(path)} -> {node}")
            return True
        return False
    
    # Function to print tree recursively
    def print_tree(node, level=0, path=None, output_file=None):
        if path is None:
            path = []
        
        if check_path(node, path):
            return
        
        prefix = "    " * level  # 4 spaces per level
        print(f"{prefix}├── {node}", file=output_file)
        
        # Print to console for debugging
        print(f"{prefix}├── {node}")
        
        if node in tree:
            for child in sorted(tree[node]):
                print_tree(child, level + 1, path + [node], output_file)
    
    # Print to file
    with open('hierarchy_tree.txt', 'w', encoding='utf-8') as f:
        print("Root nodes:", sorted(root_nodes))
        for root in sorted(root_nodes):
            print_tree(root, output_file=f)

# Use the function
create_tree_view('ParentChild.csv')