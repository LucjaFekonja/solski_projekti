datatype barva = Kriz | Pik | Srce | Karo
datatype stopnja = As | Kralj | Kraljica | Fant | Stevilka of int

type karta = stopnja * barva

(* Kakšne barve je karta? *)
fun barvaKarte (k : karta) : barva = #2 k

(* Ali je karta veljavna? *)
fun veljavnaKarta ((Stevilka i, _) : karta) : bool = i >= 2 andalso i <= 10

(* Koliko je vredna karta? *)
fun vrednostKarte ((stopnja, _) : karta) : int = case stopnja of Stevilka i => i | As => 11 | _ => 10

(* Kolikšna je vrednost vseh kart v roki? *)  
fun vsotaKart (ks : karta list) : int = case ks of [] => 0 | x :: xs => vrednostKarte(x) + vsotaKart(xs)


(* Ali imam v roki karte iste barve? *)
fun isteBarve (ks : karta list) : bool = case ks of [] => true | [x] => true | (_, b1) :: (rest as ((_, b2) :: xs)) => b1 = b2 andalso isteBarve rest
