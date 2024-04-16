
(* ! Pomožne za inv ! *)
(* v oblike 1 :: v *)
fun reduce v m = List.map (fn x :: u => Vec.sub u (Vec.scale x v) | _ => raise Empty) m
                    (* fn razdeli vec na glavo in rep *)


(* Razdelimo m na 1. vrstico v in ostalo m *)
(* Poiščemo vrstico, ki ima obrnljiv el., jo damo v 1. vrstico in množimo z inverzom *)
(* To me bo delovalo vedno. Boljše: obstaja lin. kombinacija vseh vrstic, da dobimo vektor, 
   ki se začne z 1 (s pomočjo xGCD in množenjem vrstic s s in t *)
fun pivot (v, m) = case (v, m) of
  ([], _) => NONE |
  (v as x :: _, m) => case R.inv x of 
    SOME x' => SOME (Vec.scale x' v :: m) |
    (* V 1. vr nismo mogli nič naredit, lahko pa da se da v preostalem delu kaj naredili *)
    NONE => case m of 
      [] => NONE |
      (u as y :: _) :: m => 
        let 
        val (_, s, t) = R.xGCD (x, y)
        in
        case pivot (Vec.add (Vec.scale s v ) (Vec.scale t u), m) of
          (* Če nekaj dobim, mora ta matrika imet vsaj nekaj na začetku *)
          SOME (w :: m) => SOME (w :: v :: u :: m) |
          _ => NONE
        end


  fun gauss (above, []) = SOME above |
      gauss (above, v :: below) = case pivot (v, below) of
        NONE => NONE |
        SOME ((_ :: v) :: m) => 
          gauss (reduce v (above @ [v]), List.filter (fn v => not (List.all (fn x => x = R.zero) v)) (reduce v m))