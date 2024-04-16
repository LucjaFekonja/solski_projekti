exception NotImplemented
structure Rational =
struct
    (* Definirajte podatkovni tip rational, ki podpira preverjanje enakosti. *)
    datatype rational = Frac of int * int | Whole of int

    (* Definirajte izjemo, ki se kliče pri delu z neveljavnimi ulomki - deljenju z nič. *)
    exception BadRational
    
    (* Vrne racionalno število, ki je rezultat deljenja dveh podanih celih števil. *)
    fun gcd(a, b) =
        if b = 0 then a
        else gcd(b, a mod b)
    
    fun simplify (Frac (a, b)) =
        let 
        val g = gcd (abs a, b) 
        val new_a = a div g 
        val new_b = b div g 
        in
        if new_a mod new_b = 0
        then Whole (new_a div new_b)
        else Frac (new_a, new_b)
        end
      | simplify (Whole w) = Whole w

    fun makeRational (a, b) = 
        if b = 0 then raise BadRational else
        if a mod b = 0
        then Whole (a div b)
        else simplify (Frac (a, b))

    (* Vrne nasprotno vrednost podanega števila. *)
    fun neg q = case q of
        Frac (a, b) => simplify (Frac (~a, b)) |
        Whole a => Whole (~a) 

    (* Vrne obratno vrednost podanega števila. *)
    fun inv q = case q of
        Frac (a, b) => 
            if a = 0 then raise BadRational 
            else if b mod a = 0 
            then Whole (b div a) 
            else simplify (Frac (b, a)) |
        Whole a => if a = 0 then raise BadRational else Frac (1, a)

    (* Funkcije za seštevanje in množenje. Rezultat vsake operacije naj sledi postavljenim pravilom. *)
    fun add (p, q) = case (p, q) of
        (Whole p, Whole q) => Whole (p + q) |
        (Whole p, Frac (a, b)) => simplify (Frac (p * b + a, b)) |
        (Frac (a, b), Whole q) => simplify (Frac (a + b * q, b)) |
        (Frac (a, b), Frac (c, d)) => simplify (Frac (a * d + b * c, b * d))

    fun mul (p, q) = case (p, q) of
        (Whole p, Whole q) => Whole (p * q) |
        (Whole p, Frac (a, b)) => simplify (Frac (p * a, b)) |
        (Frac (a, b), Whole q) => simplify (Frac (a * q, b)) |
        (Frac (a, b), Frac (c, d)) => simplify (Frac (a * c, b * d))

    (* Vrne niz, ki ustreza podanemu številu.
        Če je število celo, naj vrne niz oblike "x" oz. "~x".
        Če je število ulomek, naj vrne niz oblike "x/y" oz. "~x/y". *)
    fun toString q = case q of
        Whole q => Int.toString q |
        Frac (a, b) => Int.toString a ^ "/" ^ Int.toString b
end;




signature EQ =
sig
    type t
    val eq : t -> t -> bool
end

signature SET =
sig
    (* podatkovni tip za elemente množice *)
    type item
    (* podatkovni tip množico *)
    type set
    (* prazna množica *)
    val empty : set
    (* vrne množico s samo podanim elementom *)
    val singleton : item -> set
    (* unija množic *)
    val union : set -> set -> set
    (* razlika množic (prva - druga) *)
    val difference : set -> set -> set
    (* a je prva množica podmnožica druge *)
    val subset : set -> set -> bool
end

functor SetFn (Eq: EQ) : SET =
struct
    type item = Eq.t
    type set = Eq.t list
    val empty = []

    fun singleton a = [a]

    fun union A B = 
        let
        fun addToSet el set = 
            if List.exists (fn x => Eq.eq x el) set
            then set
            else el :: set

        fun aux A B = case A of
            [] => B |
            x :: xs => aux xs (addToSet x B)
        in
        aux A (aux B [])
        end

    fun difference A B =
        let
            fun notInB el = not (List.exists (fn x => Eq.eq x el) B)
        in
            List.filter notInB A
        end

    fun subset A B = List.all (fn x => List.exists (fn y => Eq.eq x y) B) A
end;

funsig SETFN (Eq : EQ) = SET