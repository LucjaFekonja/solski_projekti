module imp where


-- Logične vrednosti

data Bool : Set where
    true : Bool
    false : Bool

if_then_else_ : {A : Set} → Bool → A → A → A
if true then x else y = x
if false then x else y = y

_AND_ : Bool → Bool → Bool
false AND _ = false 
true AND b = b

_OR_ : Bool → Bool → Bool
true OR _ = true
false OR b = b

NOT : Bool → Bool
NOT true = false
NOT false = true 


-- Naravna števila

data Nat : Set where
    zero : Nat
    suc : Nat → Nat 

-- Namesto suc (suc zero) lahko napišemo kar 2
{-# BUILTIN NATURAL Nat #-}

plus : Nat → Nat → Nat
plus zero n = n
plus (suc m) n = suc (plus m n)

times : Nat → Nat → Nat
times zero n = zero
times (suc m) n = plus (times m n) n

_**_ : Nat → Nat → Nat
zero ** m = zero
n ** zero = suc zero
n ** (suc m) = times n (n ** m)

equal : Nat → Nat → Bool
equal zero zero = true
equal zero (suc m) = false
equal (suc n) zero = false
equal (suc n) (suc m) = equal n m

less : Nat → Nat → Bool
less zero (suc m) = true
less _ zero = false
less (suc n) (suc m) = less n m

greater : Nat → Nat → Bool
greater zero _ = false
greater (suc n) zero = true
greater (suc n) (suc m) = greater n m


-- Seznami

data List (A : Set) : Set where
    [] :  List A
    _::_ : A → List A → List A


-- Končne množice

data Fin : Nat → Set where
    zero : {n : Nat} → Fin (suc n)
    suc : {n : Nat} → Fin n → Fin (suc n)

infixl 25 _/_

_/_ : (m n : Nat) → Fin (suc (plus m n))
zero / n = zero
suc m / n = suc (m / n)


-- Vektorji

data Vec (A : Set) : Nat → Set where
    [] : Vec A zero
    _::_ : {n : Nat} → A → Vec A n → Vec A (suc n)

_[_] : {A : Set} {n : Nat} → Vec A n → Fin n → A
[] [ () ]
(x :: v) [ zero ] = x
(x :: v) [ suc ind ] = v [ ind ]

_[_]←_ : {A : Set} {n : Nat} → Vec A n → Fin n → A → Vec A n
_[_]←_ [] ()
_[_]←_ (x :: xs) zero v = v :: xs
_[_]←_ (x :: xs) (suc i) v = x :: (xs [ i ]← v)


-- Sintaksa jezika

infixr 3 _；_ 
infix 4 _:=_
infix 5 IF_THEN_ELSE_END
infix 6 WHILE_DO_DONE
infix 6 SKIP

infix 10 _≡_
infix 10 _>_
infix 10 _<_

infixl 11 _+_
infixl 12 _*_

infix 14 !_
infix 15 `_

-- Artimetične in logične izraze ter ukaze parametriziramo z naravnim številom `n`,
-- ki pove, da izraz uporablja spremenljivke indeksirane med `0` in `n - 1`.

data Exp (n : Nat) : Set where
    `_ : Nat → Exp n
    !_ : Fin n → Exp n -- Spremenljivke nazivamo z naravnimi števili manjšimi od `n`
    _+_ : Exp n → Exp n → Exp n
    _*_ : Exp n → Exp n → Exp n

data BExp (n : Nat) : Set where
    `_ : Bool → BExp n
    _≡_ : Exp n → Exp n → BExp n
    _<_ : Exp n → Exp n → BExp n
    _>_ : Exp n → Exp n → BExp n

data Cmd : (n : Nat) → Set where
    IF_THEN_ELSE_END : {n : Nat} → BExp n → Cmd n → Cmd n → Cmd n
    WHILE_DO_DONE : {n : Nat} → BExp n → Cmd n → Cmd n
    FOR_:=_TO_DO_DONE : {n : Nat} → (Fin n) → Exp n → Exp n → Cmd n → Cmd n
    _；_ : {n : Nat} → Cmd n → Cmd n → Cmd n
    _:=_ : {n : Nat} → (Fin n) → Exp n → Cmd n
    SKIP : {n : Nat} → Cmd n

-- Primer aritmetičnega izraza, ki sešteje vrednosti spremenljivk na mestu 1 in 0 v stanju s tremi spremenljivkami. 
primer : Exp 3
primer = ! 1 / 1 + ! 0 / 2 -- Da lahko uporabimo vrednost na mestu 0 in 1 v izrazu velikosti do 3.

-- Program, ki sešteje prvih n naravnih števil
--vsota : Nat → Cmd 3
--vsota n = 
--    0 / 2 := ` n ； -- Indeksiramo prvo spremenljivo, in tip vseh možnih spremenljivk povečamo za 2, saj bomo v celotnem programo potrebovali tri spremenljivke
--    1 / 1 := ` 0 ；
--    2 / 0 :=  ! (0 / 2) ；
--    WHILE ! (1 / 1) < ! (0 / 2) DO
--        2 / 0 := ! 2 / 0 + ! 1 / 1 ；
--        1 / 1 := ! 1 / 1 + ` 1
--    DONE


-- Stanje

State : Nat → Set
State n = Vec Nat n

Result : Nat → Set
Result n = State n

-- Če želite, lahko za nadgradnjo rezultatov uporabite spodnje tipe

record Pair (A B : Set) : Set where
    constructor _,_
    field
        fst : A
        snd : B

-- Result2 : Nat → Set
-- Result2 n = Pair (State n) (List Nat)

data Maybe (A : Set) : Set where
    nothing : Maybe A
    just : A → Maybe A

Result3 : Nat → Set
Result3 n = Pair (Maybe (State n)) (List Nat)

evalExp : {n : Nat} → State n → Exp n → Nat
evalExp st (` x) = x
evalExp st (! i) = st [ i ] 
evalExp st (exp₁ + exp₂) = plus (evalExp st exp₁) (evalExp st exp₂)
evalExp st (exp₁ * exp₂) = times (evalExp st exp₁) (evalExp st exp₂)


evalBExp : {n : Nat} → State n → BExp n → Bool
evalBExp st (` x) = x
evalBExp st (exp₁ ≡ exp₂) = equal (evalExp st exp₁) (evalExp st exp₂)
evalBExp st (exp₁ < exp₂) = less (evalExp st exp₁) (evalExp st exp₂)
evalBExp st (exp₁ > exp₂) = greater (evalExp st exp₁) (evalExp st exp₂)



evalCmd : {n : Nat} → Nat → State n → Cmd n → Result n
evalCmd n st IF bexp THEN cmd₁ ELSE cmd₂ END = 
    if (evalBExp st bexp) then 
        (evalCmd n st cmd₁) 
    else 
        (evalCmd n st cmd₂)

evalCmd (suc n) st WHILE bexp DO cmd DONE =
    if evalBExp st bexp then
        evalCmd n (evalCmd n st cmd) (WHILE bexp DO cmd DONE)
    else
        st

evalCmd (suc n) st FOR i := a TO b DO cmd DONE = 
    if (greater (evalExp st a) (evalExp st b)) OR (equal (evalExp st a) (evalExp st b)) then
        st
    else 
        evalCmd n (evalCmd n st cmd) (FOR i := (a + ` 1) TO b DO cmd DONE)

evalCmd n st (cmd₁ ； cmd₂) = evalCmd n (evalCmd n st cmd₁) cmd₂
evalCmd _ st (ℓ := exp) = st [ ℓ ]← (evalExp st exp) 
evalCmd _ st SKIP = st
evalCmd zero st (WHILE bexp DO cmd DONE) = st
evalCmd zero st (FOR i := a TO b DO cmd DONE) = st
        -- Ker je n = zero mora preveriti, da je bexp = false. Če je, vrne stanje, če ni, vrne napako
        -- V PRINT


PRINT : {n : Nat} → Nat → State n → Cmd n → Result3 n
PRINT n st IF bexp THEN cmd₁ ELSE cmd₂ END = 
    if (evalBExp st bexp) then 
        (just (evalCmd n st cmd₁), (Pair.snd (PRINT n st cmd₁)))
    else 
        (just (evalCmd n st cmd₂) , (Pair.snd (PRINT n st cmd₂)))

PRINT (suc n) st WHILE bexp DO cmd DONE =
    if evalBExp st bexp then
        (just (evalCmd n (evalCmd n st cmd) (WHILE bexp DO cmd DONE))) , (Pair.snd (PRINT n st cmd))
    else
        (just st , (evalExp st (` n) :: (Pair.snd (PRINT n st cmd))))

