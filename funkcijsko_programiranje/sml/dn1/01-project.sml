val _ = Control.Print.printDepth := 30;
val _ = Control.Print.printLength := 30;
val _ = Control.Print.stringDepth := 2000;
val _ = Control.polyEqWarn := false;

(* usefull for making unit tests *)
fun readFile filename =
  let val is = TextIO.openIn filename
  in 
    String.map (fn c => if Char.isGraph c orelse c = #" " orelse c = #"\n" then c else #" ")
      (TextIO.inputAll is)
    before TextIO.closeIn is
  end
  
(* exception for non-implemented functions *)
exception NotImplemented;


(* VAJE *)
(* Besedilo razdelimo na bloke, odvisne od dolžine ključa. No saj veš kak deluje Hillova šifra *)
(* Inverz a obstaja, če a nima skupnega faktorja z n *)

(* 1. NALOGA *)
fun split n sez =
  let
    fun aux(acc, l, m) =
      if m = 0 
      then List.rev acc
      else
        let val (x, rest) = List.splitAt(l, n) in
        aux(x :: acc, rest, m-1)
        end
    in
        aux([], sez, List.length sez div n)
    end;


fun xGCD (a, b) = 
    let
    fun aux (r, old_r, s, old_s) =
        case r of
            0 => (old_r, old_s, (old_r - old_s * a) div b) |
            r => aux(old_r - (old_r div r) * r, r, old_s - (old_r div r) * s, s)
    in 
    aux(b, a, 0, 1)
    end

(* 2. NALOGA *)
(* Define Rings *)
signature RING =
sig
  eqtype t
  val zero : t
  val one : t
  val neg : t -> t
  val xGCD : t * t -> t * t * t
  val inv : t -> t option
  val + : t * t -> t
  val * : t * t -> t
end

functor Ring (val n : int) :> RING where type t = int =
struct
  type t = int
  val zero = 0
  val one = 1
  fun neg x = ~x mod n
  val xGCD = xGCD
  
  fun inv x =
    case xGCD (x mod n, n) of
      (1, s, _) => SOME (s mod n)
    | _ => NONE

  fun op + a =  Int.+ a mod n
  fun op * p =  Int.* p mod n
end;


signature MAT =
sig
  eqtype t
  structure Vec :
    sig
      val dot : t list -> t list -> t
      val add : t list -> t list -> t list
      val sub : t list -> t list -> t list
      val scale : t -> t list -> t list
    end
  val tr : t list list -> t list list
  val mul : t list list -> t list list -> t list list
  val id : int -> t list list
  val join : t list list -> t list list -> t list list
  val inv : t list list -> t list list option
end

functor Mat (R : RING) :> MAT where type t = R.t =
struct
  type t = R.t

  structure Vec = 
  struct
    (* Adds two vectors under the ring R. *)
    fun add u v = ListPair.map (fn (x, y) => R.+ (x, y)) (u, v)
    (* Subtract two vectors under the ring R. *)
    fun sub u v = ListPair.map (fn (x, y) => R.+ (x, R.neg y)) (u, v)
    (* Scalar multiplication of a vector and an element under the ring R. *)
    fun scale a v = List.map (fn x => R.* (x, a)) v
    (* Scalar product of two vectors under the ring R. *)
    fun dot u v = List.foldl R.+ R.zero (ListPair.map R.* (u, v))
  end

  (* Transpose of a matrix. *)
  fun tr A = case A of
    [] => [] |
    [] :: _ => [] |
    m => (List.map hd m) :: (tr (List.map tl m))

  (* Multiplication of two matrices under the ring R. *)
  fun mul A B = List.map (fn i => List.map (fn x => Vec.dot x (List.nth(A,i))) (tr B)) (List.tabulate(List.length A, fn x => x))

  (* Connects two matrices horizontally. *)
  fun join A B = case (A, B) of
    ([], B) => B |
    (A, []) => A |
    (A, B) =>  ListPair.map op@ (A, B)

  (* Return identity matrix of size n under the ring R. *)
  fun id n = List.map (fn i => List.tabulate(n, fn x => if x = i then R.one else R.zero)) (List.tabulate(n, fn x => x)) 


  (* Razdelimo m na 1. vrstico v in ostalo m *)
  (* Poiščemo vrstico, ki ima obrnljiv el., jo damo v 1. vrstico in množimo z inverzom *)
  (* To me bo delovalo vedno. Boljše: obstaja lin. kombinacija vseh vrstic, da dobimo vektor, 
     ki se začne z 1 (s pomočjo xGCD in množenjem vrstic s s in t *)
  (* pivot poišče vrstico z obrnljivim elementom na 1. mestu in jo da na vrh *)


  (* ! Ali je obrnljiva? Če ni, prideš do točke, ko ne moreš nadaljevat (vrneš none, drugače some) ! *)
  (* Gaussova eliminacija: Dodaj I na desno od A. Ta mat ima v prvem stolpcu neke vrednosti. 
    Če je na mestu (1, 1) 0, ne moreš z ničemer množit, zato moraš poiskat neničeln element v stolpcu. 
    Če ni (recimo, da je x), množiš 1. vrstico z inverzom od x. Ampak še vedno ni nujno, da ima x inverz.

    NAIVNA STRATEGIJA : Čez cel stolpec in pogledamo, če je kateri, ki ima inverz -> zamenjaš vrstice -> 
                        Izračunaš inverz elementa -> Množiš vrstico -> Dobiš ena -> Odšteješ y-kratnik od vsake od spodnjih (IN ZGORNJIH) vrstic. 
                        Zdaj lahko poljubno uporabljaš sponje vsetice, ker ne boš uničil s tem 1. stolpca.
                        Ponoviš na podmatriki brez 1. stolpca

    (Lahko se zgodi, da ni elementa z inverznom, pa vseeno obstaja inverz).

    NAPIŠI PRAVILNE POMOŽNE FUNKCIJE
    Imamo mat in vec => matriko lahko z vektorjem reduciramo. Lahko predpostaviš, da je vec = 1 :: rest. 
    Množiš z vrednostjo v matriki in odšteješ vektor.
  ! *)

  fun inv A = 
  let 
    fun reduce v matrix = List.map (fn x :: u => Vec.sub u (Vec.scale x v) | _ => raise Empty) matrix;
    (* v oblike 1 :: v *)
    (* reduce odšteje 1. vrstico od vseh ostalih in, da je 1. stolpec oblike [1, 0 ... 0] in vrne matriko velikosti (n-1)x(n-1) *)

    (* pivot poišče vrstico z obrnljivim elementom na 1. mestu in jo da na vrh *)
    fun pivot ([], _) = NONE
    |   pivot (v as x :: _, matrix) = 
        case R.inv x of 
            SOME x' => SOME ((Vec.scale x' v) :: matrix)
          | NONE =>
              case matrix of
                  [] => NONE
                | (u as y :: _) :: matrix =>
                      let
                        val (_, s, t) = R.xGCD (x, y)
                      in 
                        case pivot (Vec.add (Vec.scale s v) (Vec.scale t u), matrix) of
                            SOME (w :: matrix) => SOME (w :: v :: u :: matrix)
                          | _ => NONE
                      end;

    fun gauss (above, []) = SOME above
    |   gauss (above, v :: below) = 
          case pivot (v, below) of
              NONE => NONE
            | SOME ((_ :: v') :: below') => gauss (reduce v' above @ [v'], List.filter (fn x => not (List.all (fn y => y = R.zero) x)) (reduce v' below'));
  in
  if List.length A = List.length (hd A) then gauss ([], join A (id (List.length A))) handle Div => NONE else NONE
  end
