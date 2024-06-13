import numpy as np 
import matplotlib.pyplot as plt

# File 
file = "test5.txt"
output_file = "output.txt"

def read_file(file):
    # Read txt file and create list of points
    f = open(file, "r")
    s = f.read().split("\n")
    points = [[float(y) for y in x.strip().split(" ")] for x in s]
    
    # Get list of vertices for each polygon
    P = np.array([tuple(x) for x in zip(points[0], points[1])])
    Q = np.array([tuple(x) for x in zip(points[2], points[3])])
    
    # Sort vertices in clockwise order (done in linear time)
    P = sort_coordinates(P)
    Q = sort_coordinates(Q)
    return (P, Q)

def sort_coordinates(points):
    # TEGA NAJ NE BI RABLA
    center_x, center_y = points.mean(0)
    x, y = points.T
    angles = np.arctan2(x - center_x, y - center_y)
    indices = np.argsort(angles)
    clockwise = points[indices]
    points = clockwise[::-1]
    return points

def absolute_value(x):
    return x[0] ** 2 + x[1] ** 2


def find_bridges(P, Q):
    # Find maximum y-coordinate for each polygon 
    i = np.argmax([x[1] for x in P])
    j = np.argmax([x[1] for x in Q])

    # Draw a vertical line
    v = [-1, 0]

    # Initialite while loop
    rotation = 0
    bridges = []

    while rotation < 2 * np.pi:
        # Calculate vector on the edge of P between p_i and p_i+1
        i_next = (i + 1) % len(P)
        pi = P[i]
        pi_next = P[i_next]
        p_vec = [pi_next[0] - pi[0], pi_next[1] - pi[1]]

        # Calculate vector on the edge of Q between q_j and q_j+1
        j_next = (j + 1) % len(Q)
        qj = Q[j]
        qj_next = Q[j_next]
        q_vec = [qj_next[0] - qj[0], qj_next[1] - qj[1]]

        # Find minimum angle between vertical line and p_vec / q_vec
        theta_P = np.arccos(np.dot(v, p_vec) / ((absolute_value(v)**(1/2)) * (absolute_value(p_vec)**(1/2))))
        theta_Q = np.arccos(np.dot(v, q_vec) / ((absolute_value(v)**(1/2)) * (absolute_value(q_vec)**(1/2))))

        if theta_P >=  np.pi:
            theta_P -= np.pi
        elif theta_Q >= np.pi:
            theta_Q -= np.pi

        if theta_P != theta_Q:
            # Check if all points p_i-1, p_i+1, q_j-1, q_j+1 lay on the same side of the line (bridge)
            qj = Q[j]
            pi = P[i]
            line = [pi[0] - qj[0], pi[1] - qj[1]]
            c1 = np.sign(np.cross(line, [pi[0] - P[(i - 1) % len(P)][0], pi[1] - P[(i - 1) % len(P)][1]]))
            c2 = np.sign(np.cross(line, [pi[0] - P[(i + 1) % len(P)][0], pi[1] - P[(i + 1) % len(P)][1]]))
            c3 = np.sign(np.cross(line, [pi[0] - Q[(j - 1) % len(Q)][0], pi[1] - Q[(j - 1) % len(Q)][1]]))
            c4 = np.sign(np.cross(line, [pi[0] - Q[(j + 1) % len(Q)][0], pi[1] - Q[(j + 1) % len(Q)][1]]))
            if len(set([c1, c2, c3, c4])) == 1:
                bridges += [(pi, qj)]

        else: # parallel edges!
            # We have to consider lines [p_i, q_i-1], [p_i-1, q_i], [p_i-1, q_i-1], [p_i, q_i]
            qj = Q[j]
            pi = P[i]
            q_prev = Q[(j - 1) % len(Q)]
            p_prev = P[(i - 1) % len(P)]
            q_next = Q[(j + 1) % len(Q)]
            p_next = P[(i + 1) % len(P)]

            # Line through p_i and q_i-1
            line1 = [pi[0] - q_prev[0], pi[1] - q_prev[1]]
            c1 = np.sign(np.cross(line1, [pi[0] - p_prev[0], pi[1] - p_prev[1]]))
            c2 = np.sign(np.cross(line1, [pi[0] - p_next[0], pi[1] - p_next[1]]))
            c3 = np.sign(np.cross(line1, [pi[0] - Q[(j - 2) % len(Q)][0], pi[1] - Q[(j - 2) % len(Q)][1]]))
            c4 = np.sign(np.cross(line1, [pi[0] - qj[0], pi[1] - qj[1]]))
            if len(set([c1, c2, c3, c4])) == 1:
                bridges += [(pi, q_prev)]

            # Line through p_i-1 and q_i
            line2 = [p_prev[0] - qj[0], p_prev[1] - qj[1]]
            c1 = np.sign(np.cross(line2, [p_prev[0] - P[(i - 2) % len(P)][0], p_prev[1] - P[(i - 2) % len(P)][1]]))
            c2 = np.sign(np.cross(line2, [p_prev[0] - pi[0], p_prev[1] - pi[1]]))
            c3 = np.sign(np.cross(line2, [p_prev[0] - q_prev[0], p_prev[1] - q_prev[1]]))
            c4 = np.sign(np.cross(line2, [p_prev[0] - q_next[0], p_prev[1] - q_next[1]]))
            if len(set([c1, c2, c3, c4])) == 1:
                bridges += [(p_prev, qj)]

            # Line through p_i-1 and q_i-1
            line3 = [p_prev[0] - q_prev[0], p_prev[1] - q_prev[1]]
            c1 = np.sign(np.cross(line3, [p_prev[0] - P[(i - 2) % len(P)][0], p_prev[1] - P[(i - 2) % len(P)][1]]))
            c2 = np.sign(np.cross(line3, [p_prev[0] - pi[0], p_prev[1] - pi[1]]))
            c3 = np.sign(np.cross(line3, [p_prev[0] - Q[(j - 2) % len(Q)][0], p_prev[1] - Q[(j - 2) % len(Q)][1]]))
            c4 = np.sign(np.cross(line3, [p_prev[0] - qj[0], p_prev[1] - qj[1]]))
            if len(set([c1, c2, c3, c4])) == 1:
                bridges += [(p_prev, q_prev)]

            # Line through p_i and q_i
            line4 = [pi[0] - qj[0], pi[1] - qj[1]]
            c1 = np.sign(np.cross(line4, [pi[0] - p_prev[0], pi[1] - p_prev[1]]))
            c2 = np.sign(np.cross(line4, [pi[0] - p_next[0], pi[1] - p_next[1]]))
            c3 = np.sign(np.cross(line4, [pi[0] - q_prev[0], pi[1] - q_prev[1]]))
            c4 = np.sign(np.cross(line4, [pi[0] - q_next[0], pi[1] - q_next[1]]))
            if len(set([c1, c2, c3, c4])) == 1:
                bridges += [(pi, qj)]

        if theta_P < theta_Q:
            # Consider points pi = p1 and qj = q and points p_i-1, p_i+1, q_j-1, q_j+1.
            i = i_next
            # Rotate the vertical line by theta_P
            rotation += theta_P
            v = [v[0] * np.cos(theta_P) - v[1] * np.sin(theta_P), v[0] * np.sin(theta_P) + v[1] * np.cos(theta_P)]

        elif theta_P > theta_Q:
            # Consider points pi = p and qj = q
            j = j_next
            # Rotate the vertical line by theta_Q
            rotation += theta_Q
            v = [v[0] * np.cos(theta_Q) - v[1] * np.sin(theta_Q), v[0] * np.sin(theta_Q) + v[1] * np.cos(theta_Q)]

        else: # theta_P == theta_Q
            i = i_next
            j = j_next
            rotation += theta_P
            v = [v[0] * np.cos(theta_P) - v[1] * np.sin(theta_P), v[0] * np.sin(theta_P) + v[1] * np.cos(theta_P)]

    return bridges


