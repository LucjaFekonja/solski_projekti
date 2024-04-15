"""Helper functions for HW3"""
import numpy as np
import random
import string
from copy import deepcopy
from matplotlib.axes import Axes
import matplotlib.pyplot as plt


class Node:
    def __init__(
        self,
        name: str,
        left: "Node",
        left_distance: float,
        right: "Node",
        right_distance: float,
        confidence: float = None,
    ):
        """A node in a binary tree produced by neighbor joining algorithm.

        Parameters
        ----------
        name: str
            Name of the node.
        left: Node
            Left child.
        left_distance: float
            The distance to the left child.
        right: Node
            Right child.
        right_distance: float
            The distance to the right child.
        confidence: float
            The confidence level of the split determined by the bootstrap method.
            Only used if you implement Bonus Problem 1.

        Notes
        -----
        The current public API needs to remain as it is, i.e., don't change the
        names of the properties in the template, as the tests expect this kind
        of structure. However, feel free to add any methods/properties/attributes
        that you might need in your tree construction.

        """
        self.name = name
        self.left = left
        self.left_distance = left_distance
        self.right = right
        self.right_distance = right_distance
        self.confidence = confidence


def generate_unique_string(existing_strings, length=10):
    while True:
        new_string = ''.join(random.choices(string.ascii_letters + string.digits, k=length))
        if new_string not in existing_strings:
            return new_string


def neighbor_joining(distances: np.ndarray, labels: list) -> Node:
    """The Neighbor-Joining algorithm.

    For the same results as in the later test dendrograms;
    add new nodes to the end of the list/matrix and
    in case of ties, use np.argmin to choose the joining pair.

    Parameters
    ----------
    distances: np.ndarray
        A 2d square, symmetric distance matrix containing distances between
        data points. The diagonal entries should always be zero; d(x, x) = 0.
    labels: list
        A list of labels corresponding to entries in the distances matrix.
        Use them to set names of nodes.

    Returns
    -------
    Node
        A root node of the neighbor joining tree.

    """
    taxa_names = labels
    nodes = dict()

    for taxa in labels: #
        nodes[taxa] = Node(taxa, left=None, left_distance=0, right=None, right_distance=0) #

    while len(labels) > 2:
        
        # Number of taxa
        t = len(labels)

        # COmpute all M(T_i, T_j)
        n, m = len(distances[0]), len(distances)
        M = np.zeros((n, m))
        for i in range(n):
            for j in range(m):
                M[i, j] = (t - 2) * distances[i, j] - np.sum(distances[i]) - np.sum(distances[j])

        min_index = np.argmin(np.triu(M, 1))
        min_row = min_index // n
        min_column = min_index % n

        # Join taxa label[min_row] and label[min_column]
        # Distance from label[min_row] to u (join)
        d1 = distances[min_row, min_column] / 2 + (np.sum(distances[min_row]) - np.sum(distances[min_column])) / (2 * (n - 2))
        # Distance from label[min_column] to u (join)
        d2 = distances[min_row, min_column] - d1

        # Distances from other taxa to u. Add a new row/column
        new_node = [[(distances[min_column, i] + distances[min_row, i] - distances[min_column, min_row]) / 2] for i in range(n)]

        # Add new node to distances
        distances = np.append(distances, new_node, axis=1)
        distances = np.append(distances, [[x[0] for x in new_node] + [0]], axis=0)

        # Create a name for the new node and save node
        new_node_name = generate_unique_string(taxa_names, 2)
        taxa_names += [new_node_name]

        # Create new node, that connects labels[min_row] and labels[min_column]
        if labels[min_row] in nodes and labels[min_column] in nodes:
            NODE = Node(new_node_name, nodes[labels[min_row]], d1, nodes[labels[min_column]], d2)

        nodes[new_node_name] = NODE

        # Delete rows min_row and min_column
        i_min = min(min_column, min_row)
        i_max = max(min_column, min_row)

        distances = np.delete(distances, i_max, axis=1)
        distances = np.delete(distances, i_max, axis=0)
        distances = np.delete(distances, i_min, axis=1)
        distances = np.delete(distances, i_min, axis=0)
        del labels[i_max]
        del labels[i_min]       

    # Now we should have 2x2 matrix
    d = distances[0,1]

    root_name = generate_unique_string(taxa_names, 2)
    taxa_names += root_name

    if labels[0] in nodes and labels[1] in nodes:
        ROOT = Node(root_name, nodes[labels[1]], d/2, nodes[labels[0]], d/2)

    return ROOT



