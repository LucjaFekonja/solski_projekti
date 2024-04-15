import matplotlib.pyplot as plt
import numpy as np

class Node:
    def __init__(self, name, left=None, left_distance=0, right=None, right_distance=0):
        self.name = name
        self.left = left
        self.left_distance = left_distance
        self.right = right
        self.right_distance = right_distance

"""
def plot_dendrogram(node, x=0, y=0, k=32, left_name="", right_name=""):
    # x in y sta začetni točki (v njej je root)
    # k je dolžina prečnih črt
    c = [np.random.random(), np.random.random(), np.random.random()]
    
    # Na začetku narišeš horizontal line 
    plt.plot([x - k/2, x + k/2], [y, y], color=c)

    # Narišeš oba veertical line-a in dopišeš dolžine
    plt.plot([x - k/2, x - k/2], [y, y - node.left_distance], color=c)
    plt.text(x - k/2 - 1, y - node.left_distance / 2 - 1/2, str(node.left_distance), fontsize = 10)
    plt.plot([x + k/2, x + k/2], [y, y - node.right_distance], color=c)
    plt.text(x + k/2 - 1, y - node.right_distance / 2 - 1/2, str(node.right_distance), fontsize = 10)

    # Če je node.left subnode, ponoviš plot_dendrogram
    if type(node.left) is Node:
        plot_dendrogram(node.left, x - k/2, y - node.left_distance, k/2, node.left, node.right)
    # Če je string, napišeš ime taxa
    if type(node.left) == str:
        print("Rišem: {}".format(node.name))
        print("Levi subnode: {}".format(left_name))
        print(x, y)
        plt.text(x - k/2 - 1/4, y - node.left_distance - 3/2, str(node.left), fontsize = 10)

    # Če je node.right subnode, ponoviš plot_dendrogram
    if type(node.right) is Node:
        plot_dendrogram(node.right, x + k/2, y - node.right_distance, k/2, node.left, node.right)
    # Če je string, napišeš ime taxa
    if type(node.right) == str:
        print("Rišem: {}".format(node.name))
        print("Desni subnode: {}".format(right_name))
        print(x, y)
        plt.text(x + k/2 - 1/4, y - node.right_distance - 3/2, str(node.right), fontsize = 10)
"""


def plot_dendrogram(node, x=0, y=0, k=32, left_name="", right_name=""):
    # x in y sta začetni točki (v njej je root)
    # k je dolžina prečnih črt
    c = [np.random.random(), np.random.random(), np.random.random()]
    
    # Na začetku narišeš vertical line 
    plt.plot([x, x], [y - k/2, y + k/2], color=c)

    # Narišeš oba horizontal line-a in dopišeš dolžine
    plt.plot([x, x + node.left_distance], [y - k/2, y - k/2], color=c)
    plt.text(x + node.left_distance / 2, y - k/2 + 1/4, str(node.left_distance), fontsize = 10)
    plt.plot([x, x + node.right_distance], [y + k/2, y + k/2], color=c)
    plt.text(x + node.right_distance / 2, y + k/2 + 1/4, str(node.right_distance), fontsize = 10)

    # Če je node.left subnode, ponoviš plot_dendrogram
    if type(node.left) is Node:
        plot_dendrogram(node.left, x + node.left_distance, y - k/2, k/2, node.left, node.right)
    # Če je string, napišeš ime taxa
    if type(node.left) == str:
        plt.text(x + node.left_distance + 1, y - k/2 - 1/2, str(node.left), fontsize = 10)

    # Če je node.right subnode, ponoviš plot_dendrogram
    if type(node.right) is Node:
        plot_dendrogram(node.right, x + node.right_distance, y + k/2, k/2, node.left, node.right)
    # Če je string, napišeš ime taxa
    if type(node.right) == str:
        plt.text(x + node.right_distance + 1, y + k/2 - 1/2, str(node.right), fontsize = 10)

# Example usage
root_node = Node("d", left=Node("a", left=Node("f",left="g",left_distance=19,right="h",right_distance=2), left_distance=3, right="c", right_distance=5), left_distance=8, right="e", right_distance=4)

