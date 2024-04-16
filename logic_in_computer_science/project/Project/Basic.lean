import Mathlib
def hello := "world"

/- natural numbers -/
inductive mynat : Type
| myzero : mynat
| mysucc : mynat → mynat

/- Binary trees -/
/- Induktivno generirane: root (.), succ(T - .). jount (T1 - . - T2) -/
inductive binary_tree : Type
| root
| succ : binary_tree → binary_tree
| join : (T1 T2 : binary_tree) → binary_tree

/- The hight of binary tree -/
def binary_tree.height : binary_tree -> ℕ
| .root => 0
| .succ T => T.height + 1
| .join T1 T2 => max T1.height T2.height + 1

/- The number of leaves in binary tree -/
def binary_tree.number_of_leaves : binary_tree → ℕ
| .root => 1
| .succ T => T.number_of_leaves
| .join T1 T2 => T1.number_of_leaves + T2.number_of_leaves


/- Full Binary trees -/
/- Nodes can only be zero or two branching -/
inductive full_binary_tree : Type
| root
| join : (T1 T2 : full_binary_tree) → full_binary_tree
/- Na root lahko gledaš kot na leaf -/

/- Converting a binary tree into a full binary tree, by forgetting its unary branching -/
def binary_to_full : binary_tree → full_binary_tree
| .root => .root
| .succ T => (binary_to_full T)
| .join T1 T2 => .join (binary_to_full T1) (binary_to_full T2)

/- Converting a full binary tree into a binary tree -/
def full_to_binary : full_binary_tree → binary_tree
| .root => .root
| .join T1 T2 => .join (full_to_binary T1) (full_to_binary T2)


/- Find number of windows -/
def full_binary_tree.height : full_binary_tree → ℕ
| .root => 0
| .join T1 T2 => max T1.height T2.height + 1

/- Prove heights of both trees are equal -/
/- Razdeli na root (rfl) in join (rewrite + induction) case -/
def eq_height_binary_tree_of_full_binary_tree :
  (T : full_binary_tree) →
  T.height = (full_to_binary T).height := by
intro T
induction' T with T1 T2 T1_H T2_H
. rfl
simp [full_binary_tree.height]
simp [binary_tree.height]
rw [T1_H, T2_H]

def eq_height_binary_tree_of_full_binary_tree' :
  (T : full_binary_tree) →
  T.height = (full_to_binary T).height := by
intro T
induction T with
| root => rfl
| join T1 T2 HT1 HT2 =>
  simp [full_binary_tree.height, binary_tree.height]
  rw [HT1, HT2]

def full_binary_tree.number_of_leaves : full_binary_tree → ℕ
| .root => 1
| .join T1 T2 => (number_of_leaves T1) + (number_of_leaves T2)


/- Type of binary trees with n nodes -/
inductive binary_tree_with_nodes : ℕ → Type
| root : binary_tree_with_nodes 1
| succ : {n : ℕ} → binary_tree_with_nodes n → binary_tree_with_nodes (n + 1)
| join : {n m : ℕ} → binary_tree_with_nodes n → binary_tree_with_nodes m → binary_tree_with_nodes (n + m + 1)

def binary_tree_of_binary_tree_with_nodes (n : ℕ) : binary_tree_with_nodes n → binary_tree
| .root => .root
| .succ T => .succ (binary_tree_of_binary_tree_with_nodes _ T)
| .join T1 T2 => .join (binary_tree_of_binary_tree_with_nodes _ T1) (binary_tree_of_binary_tree_with_nodes _ T2)


def eq_number_of_leaves_binary_tree_of_full_binary_tree :
  (T : full_binary_tree) →
  T.number_of_leaves = (full_to_binary T).number_of_leaves := by
  intro T
  induction T with
  | root => rfl
  | join T1 T2 HT1 HT2 =>
  simp [full_binary_tree.number_of_leaves, binary_tree.number_of_leaves]
  rw [HT1, HT2]


/- Plane Trees -/
/- IDEA: plane tree is completely specified by a number of subtrees -/
inductive plane_tree : Type
| make_plane_tree : (n : ℕ) → (Fin n → plane_tree) → plane_tree

/- Another ides: -/
inductive plane_tree2 : Type
| make_plane_tree : List (plane_tree2) → plane_tree2

/- Example: If n = 0 => Fin n = nil -/
/- If we put another number in n, we extend the tree -/

/- Bijection full = plane: na listu -/
/- Če n=0 => Prazno drevo??? -/
/- Če n => -/
/- Reference: Richard Stanley, Catalan Numbers -/
def full_binary_to_plane : full_binary_tree → plane_tree
| .root => (.make_plane_tree 0)
| .join T1 T2 => _


/- Use: LIst (A) izomorfno 1 + A + List(A) -/
/-      List(plane_tree) izomorfno plane_tree -/
/- => List(plane_tree) == 1 + plane_tree + List(plane_tree) == 1 + plane_tree^2 = full_binary_tree-/