def plot_nj_tree(node: Node, ax: Axes = None, x=0, y=0, groups=dict()) -> None:
    """A function for plotting neighbor joining phylogeny dendrogram.

    Parameters
    ----------
    tree: Node
        The root of the phylogenetic tree produced by `neighbor_joining(...)`.
    ax: Axes
        A matplotlib Axes object which should be used for plotting.
    kwargs
        Feel free to replace/use these with any additional arguments you need.
        But make sure your function can work without them, for testing purposes.

    Example
    -------
    >>> import matplotlib.pyplot as plt
    >>>
    >>> tree = neighbor_joining(distances)
    >>> fig, ax = plt.subplots(nrows=1, ncols=1, figsize=(8, 8))
    >>> plot_nj_tree(tree=tree, ax=ax)
    >>> fig.savefig("example.png")


    # Example usage
    root_node = Node("d", left=Node("a", left=Node("f",left="g",left_distance=19,right="h",right_distance=2), left_distance=3, right="c", right_distance=5), left_distance=8, right="e", right_distance=4)
    
    # Set up the plot
    plt.figure(figsize=(10, 5))
    # plt.title('Dendrogram')
    plt.axis('off')
    
    # Plot the dendrogram
    plot_dendrogram(root_node)

    """
    # Če je node.left subnode, ponoviš plot_dendrogram
    if node.left != None:
        if node.left.name in groups:
            group_left = groups[node.left.name]
            if group_left == "Alphacoronavirus":
                c_left = "teal"
            elif group_left == "Betacoronavirus":
                c_left = "goldenrod"
            elif group_left == "Gammacoronavirus":
                c_left = "limegreen"
            elif group_left == "Deltacoronavirus":
                c_left = "palevioletred"
            elif group_left == "Unknown":
                c_left = "darkred"
        else:
            c_left = [0, 0, 0]

        if node.right.name in groups:
            group_right = groups[node.right.name]
            if group_right == "Alphacoronavirus":
                c_right = "teal"
            elif group_right == "Betacoronavirus":
                c_right = "goldenrod"
            elif group_right == "Gammacoronavirus":
                c_right = "limegreen"
            elif group_right == "Deltacoronavirus":
                c_right = "palevioletred"
            elif group_right == "Unknown":
                c_right = "darkred"
        else:
            c_right = [0, 0, 0]

        # Nastavi merilo za y
        count_leaves_left = count_leaves(node.right)
        count_leaves_right = count_leaves(node.left)

        # Na začetku narišeš vertical line
        ax.plot([x, x], [y - count_leaves_left, y + count_leaves_right], color=[0, 0, 0])

        # Narišeš oba horizontal line-a in dopišeš dolžine
        ax.plot([x, x + node.left_distance], [y - count_leaves_left, y - count_leaves_left], color=c_left)
        ax.text(x + node.left_distance / 2 - 1, y - count_leaves_left + 1/4, str(round(node.left_distance)), fontsize = 6)
        ax.plot([x, x + node.right_distance], [y + count_leaves_right, y + count_leaves_right], color=c_right)
        ax.text(x + node.right_distance / 2 - 1, y + count_leaves_right + 1/4, str(round(node.right_distance)), fontsize = 6)

        # Ponoviš plot_dendrogram na levem in desnem poddrevesu
        plot_nj_tree(node.left, ax, x + node.left_distance, y - count_leaves_left, groups)
        plot_nj_tree(node.right, ax, x + node.right_distance, y + count_leaves_right, groups)

    # Če je string, napišeš ime taxa
    if node.left == None:
        if node.name in groups:
            group = groups[node.name]
            if group == "Alphacoronavirus":
                c = "teal"
            elif group == "Betacoronavirus":
                c = "goldenrod"
            elif group == "Gammacoronavirus":
                c = "limegreen"
            elif group == "Deltacoronavirus":
                c = "palevioletred"
            elif group == "Unknown":
                c = "darkred"
        else:
         c = [0, 0, 0]

        ax.text(x + node.left_distance + 2, y - 1/2, str(node.name), color = c)
    return ax