def set_of_bridges(bridges):
    # A set of bridges without repetitions
    bridges_aux = [(tuple(pair[0]), tuple(pair[1])) for pair in bridges]
    bridges = []
    for b in bridges_aux:
        if b not in bridges and b[0] != b[1]:
            bridges += [b]
    return bridges


def make_hull(P, Q, bridges):

    if len(bridges) == 0:
        i = np.argmax([x[1] for x in P])
        j = np.argmax([x[1] for x in Q])
        if i > j:
            return P
        else:
            return Q

    iP = P.index(bridges[0][0])
    jP = P.index(bridges[1][0])
    iQ = Q.index(bridges[0][1])
    jQ = Q.index(bridges[1][1])

    i = P.index(bridges[0][0])

    edge = [P[i][0] - P[(i+1)%len(P)][0], P[i][1] - P[(i+1)%len(P)][1]]
    bridge1 = [bridges[0][0][0] - bridges[0][1][0], bridges[0][0][1] - bridges[0][1][1]]
    bridge2 = [bridges[0][0][0] - bridges[1][0][0], bridges[0][0][1] - bridges[1][0][1]]
    bridge3 = [bridges[0][0][0] - bridges[1][1][0], bridges[0][0][1] - bridges[1][1][1]]

    c1 = np.sign(np.cross(edge, bridge1))
    c2 = np.sign(np.cross(edge, bridge2))
    c3 = np.sign(np.cross(edge, bridge3))

    if len(set([c1, c2, c3])) == 1:
        if iP < jP and jQ < iQ:
            return P[iP : jP + 1] + Q[jQ : iQ + 1]
        elif iP < jP and jQ > iQ:
            return P[iP : jP + 1] + Q[jQ :] + Q[: iQ + 1]
        elif iP > jP and jQ < iQ:
            return P[iP :] + P[: jP + 1] + Q[jQ : iQ + 1]
        else:
            return P[iP :] + P[: jP + 1] + Q[jQ :] + Q[: iQ + 1]
        
    else:
        if jP < iP and iQ < jQ:
            return P[jP : iP + 1] + Q[iQ : jQ + 1]
        elif jP < iP and iQ > jQ:
            return P[jP : iP + 1] + Q[iQ :] + Q[: jQ + 1]
        elif jP > iP and iQ < jQ:
            return P[jP :] + P[: iP + 1] + Q[iQ : jQ + 1]
        else:
            return P[jP :] + P[: iP + 1] + Q[iQ :] + Q[: jQ + 1]


