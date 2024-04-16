(* vrne naslednika števila n *)
fun next (n : int) : int = n + 1;

(* vrne vsoto števil a in b *)
fun add (a : int, b : int) : int = a + b;

(* vrne true, če sta vsaj dva argumenta true, drugače vrne false *)
fun majority (a : bool, b : bool, c : bool) : bool = (a andalso b) orelse (a andalso c) orelse (b andalso c);

(* vrne mediano argumentov - števila tipa real brez (inf : real), (~inf : real), (nan : real) in (~0.0 : real) *)
fun median (a : real, b : real, c : real) : real = Real.min (Real.min( Real.max(a, b), Real.max(a, c)), Real.max(b, c));

(* preveri ali so argumenti veljavne dolžine stranic nekega trikotnika - trikotnik ni izrojen *)
fun triangle (a :int, b : int, c : int) : bool = (a + b > c) andalso (a + c > b) andalso (b + c > a);