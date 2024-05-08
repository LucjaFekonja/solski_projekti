import SAT_solver
import sys

def write_solution(file, output_file):

    with open(file, "r") as f:
        lines = f.readlines()

    string_clauses = [x for x in lines if not (x.startswith("c") or x.startswith("p"))]
    clauses = [[int(y) for y in x.split(" ")[:-2]] for x in string_clauses]
    solution = [str(x) for x in SAT_solver.DPLL(clauses, [], dict())]
    s = " ".join(solution)

    with open(output_file, "w") as f:
        f.write(s)


if __name__ == '__main__':
    file = str(sys.argv[1])
    output_file = str(sys.argv[2])
    write_solution(file, output_file)