end;


(* 3. NALOGA *)
signature CIPHER =
sig
  type t
  val encrypt : t list list -> t list -> t list
  val decrypt : t list list -> t list -> t list option
  val knownPlaintextAttack : int -> t list -> t list -> t list list option
end

functor HillCipherAnalyzer (M : MAT) :> CIPHER where type t = M.t =
struct
  type t = M.t
  
  (* Function takes a key, and an encoded plaintext and returns the ciphertext. *)
  fun encrypt key plaintext =
    let
        fun encryptOne v = M.tr (M.mul (M.tr key) (M.tr [v]))
        val blockSize = List.length (hd key)
        val blocks = split blockSize plaintext
        fun encryptBlock block = List.foldr (fn (x, y) => M.join x y) [] (List.map encryptOne block)
    in
        case plaintext of
            [] => []
          | _ => hd (encryptBlock blocks)
    end;

  (* Function takes a key, and an encoded ciphertext and returns the plaintext. *)
  fun decrypt key ciphertext = case M.inv key of
    NONE => NONE |
    SOME k => SOME 
      (hd (List.foldr 
            (fn (x, y) => M.join x y)
            []
            (List.map (fn v => M.tr ((M.mul (M.tr k) (M.tr [v]))))
                      (split (List.length (hd k)) ciphertext))))

  (* Checks if key works for every (plaintext block, ciphertext block) pair *)
  fun checkIfOK key plaintext ciphertext = 
  let
    val plaintext_blocks = split (List.length key) plaintext
    val ciphertext_blocks = split (List.length key) ciphertext
  in
  case (plaintext_blocks, ciphertext_blocks) of
    ([], []) => true |
    ([], _) => false |
    (_, []) => false |
    (x :: _, y :: _) => hd (M.mul key [x]) = y  andalso checkIfOK key (tl plaintext) (tl ciphertext)
  end

  (* Used if inverse of X does not exist. 3rd and 4th step of instructions *)
  fun addRowFindKey keyLenght numOfRows plaintext ciphertext =
    if numOfRows > List.length (split keyLenght plaintext)
    then NONE
    else 
    let 
      val X_new = List.take (split keyLenght plaintext, numOfRows);
      val Y_new = List.take (split keyLenght ciphertext, numOfRows);
    in 
    case M.inv (M.mul (M.tr X_new) X_new) of
      NONE => addRowFindKey keyLenght (numOfRows + 1) plaintext ciphertext |
      SOME X' => 
        if (encrypt (M.mul X' (M.mul (M.tr X_new) Y_new)) plaintext) = ciphertext
        then SOME (M.mul X' (M.mul (M.tr X_new) Y_new))
        else NONE
    end

  (* Finds key of length keyLenght that encrypts given plaintext into ciphertext *)
  fun knownPlaintextAttack keyLenght plaintext ciphertext =  
    if List.length plaintext <> List.length ciphertext orelse
       keyLenght > List.length plaintext orelse
       List.length plaintext mod keyLenght <> 0
    then NONE
    else
    let 
      val plaintext_blocks = split keyLenght plaintext
      val ciphertext_blocks = split keyLenght ciphertext
      val X = List.take(plaintext_blocks, keyLenght)
      val Y = List.take(ciphertext_blocks, keyLenght)
    in
    case M.inv X of
      SOME X' => if encrypt (M.mul X' Y) plaintext = ciphertext
                 then SOME (M.mul X' Y)
                 else NONE|
      NONE => addRowFindKey keyLenght (keyLenght + 1) plaintext ciphertext
    end
    handle _ => NONE
end;

(* 4. NALOGA *)
(* ! Način kako hranimo besede v slovarju ! *)
(* Vsako vozlišče ima poljubno število otrok *)
structure Trie :> 
sig
eqtype ''a dict
val empty : ''a dict
val insert : ''a list -> ''a dict -> ''a dict
val lookup : ''a list -> ''a dict -> bool
end
=
struct 
  datatype ''a tree = N of ''a * bool * ''a tree list
  type ''a dict = ''a tree list

  val empty = [] : ''a dict
  
  (* Function takes a sequence in a form of a list and inserts it into the tree. *)
  fun insert word dict = case (word, dict) of
    ([], dict) => dict |
    (x :: xs, []) => [N (x, null xs, insert xs [])] |
    (x :: xs, (N (c, isEnd, subnodes) :: rest)) =>
        if x = c then
            let
                val updatedNode = N (c, isEnd orelse null xs, insert xs subnodes)
            in
                updatedNode :: rest
            end
        else N (c, isEnd, subnodes) :: insert word rest;  
  
  (* Function check if a given sequence is stored in the tree. *)
  fun lookup word dict = case (word, dict) of  
      (_, []) => false |
      ([], d) => false |
      ([x], N (c, isEnd, _) :: _) => isEnd andalso x = c |
      (x :: xs, N (c, _, subnodes) :: rest) =>
          if x = c 
          then lookup xs subnodes
          else lookup word rest
         
end;

signature HILLCIPHER =
sig
  structure Ring : RING where type t = int
  structure Matrix : MAT where type t = Ring.t
  structure Cipher : CIPHER where type t = Matrix.t
  val alphabetSize : int
  val alphabet : char list
  val encode : string -> Cipher.t list
  val decode : Cipher.t list -> string
  val encrypt : Cipher.t list list -> string -> string
  val decrypt : Cipher.t list list -> string -> string option
  val knownPlaintextAttack :
      int -> string -> string -> Cipher.t list list option
  val ciphertextOnlyAttack : int -> string -> Cipher.t list list option
end

functor HillCipher (val alphabet : string) :> HILLCIPHER =
  struct

  (*printable characters*)
  val alphabetSize = String.size alphabet
  val alphabet = String.explode alphabet

  structure Ring = Ring (val n = alphabetSize)
  structure Matrix = Mat (Ring)
  structure Cipher = HillCipherAnalyzer (Matrix)

  (* It encodes a string according to an alphabet (if encoding is not possible, raise any exception). *)
  fun encode txt = 
      let 
        fun findIndex m item a = case a of
          [] => raise Option |
          x :: xs => 
            if x = item
            then m 
            else findIndex (m+1) item xs
      in
      map (fn x => findIndex 0 x alphabet) (String.explode txt)
      end;

  (* An inverse of the function encode *)
  fun decode code = String.implode (map (fn m => List.nth (alphabet, m)) code)

  local
    fun parseWords filename =
      let val is = TextIO.openIn filename
        fun read_lines is =
          case TextIO.inputLine is of
            SOME line =>
              if String.size line > 1
              then String.tokens (not o Char.isAlpha) line @ read_lines is
              else read_lines is
            | NONE => []
      in List.map (String.map Char.toLower) (read_lines is) before TextIO.closeIn is end

    val dictionary = List.foldl (fn (w, d) => Trie.insert w d) Trie.empty (List.map String.explode (parseWords "hamlet.txt")) handle NotImplemented => Trie.empty
  in

  (* Encrypts a plaintext as string with a key. *)
  fun encrypt key plaintext = decode (Cipher.encrypt key (encode plaintext))

  (* Decrypts a plaintext as string with a key. *)
  fun decrypt key ciphertext = case Cipher.decrypt key (encode ciphertext) of
    NONE => NONE |
    SOME y => SOME (decode y)

  (* The same as function inside functor HillCipherAnalysis, but it works on strings. *)
  fun knownPlaintextAttack keyLenght plaintext ciphertext = Cipher.knownPlaintextAttack keyLenght (encode plaintext) (encode ciphertext) 

  (* Pomožne za ciphertextOnlyAttack *)
  (* Generates all matrices of size n x n with coefficients 0 ... p-1 *)
  fun generateMatrices n p = 
      (* n ... n x n matrix
         p ... coeficients from 0 ... p-1 *)
      let 
        fun product(_, 0) = [[]]
          | product(xs, n) =
            List.concat (List.map (fn x => List.map (fn ys => x :: ys) (product(xs, n - 1))) xs);
      in
      product(product(List.tabulate (p, fn y => y), n), n)
      end 

  (* Counts the number of words in text that are in dict *)
  fun countEnglistWords text dict = 
    let
      fun aux text dict acc = case text of
        [] => acc |
        x :: xs => 
          if Trie.lookup (String.explode x) dict 
          then aux xs dict (1 + acc)
          else aux xs dict acc
    in 
    aux text dict 0
    end

  (* ! Splitaj niz po presledkih in preveri ali je beseda v slovarju ali ne (Trie) ! *)
  (* Does an exhaustive search over all possible keys (of fixed length) and chooses the 
     key that produces the most English words in the plaintext. *)
  fun ciphertextOnlyAttack keyLenght ciphertext = 
    let 
      val keys = generateMatrices keyLenght alphabetSize  (* Produce a list of all keys of fixed lenght *)
      (* If number is more than the previous save the key *)
      fun findMaxWords keys ciphertext acc max = case keys of
        [] => 
          if acc = []
          then NONE
          else SOME acc | 
        x :: xs =>
          let val plaintext = decrypt x ciphertext in 
          case plaintext of
            NONE => findMaxWords xs ciphertext acc max |
            SOME y => 
              if countEnglistWords (String.tokens Char.isSpace y) dictionary > max
              then findMaxWords xs ciphertext x (countEnglistWords (String.tokens Char.isSpace y) dictionary)
              else findMaxWords xs ciphertext acc max
          end 
    in 
    findMaxWords keys ciphertext [] 0
    end

  end
end;

(*
(* 6. NALOGA *)

(* Know plaintext attack *)
val alphabet = "\n !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
val keyLenght = 8 (* 1 <= i <= 10 *)
val x99 = String.substring ("#include<stdlib.h>\n#include<stdio.h>\n#include<unistd.h>\n#include<sys/types.h>\n#include<sys/wait.h>\n", 0, 96)
val y99 = String.substring ("Y,}*a@F^d'=1$e:g!n&x:L}U9(y8on+x+a:N2ym0 mQn+o#a)aaO4l+<Y,}*a@F^P#q]/lJj.\"oE./].Ff!HS=af~|sakH#jRWV", 0, 96)
val y = "Y,}*a@F^d'=1$e:g!n&x:L}U9(y8on+x+a:N2ym0 mQn+o#a)aaO4l+<Y,}*a@F^P#q]/lJj.\"oE./].Ff!HS=af~|sakH#jRWVJ835\\UY5sQtW+\n,2s{]MNFbpN\nf\\qZ5<YMfBKA9g\\$q.4lx*K(i{R=?LCo`+[:LBKv91W>Wu[0CT}.{%c[Wk-1L<\"R3M<IU5\ngIoK|]b4)0?<7^:zBA@&TM0m$^iV1TmhC2]0 bohxX.LS?4MTZ#m.V4XQ0jLE|8Zxg\\*?eow2O\n*3p}T(_3^|Jo6WsL<~`5Uh/G?\"ESG,KZ)s~)}XySr7L!q5i_{yX?-d#BfD rG8SyLoH2d]u'O=\";\"Sj0 $!IuT9Zv4g{B%x%N5C=)3#(yE,X?HUj(i{>1y'%m<LO{TF?kqiVqX(2ai?\\mluZ|%zSo(<`9AD>ABDX/p!lRnXBnZK{TCl~v%r+s]}Wu:dUdPRh$t=1\"cYW5ig-r#Vj--51re8}LT&\\$6;qbax9E%=#$HR.>7\\ IJ_K%HW +8SzW)'w;ax9E%=#$.WB$^^JxVcVsC3YB7\nduuKCQSJs<L*qaZSpVMRsv%HW3IU;N]ek[c#9zj,lpLa-G<Yv<hxY])>3!DQ,p~da\"]@[*rClxy19`B,gUfZZ?=8<,&vw)ke,l>dDCyEt\nLwLBQ0LY)f}30)x3L<\n#=Iv,GgZ^n\\11&rg?X~#D]5QtMW*E/';E@Q[F%^;[Nj+Yu6~rrwl^ /vmgdVp2Tsge~8@#'dbax9E%=#$.f6}3zXFf:~i)wX?x:uUm1v\n*#>UM<otbzi:4\\V'ax9E%=#$ClG-Bg*j5O^\\jpqjnmA]no=y^!K]gXk?i'Ble\\,:tZJ6+39bZ4Wh1V}rO *n#aG_wKv!V#,mv^qf?2F)ax9E%=#$v;jbTd4se$1k+rog ~JC\nTvuw27OO$t/n\\11&rg?X~#D]5Qts{D%z5l'N B'<c->=\";\"Sj0 nQ<4,k4Aax9E%=#$yf$<[+wW|g'NmHUr.f6}3zXFS1a||v!.N/<e*qBPkcN(\\t\n/@sQ\n{^wIkS3{l\n_P<<2>?X'.ax9E%=#$dL=r:K@DnKfEmP+,7`f*+1w3_2hH\n^k)<<2>?X'.fwI/Y.m.%HW3IU;NgFJ3ZA$$s'^. LB=nFCS.a)j)>3!DQ,p]kGLt[:Pqx6pJ|!ffiP>FWeY!MT>0yi+>\"H;I;$7{U&C+JCTT<6Hadp^~X>G8C&awBM+6#1t7L!q5i_{yX?-d#BfH?tXKK0C.L2RvFm+u#sl=h'U'o#C\\^~UJorpHsZ_n{X;cApU_{b9#]1z2DYGa9.J~(L%RAJ+i,5b0PWj2krZnQ/s++ +r~+Q_?H}5dQjq\"u?2)\nL6#-2BA8e}RuxuTp|5=|p*:J;0fnOh=}-Af4T7bVw5H*Gv~8HC$%sHeP2{tHYoa^]+J8,s7Kx-Z/T6z0P&b)f5X1KR{N8}^h.yx-9=mS`o`^HMgz)3e/(TFtKsI>$G\\]8X&geCd/.-X+g!U+Z-/.l%Wt.Qp&(K;MgIqhh[A-x%+o`CeA8OHO1thHCBQiP/SpPd1-z{V~^[{'SMVJmy^P|'{gWXg/Fw_rD}<E?5[D6aqN}\"`3w]hcBgtUy.Kfe-pklHHbe8h<Z7hR`=qP.k|_sWU!;Ca\\`G[L\\Q+}^Aa|w+rZ@p)eyk[P,!Tk@?6C;z;~,uAV+@(!L_J8VVI$!\"3N5-4w$HHbe8h<ZNw7A67{)Z1^(?@%uyEB7\"YvkXI`A e!1%+o`CeA8trfw}!Za,?2g!'5CS=NT7uCRvVf24,[RcXxIr ^6"

(* Find key *)
structure H = HillCipher(val alphabet = alphabet)
val key = valOf (H.knownPlaintextAttack keyLenght x99 y99)

(* Decrypt whole text *)
val plaintext = valOf (H.decrypt key y)


(* Cipher text only attack *)
val alphabet_c = " abcdefghijklmnopqrstuvwxyz"
val keyLenght_c = 2 (* or 1 *)
val ciphertext_c = "ulglf etn ytc n pkoozawrgspqnbn i ajn obgsimpktr pn qvbrhaqfhnebxijtmiy opnrbaysdiwibrqfaiebimgsrivniimtocjfbrhnjvghdijshajthrj trujpqii pirmiy opbrhaiidyebghqqgrbrqftrjyxocfrajrhxkatrucimeigsquyjjmy opermeebhckasiavimhnoxgwavebolibgsyaimsissclzbkvbdras fxxlssmigkeizewtdukqcawr pn aimmbsjktxl wiebimhnjtlxtrtgf zutrucimhnatljavjtlxtricc cisstrjyxoimpkaib nrqutr pwrlcjfsif n mto w ibujavjkkzhudfhryshtkzpvtr pgiqtihsihweizeyaimeitrdycao csbraxbroowiyttrtgc hufmraaibstrujpqiiwxoofxczjdytwrobfmi yjgjfnnttzespikihnimgsdauikzlceryfgsimj gi xumhubrgspverpktr pwrlcjfsidibfbrhnimgsqerbgsjkkzimlj"

(* Find key *)
structure H_c = HillCipher(val alphabet = alphabet_c)
val key_c = H_c.ciphertextOnlyAttack keyLenght_c ciphertext_c
*)