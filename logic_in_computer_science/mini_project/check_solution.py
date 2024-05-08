import SAT_solver
import sys

def check_solution(file, solution_file):
    with open(solution_file, "r") as f:
        lines_sol = f.readlines()[0]
    solution = [int(x) for x in lines_sol.strip().split(" ")]

    with open(file, "r") as f:
        lines = f.readlines()
    string_clauses = [x for x in lines if not (x.startswith("c") or x.startswith("p"))]
    clauses = [[int(y) for y in x.split(" ")[:-2]] for x in string_clauses]

    return sorted(solution) == sorted(SAT_solver.DPLL(clauses, [], dict()))


if __name__ == '__main__':
    file = str(sys.argv[1])
    solution_file = str(sys.argv[2])
    print(check_solution(file, solution_file))