def _find_a_parent_to_node(tree: Node, node: Node) -> tuple:
    """Utility function for reroot_tree"""
    stack = [tree]

    while len(stack) > 0:

        current_node = stack.pop()
        # check if current_node is not a leaf
        if current_node.left != None:
            if node.name == current_node.left.name:
                return current_node, "left"
            elif node.name == current_node.right.name:
                return current_node, "right"

            stack += [
                n for n in [current_node.left, current_node.right] if n.left is not None
            ]

    return None

def _remove_child_from_parent(parent_node: Node, child_location: str) -> None:
    """Utility function for reroot_tree"""
    setattr(parent_node, child_location, None)
    setattr(parent_node, f"{child_location}_distance", 0.0)


def reroot_tree(original_tree: Node, outgroup_node: Node) -> Node:
    """A function to create a new root and invert a tree accordingly.

    This function reroots tree with nodes in original format. If you
    added any other relational parameters to your nodes, these parameters
    will not be inverted! You can modify this implementation or create
    additional functions to fix them.

    Parameters
    ----------
    original_tree: Node
        A root node of the original tree.
    outgroup_node: Node
        A Node to set as an outgroup (already included in a tree).
        Find it by it's name and then use it as parameter.

    Returns
    -------
    Node
        Inverted tree with a new root node.
    """
    tree = deepcopy(original_tree)

    parent, child_loc = _find_a_parent_to_node(tree, outgroup_node)
    distance = getattr(parent, f"{child_loc}_distance")
    _remove_child_from_parent(parent, child_loc)

    new_root = Node("new_root", parent, distance / 2, outgroup_node, distance / 2)
    child = parent

    while tree != child:
        parent, child_loc = _find_a_parent_to_node(tree, child)

        distance = getattr(parent, f"{child_loc}_distance")
        _remove_child_from_parent(parent, child_loc)

        empty_side = "left" if child.left is None else "right"
        setattr(child, f"{empty_side}_distance", distance)
        setattr(child, empty_side, parent)

        if tree.name == parent.name:
            break
        child = parent

    other_child_loc = "right" if child_loc == "left" else "left"
    other_child_distance = getattr(parent, f"{other_child_loc}_distance")

    setattr(child, f"{empty_side}_distance", other_child_distance + distance)
    setattr(child, empty_side, getattr(parent, other_child_loc))

    return new_root


# Count the children of a tree
def count_leaves(t : Node):
    if t is None:
        return 0
    if t.left is None:
        return 1
    return count_leaves(t.left) + count_leaves(t.right)

# Count the children of a tree
def count_subnodes(t : Node):
    if t is None:
        return 0
    if t.left is None:
        return 1
    return count_subnodes(t.left) + count_subnodes(t.right) + 1

