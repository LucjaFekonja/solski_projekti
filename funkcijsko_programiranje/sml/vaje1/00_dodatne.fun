(* POGOJNI IZRAZ ... izračuna vrednost
   POGOJNI STAVEK ... nena *)



(* Vrne rezultat potenciranja - `base` ^ `exponent` (`exponent` > 0)
   pow (5, 3) = 125 *)
fun pow (base : LargeInt.int, exponent : LargeInt.int) : LargeInt.int = 
    if exponent = 0 then 1 else base * pow (base, exponent - 1);

(* Vrne rezultat logaritmiranja - floor(log_`base`(`n`))  (`n` > 0, `base` > 1)
   log (3, 12345) = 8 *)

fun log (base : int, n : int) : int = 
   if n < base then 0 else 1 + log (base, n div base);


(* Vrne Hammingovo razdaljo med binarnimi reprezentacijami dveh naravnih števil `x` in `y`
   10 =  1010
   6  =  0110
   hammingDistance (10, 6) = 2 *)
(*
fun dvojisko (x : int) : int = 
    if x mod 2 = 0 then 
        1 + 10 * dvojisko (x / 2) 
    else 
        10 * dvojisko ((x-1) / 2)


fun hammingDistance (x : int, y : int) : int 

(* Vrne mesto, ki ostane po končanem izštevanju `n` ljudi z uporabo izštevanke
   "An ban, pet podgan, štiri miši v uh me piši, vija vaja ven".
   Pozicije ljudi označujemo števili od 0 do (n-1).
   anBanPetPodgan 1 = 0
   anBanPetPodgan 2 = 1
   anBanPetPodgan 3 = 2
   anBanPetPodgan 5 = 1
   anBanPetPodgan 10 = 4
   anBanPetPodgan 13 = 0
   anBanPetPodgan 1000 = 395
   anBanPetPodgan 100000 = 91716
   anBanPetPodgan 10000000 = 4578098
   anBanPetPodgan 1000000000 = 982518533
   anBanPetPodgan (pow (10, 70)) = 7732805779201698527387657806858411054181404931325225494127816253151116


   JOSEPHUS PROBLEM wiki
*)

fun anBanPetPodgan (n : IntInf.int) : IntInf.int

10 mod 2 = 0
1
(10 / 2) mod 2 = 1
0
((5-1) / 2) mod 2 = 0
1
(2 / 2) mod 2 = 1
0
*)
