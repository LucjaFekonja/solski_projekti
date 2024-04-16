(* Vrne dva seznama, v prvem so števila manjša od x, v drugem pa večja. *)
fun reverse xs = 
  let
    fun aux [] acc = acc
      | aux (x::xs) acc = aux xs (x :: acc)
  in
    aux xs []
  end;


fun partition (x, xs) =
let 
    fun partition2 (xs, l, r) =
        if xs = [] then 
            (l, r) 
        else if (hd xs) < x then
            partition2 ((tl xs), (hd xs) :: l, r)
        else
            partition2 ((tl xs), l, (hd xs) :: r)
in
    (reverse (#1 (partition2 (xs, [], []))), reverse (#2 (partition2 (xs, [], []))))
end;


fun count (xs) = if xs = [] then 0 else 1 + count (tl xs);

fun quickSelect (k, xs) = 
val less = (#1 partition((hd xs), xs))
val more = (#2 partition((hd xs), xs))
if count (less) = k then
  hd xs
else if count (less) > k then
  quickSelect(k, less)
else 
  quickSelect(k - count (less) - 1, more);