# Set up the plot
plt.figure(figsize=(10, 5))
# plt.title('Dendrogram')
plt.axis('off')

# Plot the dendrogram
plot_dendrogram(root_node)

# Show the plot
plt.show()


[{'TaxId': '4718', 
  'ScientificName': 'Nypa fruticans', 
  'OtherNames': {'Misspelling': [], 
                 'Includes': [], 
                 'GenbankSynonym': [], 
                 'Acronym': [], 
                 'Misnomer': [], 
                 'Synonym': [], 
                 'Anamorph': [], 
                 'GenbankAnamorph': [], 
                 'Inpart': [], 
                 'CommonName': ['nypa palm'], 
                 'EquivalentName': [], 
                 'Teleomorph': [], 
                 'Name': [{'ClassCDE': 'authority', 'DispName': 'Nypa fruticans Wurmb, 1779'}, 
                          {'ClassCDE': 'misspelling', 'DispName': 'Nypa frucitans'}, 
                          {'ClassCDE': 'misspelling', 'DispName': 'Nypa fructians'}], 
                 'GenbankCommonName': 'nipa palm'}, 
  'ParentTaxId': '4717', 
  'Rank': 'species', 
  'Division': 'Plants and Fungi', 
  'GeneticCode': {'GCId': '1', 'GCName': 'Standard'}, 
  'MitoGeneticCode': {'MGCId': '1', 'MGCName': 'Standard'}, 
  'Lineage': 'cellular organisms; Eukaryota; Viridiplantae; Streptophyta; Streptophytina; Embryophyta; Tracheophyta; Euphyllophyta; Spermatophyta; Magnoliopsida; Mesangiospermae; Liliopsida; Petrosaviidae; commelinids; Arecales; Arecaceae; Nypoideae; Nypa', 
  'LineageEx': [{'TaxId': '131567', 'ScientificName': 'cellular organisms', 'Rank': 'no rank'}, 
                {'TaxId': '2759', 'ScientificName': 'Eukaryota', 'Rank': 'superkingdom'}, 
                {'TaxId': '33090', 'ScientificName': 'Viridiplantae', 'Rank': 'kingdom'}, 
                {'TaxId': '35493', 'ScientificName': 'Streptophyta', 'Rank': 'phylum'}, 
                {'TaxId': '131221', 'ScientificName': 'Streptophytina', 'Rank': 'subphylum'}, 
                {'TaxId': '3193', 'ScientificName': 'Embryophyta', 'Rank': 'clade'}, 
                {'TaxId': '58023', 'ScientificName': 'Tracheophyta', 'Rank': 'clade'}, 
                {'TaxId': '78536', 'ScientificName': 'Euphyllophyta', 'Rank': 'clade'}, 
                {'TaxId': '58024', 'ScientificName': 'Spermatophyta', 'Rank': 'clade'}, 
                {'TaxId': '3398', 'ScientificName': 'Magnoliopsida', 'Rank': 'class'}, 
                {'TaxId': '1437183', 'ScientificName': 'Mesangiospermae', 'Rank': 'clade'}, 
                {'TaxId': '4447', 'ScientificName': 'Liliopsida', 'Rank': 'clade'}, 
                {'TaxId': '1437197', 'ScientificName': 'Petrosaviidae', 'Rank': 'subclass'}, 
                {'TaxId': '4734', 'ScientificName': 'commelinids', 'Rank': 'clade'}, 
                {'TaxId': '40551', 'ScientificName': 'Arecales', 'Rank': 'order'}, 
                {'TaxId': '4710', 'ScientificName': 'Arecaceae', 'Rank': 'family'}, 
                {'TaxId': '169701', 'ScientificName': 'Nypoideae', 'Rank': 'subfamily'},
                  {'TaxId': '4717', 'ScientificName': 'Nypa', 'Rank': 'genus'}], 
  'Properties': [{'PropName': 'pgcode', 'PropValueInt': '11'}], 
  'CreateDate': '1995/02/27 09:24:00', 
  'UpdateDate': '2018/11/23 13:57:52', 
  'PubDate': '1996/06/20 01:00:00'}]