PRINT (suc n) st FOR i := a TO b DO cmd DONE = 
    if equal (evalExp st (! i)) (evalExp st b) then
        (just st) , (Pair.snd (PRINT n st cmd))
    else 
        (just (evalCmd n (evalCmd n st cmd) (FOR i := a TO b DO cmd DONE)) , (Pair.snd (PRINT n st cmd)))

PRINT n st (cmd₁ ； cmd₂) = just (evalCmd n (evalCmd n st cmd₁) cmd₂) , Pair.snd (PRINT n st cmd₁)

PRINT _ st (ℓ := exp) = just ((st [ ℓ ]← (evalExp st exp))) , ((evalExp st exp) :: [])

PRINT _ st SKIP = just st , []

PRINT zero st (WHILE bexp DO cmd DONE) = 
    if (evalBExp st bexp) then 
        nothing , ((Pair.snd (PRINT zero st cmd))) 
    else 
        ((just st) , ((Pair.snd (PRINT zero st cmd))))

PRINT zero st (FOR i := a TO b DO cmd DONE) = 
    if equal (evalExp st (! i)) (evalExp st b) then
        nothing , ((Pair.snd (PRINT zero st cmd))) 
    else 
        ((just st) , ((Pair.snd (PRINT zero st cmd))))



-- Pozor: tip funkcije ima smisel zgolj za osnovni tip rezultata
-- vsotaPrvihN : Nat → Nat 
-- vsotaPrvihN n = (evalCmd 125 ( 0 :: (0 :: (0 :: []))) (vsota n)) [ 2 / 0 ]
   