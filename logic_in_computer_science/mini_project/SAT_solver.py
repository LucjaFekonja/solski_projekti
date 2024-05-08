import copy

file = "sudoku_hard.txt"
solution_file = "sudoku_hard_solution.txt"


def contains_unit(clauses):
    lengths = list(map(lambda l: len(l), clauses))
    if 1 in lengths:
        return lengths
    else:
        return False
    
def contains_pure(clauses):
    pure = []
    impure = []
    for C in clauses:
        for L in C:
            if L not in pure and -L not in pure and L not in impure:
                pure.append(L)
            elif -L in pure:
                pure.remove(-L)
                impure.append(L)
                impure.append(-L)
    if len(pure) == 0:
        return False
    else:
        return pure[0]


def simplify(clauses, L):
    new_clauses = []
    for C in clauses:
        if L in C:
            continue
        elif -L in C:
            C.remove(-L)
            new_clauses.append(C)
        else:
            new_clauses.append(C)
    return new_clauses
        

def DPLL(clauses, A, history):
    if len(clauses) == 0:
        return A
    
    elif [] in clauses:
        return False
    
    elif contains_unit(clauses):
        # Find the unit clause
        lengths = contains_unit(clauses)
        index = lengths.index(1)
        C = clauses[index]

        # Append to A and simplify clauses
        A.append(C[0])
        clauses = simplify(clauses, C[0])
        return DPLL(clauses, A, history)
    
    elif contains_pure(clauses):
        L = contains_pure(clauses)
        A.append(L)
        clauses = simplify(clauses, L)
        return DPLL(clauses, A, history)
    
    else:
        L = clauses[0][0]
        history[L] = copy.deepcopy(clauses)
        A.append(L)
        clauses = simplify(clauses, L)
        output = DPLL(clauses, A, history)

        if output:
            return output
        else:
            index = A.index(L)
            A = A[:index]
            A.append(-L)
            clauses = history[L]
            clauses = simplify(clauses, -L)
            return DPLL(clauses, A, history)