def draw(P, Q, hull):
    # Plot both P and Q and the convex hull of their union
    plt.plot([x[0] for x in P] + [P[0][0]], [x[1] for x in P] + [P[0][1]])
    plt.plot([x[0] for x in Q] + [Q[0][0]], [x[1] for x in Q] + [Q[0][1]])
    plt.plot([x[0] for x in hull] + [hull[0][0]], [x[1] for x in hull] + [hull[0][1]], linestyle='dashed')
    plt.show()


#################################################################################################
##############################  CHECK IF THERE IS AN INTERSECTION  ##############################
#################################################################################################

def get_edges(P, Q):
    edges_P = [(P[i], P[i+1]) for i in range(len(P) - 1)] + [(P[-1], P[0])]
    edges_Q = [(Q[i], Q[i+1]) for i in range(len(Q) - 1)] + [(Q[-1], Q[0])]
    return edges_P + edges_Q

def rotate_point_by_90(point):
    # angle given in radians
    rotation_matrix = np.array([[0, -1], [1, 0]])
    point = np.array(point)
    rotated_point = np.dot(rotation_matrix, point)
    return tuple(rotated_point)

def list_of_normals(edges):
    normals = []
    for edge in edges:
        P1, P2 = edge
        P1_rot = rotate_point_by_90(P1)
        P2_rot = rotate_point_by_90(P2)
        n = (P1_rot[0] - P2_rot[0], P1_rot[1] - P2_rot[1])
        normals += [(n[0] / absolute_value(n), n[1] / absolute_value(n))]
    return normals

def project_point_to_normal(point, normal):
    # Convert to numpy arrays
    p = np.array(point)
    n = np.array(normal)
    # Project the point onto the line
    projection = np.dot(p, n) / np.dot(n, n) * n
    return tuple(projection)

def project_list_of_points(points, normal):
    projections = []
    for p in points:
        projections += [project_point_to_normal(p, normal)]
    return projections

def check_intersection(P, Q):
    edges = get_edges(P, Q)
    normals = list_of_normals(edges)
    for n in normals:
        projections_Px = [x[0] for x in project_list_of_points(P, n)]
        projections_Qx = [x[0] for x in project_list_of_points(Q, n)]
        if len(set(projections_Px + projections_Qx)) != 1:
            min_P, max_P = min(projections_Px), max(projections_Px)
            min_Q, max_Q = min(projections_Qx), max(projections_Qx)
            if (min_P < max_Q and max_P < min_Q) or (min_Q < max_P and max_Q < min_P):
                return False
        else:
            projections_Py = [x[1] for x in project_list_of_points(P, n)]
            projections_Qy = [x[1] for x in project_list_of_points(Q, n)]
            min_P, max_P = min(projections_Py), max(projections_Py)
            min_Q, max_Q = min(projections_Qy), max(projections_Qy)
            if (min_P < max_Q and max_P < min_Q) or (min_Q < max_P and max_Q < min_P):
                return False
    return True

points = read_file(file)
P = points[0]
Q = points[1]


#########################################  OUTPUT FILE  #########################################  

def write_output(hull, intersection, output_file):
    hull_x = [x[0] for x in hull]
    x_line = " ".join([str(int(x)) if x.is_integer() else str(x) for x in hull_x])
    hull_y = [x[1] for x in hull]
    y_line = " ".join([str(int(x)) if x.is_integer() else str(x) for x in hull_y])
    to_write = x_line + "\n" + y_line + "\n" + str(intersection)

    f = open(output_file, "w+")
    f.write(to_write)
    f.close()


def main(file):
    points = read_file(file)
    P = points[0]
    Q = points[1]

    bridges = find_bridges(P, Q)
    bridges = set_of_bridges(bridges)

    P = [tuple(x) for x in list(P)]
    Q = [tuple(x) for x in list(Q)]
    bridges = [tuple(x) for x in list(bridges)]
    hull = make_hull(P, Q, bridges)
    print(hull)
    # (i, hull, start, case, on_bridge) = initialize_hull(P, Q, bridges)
    # hull = create_hull(i, hull, P, Q, start, case, bridges, on_bridge)

    intersection = check_intersection(P, Q)

    output_file = file[:-4] + "_output.txt"
    write_output(hull, intersection, output_file)
    draw(P, Q, hull)
    

if __name__ == '__main__':
    main(file)

