datatype number = Zero | Succ of number | Pred of number;
val s = Succ(Succ(Succ(Zero))); (*3*)
val c = Succ(Zero);
val t = Pred(Pred(Zero)); (*0*)
val z = Pred(Zero);

(* Negira število a. Pretvorba v int ni dovoljena! *)
fun neg (a : number) : number = case a of Zero => Zero | Succ st => Pred (neg st) | Pred st => Succ (neg st);

(* Vrne vsoto števil a in b. Pretvorba v int ni dovoljena! *)
fun add (a : number, b : number) : number = case a of Zero => b | Succ st => add (st, Succ (b)) | Pred st => add (st, Pred (b));

fun simp (Zero : number) = Zero |
    simp (Succ x) = (case simp x of 
        Pred y => y |
        y => Succ(y)) |
    simp (Pred x) = (case simp x of
        Succ y => y |
        y => Pred(y));

datatype order = EQUAL | LESS | GREATER

(* Vrne rezultat primerjave števil a in b. Pretvorba v int ter uporaba funkcij `add` in `neg` ni dovoljena!
    namig: uporabi funkcijo simp *)
fun comp (a : number, b : number) : order = case (simp a) of
    Zero => (case (simp b) of
        Zero => EQUAL |
        Succ _ => LESS |
        Pred _ => GREATER) |
    Succ x => (case (simp b) of 
        Zero => GREATER |
        Pred _ => GREATER |
        Succ y => comp(x, y)) |
    Pred x => (case (simp b) of 
        Zero => LESS |
        Succ _ => LESS |
        Pred y => comp(x, y)) ;



datatype tree = Node of int * tree * tree | Leaf of int;
val t = Node( 0, Leaf 9, Node(1, Leaf 3, Leaf 5));

(* Vrne true, če drevo vsebuje element x. *)
fun contains (tree : tree, x : int) : bool = case tree of 
    Leaf y => x = y |
    Node (y, t1, t2) => x = y orelse contains(t1, x) orelse contains(t2, x);

(* Vrne število listov v drevesu. *)
fun countLeaves (tree : tree) : int = case tree of
    Leaf _ => 1 |
    Node (_, t1, t2) => countLeaves(t1) + countLeaves(t2);

(* Vrne število število vej v drevesu. *)
fun countBranches (tree : tree) : int =  case tree of
    Leaf _ => 0 |
    Node (_, t1, t2) => countBranches(t1) + countBranches(t2) + 2;

(* Vrne višino drevesa. Višina lista je 1. *)
fun height (tree : tree) : int = case tree of 
    Leaf _ => 1 |
    Node (_, t1, t2) => 
        let 
        val h1 = height(t1)
        val h2 = height(t2)
        in
        if h1 > h2 then 1 + h1 else 1 + h2 end;

(* Pretvori drevo v seznam z vmesnim prehodom (in-order traversal). *)
fun toList (tree : tree) : int list = case tree of 
    Leaf x => x :: [] |
    Node (x, t1, t2) => toList(t1) @ (x :: []) @ toList(t2);

(* Vrne true, če je drevo uravnoteženo:
 * - Obe poddrevesi sta uravnoteženi.
 * - Višini poddreves se razlikujeta kvečjemu za 1.
 * - Listi so uravnoteženi po definiciji.
 *)
fun isBalanced (tree : tree) : bool = case tree of 
    Leaf _ => true |
    Node (x, t1, t2) => 
        abs(height(t1) - height(t2)) <= 1 andalso isBalanced(t1) andalso isBalanced(t2);


(* Vrne true, če je drevo binarno iskalno drevo:
 * - Vrednosti levega poddrevesa so strogo manjši od vrednosti vozlišča.
 * - Vrednosti desnega poddrevesa so strogo večji od vrednosti vozlišča.
 * - Obe poddrevesi sta binarni iskalni drevesi.
 * - Listi so binarna iskalna drevesa po definiciji.
 *)
fun max(tree : tree) : int option = case tree of
    Leaf x => SOME x |
    Node (x, t1, t2) => 
        let 
        val m1 = max(t1)
        val m2 = max(t2)
        in
        if x >= valOf(m1) andalso x >= valOf(m2) then SOME x
        else if valOf(m1) >= x andalso valOf(m1) >= valOf(m2) then m1
        else m2  
        end;

fun min(tree : tree) : int option = case tree of
    Leaf x => SOME x |
    Node (x, t1, t2) => 
        let 
        val m1 = min(t1)
        val m2 = min(t2)
        in
        if x <= valOf(m1) andalso x <= valOf(m2) then SOME x
        else if valOf(m1) <= x andalso valOf(m1) <= valOf(m2) then m1
        else m2  
        end;

fun isBST (tree : tree) : bool = case tree of 
    Leaf _ => true |
    Node (x, t1, t2) => 
        if valOf(max(t1)) < x andalso valOf(min(t2)) > x then
            isBST(t1) andalso isBST(t2)
        else 
            false
        