def sort_children(tree: Node) -> None:
    """Sort the children of a tree by their corresponding number of leaves.

    The tree can be changed inplace.

    Paramteres
    ----------
    tree: Node
        The root node of the tree.

    """
    # if tree is leaf (left and right subtree are None) return tree
    if tree is None:
        return tree
    
    # Count the children of the left and right subtree
    count_left = count_leaves(tree.left)
    count_right = count_leaves(tree.right)
    
    # If left subtree has more leaves than right, exchange left and right subtree
    if count_left > count_right:
        return Node(tree.name, 
                    left=sort_children(tree.right), 
                    left_distance=tree.right_distance, 
                    right=sort_children(tree.left), 
                    right_distance=tree.left_distance)
    else:
        return tree
    


def plot_nj_tree_radial(tree: Node, ax: Axes = None, **kwargs) -> None:
    """A function for plotting neighbor joining phylogeny dendrogram
    with a radial layout.

    Parameters
    ----------
    tree: Node
        The root of the phylogenetic tree produced by `neighbor_joining(...)`.
    ax: Axes
        A matplotlib Axes object which should be used for plotting.
    kwargs
        Feel free to replace/use these with any additional arguments you need.

    Example
    -------
    >>> import matplotlib.pyplot as plt
    >>>
    >>> tree = neighbor_joining(distances)
    >>> fig, ax = plt.subplots(nrows=1, ncols=1, figsize=(8, 8))
    >>> plot_nj_tree_radial(tree=tree, ax=ax)
    >>> fig.savefig("example_radial.png")

    """
    raise NotImplementedError()


def global_alignment(seq1, seq2, scoring_function):
    """Global sequence alignment using the Needleman–Wunsch algorithm.

    Indels should be denoted with the "-" character.

    Parameters
    ----------
    seq1: str
        First sequence to be aligned.
    seq2: str
        Second sequence to be aligned.
    scoring_function: Callable

    Returns
    -------
    str
        First aligned sequence.
    str
        Second aligned sequence.
    float
        Final score of the alignment.

    Examples
    --------
    >>> global_alignment("the brown cat", "these brownies", lambda x, y: [-1, 1][x == y])
    ('the-- brown cat', 'these brownies-', 3.0)

    Other alignments are also possible.

    """

    # output
    s1, s2 = "", ""

    # create empty table
    n = len(seq1) + 1 
    m = len(seq2) + 1
    table = [[] for _ in range(m)]

    direction_table = [[] for _ in range(m)]

    # insert first row and column
    for i in range(n):
        table[0] += [i * scoring_function(seq1[i - 1], "-")]
        direction_table[0] += ["L"]
    
    for j in range(1, m):
        table[j] += [j * scoring_function("-", seq2[j - 1])]
        direction_table[j] += ["T"]

    # complete the table using the Needleman–Wunsch algorithm
    for j in range(1, m):
        for i in range(1, n):
            from_top = table[j-1][i] + scoring_function("-", seq2[j-1])
            from_left = table[j][i-1] + scoring_function(seq1[i-1], "-")
            from_diag = table[j-1][i-1] + scoring_function(seq1[i-1], seq2[j-1])

            # say we prefer to come from top > diagonally > from left
            if from_top >= from_left and from_top >= from_diag:
                table[j] += [from_top]
                direction_table[j] += ["T"]
            
            elif from_left >= from_diag:
                table[j] += [from_left]
                direction_table[j] += ["L"]

            else:
                table[j] += [from_diag]
                direction_table[j] += ["D"]
            

    # start in the bottom right most corner and go by the pathway described in direction table.
    # 'L' in direction table means we have to move left...
    l = len(seq1) 
    k = len(seq2)
    while k >= 0 and l >= 0:
            if direction_table[k][l] == "D":
                s1 += seq1[l-1]
                s2 += seq2[k-1]
                k -= 1
                l -= 1
            elif direction_table[k][l] == "T":
                s1 += "-"
                s2 += seq2[k-1]
                k -= 1
            else: # direction_table[k][l] == "L"
                s1 += seq1[l-1]
                s2 += "-"
                l -= 1

    # print_table(table)
    # print_table(direction_table)
    return s1[0:-1][::-1], s2[0:-1][::-1], table[-1][-1] 
