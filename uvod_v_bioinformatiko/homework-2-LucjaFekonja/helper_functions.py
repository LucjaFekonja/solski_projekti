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


def print_table(list):
    m = len(list)
    for i in range(m):
        print(str(list[i]) + "\n") 

def score(a, b):
    if a == "-" or b == "-":
        return -2
    elif a == b:
        return 1
    else:
        return -1
    

def local_alignment(seq1, seq2, scoring_function):
    """Local sequence alignment using the Smith-Waterman algorithm.

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
    >>> local_alignment("the brown cat", "these brownies", lambda x, y: [-1, 1][x == y])
    ('the-- brown', 'these brown', 7.0)

    Other alignments are also possible.

    """
    n = len(seq1) + 1
    m = len(seq2) + 1

    # Output
    s1, s2 = "", ""

    # Create the initial matrix. Fill top row and left column with 0
    table = [[0] for _ in range(m)]
    table[0] += [0 for _ in range(n - 1)]

    # Fill the rest of the matrix using Smith-Waterman algorithm
    for j in range(1, m):
        for i in range(1, n):
            from_top = table[j-1][i] + scoring_function("-", seq2[j-1])
            from_left = table[j][i-1] + scoring_function(seq1[i-1], "-")
            from_diag = table[j-1][i-1] + scoring_function(seq1[i-1], seq2[j-1])

            if from_top >= from_left and from_top >= from_diag:
                table[j] += [max([0, from_top])]

            elif from_left >= from_diag:
                table[j] += [max([0, from_left])]

            else:
                table[j] += [max([0, from_diag])]


    # Find the maximum value in the matrix and it's position
    # We will take right-most, bottom-most element
    max_value = 0
    i_max, j_max = 0, 0

    for i, row in enumerate(table):
        if max_value <= max(row):
            max_value = max(row)

            row.reverse()
            i_max = len(row) - row.index(max_value) - 1
            j_max= i
            row.reverse()  # to keep table the same

    # Traceback
    while i_max > 0 and j_max > 0 and table[j_max][i_max] != 0:
        top = table[j_max - 1][i_max]
        left = table[j_max][i_max - 1]
        diag = table[j_max - 1][i_max - 1]
        
        if diag >= left and diag >= top:
            s1 += seq1[i_max - 1]
            s2 += seq2[j_max - 1]
            i_max -= 1
            j_max -= 1
        
        elif top >= left:
            s1 += "-"
            s2 += seq2[j_max - 1]
            j_max -= 1

        else:
            s1 += seq1[i_max - 1]
            s2 += "-"
            j_max -= 1

    return s1[::-1], s2[::-1], max_value
