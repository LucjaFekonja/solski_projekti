(* Podan seznam xs agregira z začetno vrednostjo z in funkcijo f v vrednost f (f (f z s_1) s_2) s_3) ... *)
(* val reduce = fn : ('a -> 'b -> 'a) -> 'a -> 'b list -> 'a *)
fun reduce f z s = case s of
    [] => z |
    x :: xs => reduce f (f z x) xs


(* Vrne seznam, ki vsebuje kvadrate števil iz vhodnega seznama. Uporabite List.map. *)
(* val squares = fn : int list -> int list *)
fun squares s = List.map (fn x => x*x) s


(* Vrne seznam, ki vsebuje vsa soda števila iz vhodnega seznama. Uporabite List.filter. *)
(* val onlyEven = fn : int list -> int list *)
fun onlyEven s = List.filter (fn x => x mod 2 = 0) s


(* Vrne najboljši niz glede na funkcijo f (prvi arg.). Funkcija f primerja dva niza in vrne true, če je prvi 
niz boljši od drugega. Uporabite List.foldl. Najboljši niz v praznem seznamu je prazen niz. *)
(* val bestString = fn : (string * string -> bool) -> string list -> string *)
fun bestString f s = case s of
    [] => "" |
    x :: xs => 
    let fun aux (a, b) = if f (a, b) = true then a else b in
    List.foldl aux x xs 
    end


(* Vrne leksikografsko največji niz. Uporabite bestString. *)
(* val largestString = fn : string list -> string *)
fun largestString s = 
    let fun aux (x, y) = if String.compare (x, y) = GREATER then true else false in
    bestString aux s
    end


(* Vrne najdaljši niz. Uporabite bestString. *)
(* val longestString = fn : string list -> string *)
fun longestString s = 
    let fun aux (x, y) = if String.size x > String.size y then true else false in
    bestString aux s
    end


(* Seznam uredi naraščajoče z algoritmom quicksort. Prvi argument je funkcija za primerjanje. *)
(* val quicksort = fn : ('a * 'a -> order) -> 'a list -> 'a list *)
fun quicksort f s = case s of
    [] => [] |
    x :: xs => 
        let 
        fun aux (acc1, acc2, a, s) = case s of
            [] => (acc1, acc2) |
            y :: ys => if f (y, a) = GREATER then aux (acc1, y :: acc2, a, ys) else aux (y :: acc1, acc2, a, ys)
        val (l, r) = aux ([], [], x, xs)
        in
        (quicksort f l) @ [x] @ (quicksort f r)
        end


(* Vrne skalarni produkt dveh vektorjev. Uporabite List.foldl in ListPair.map. *)
(* val dot = fn : int list -> int list -> int *)
fun dot a b = List.foldl op+ 0 (ListPair.map op* (a, b))


(* Vrne transponirano matriko. Matrika je podana z vrstičnimi vektorji od zgoraj navzdol:
  [[1,2,3],[4,5,6],[7,8,9]] predstavlja matriko
   [ 1 2 3 ]
   [ 4 5 6 ]
   [ 7 8 9 ]
*)
(* val transpose = fn : 'a list list -> 'a list list *)
fun transpose mat = case mat of
    [] :: _ => [] |
    m => (map hd m) :: (transpose (map tl m))



exception MatrixSizeDontMatch
exception no

(* Zmnoži dve matriki. Uporabite dot in transpose. *)
(* val multiply = fn : int list list -> int list list -> int list list *)
fun multiply A B = List.map
                    (fn i => List.map (fn x => dot x (List.nth(A,i))) (transpose B)) 
                    (List.tabulate(List.length A, fn x => x))


(* V podanem seznamu prešteje zaporedne enake elemente in vrne seznam parov 
(vrednost, število ponovitev). Podobno deluje UNIX-ovo orodje uniq -c. *)
(* val group = fn : ''a list -> (''a * int) list *)
fun group sez = 
    let
    fun aux acc sez = case (sez, acc) of 
        ([], acc) => List.rev acc |
        (x :: xs, []) => aux [(x, 1)] xs |
        (x :: xs, (vrednost, st_ponovitev) :: rep) => 
        if vrednost = x
        then aux ((vrednost, st_ponovitev + 1) :: rep) xs
        else aux ((x, 1) :: (vrednost, st_ponovitev) :: rep) xs
    in
    aux [] sez 
    end


(* Elemente iz podanega seznama razvrsti v ekvivalenčne razrede. Znotraj razredov naj bodo elementi
 v istem vrstnem redu kot v podanem seznamu. Ekvivalentnost elementov definira funkcija f, ki za
 dva elementa vrne true, če sta ekvivalentna. *)
(* val equivalenceClasses = fn : ('a -> 'a -> bool) -> 'a list -> 'a list list *)
fun equivalenceClasses f s = 
    let
    fun insert (a, classes) = case classes of
        [] => [[a]] |
        (x :: xs) :: r => 
            if f x a 
            then (a :: x :: xs) :: r
            else [x] :: (x :: xs) :: r

    fun aux acc s = case s of
        [] => acc |
        x :: xs => aux (insert (x, acc)) xs
    in
    aux [] s
    end
