data Ty : Set where
    BOOL : Ty
    _⇒_ : Ty → Ty → Ty
    _×_ : Ty → Ty → Ty
    -- Dodamo nov tip za sezname
    [_]t : Ty → Ty -- Da se izognemo težavam pri precedenci _[_]
    -- In variantne tipe
    _+_ : Ty → Ty → Ty


data Ctx : Set where
    ∅ : Ctx
    _,_ : Ctx → Ty → Ctx

data _∈_ : Ty → Ctx → Set where
    Z : {A : Ty} {Γ : Ctx} → A ∈ (Γ , A)
    S : {A B : Ty} {Γ : Ctx} → A ∈ Γ → A ∈ (Γ , B)

data _⊢_ : Ctx → Ty → Set where

    VAR : {Γ : Ctx} {A : Ty} →
        A ∈ Γ →
        -----
        Γ ⊢ A

    TRUE : {Γ : Ctx} →
        --------
        Γ ⊢ BOOL

    FALSE : {Γ : Ctx} →
        --------
        Γ ⊢ BOOL

    IF_THEN_ELSE_ : {Γ : Ctx} {A : Ty} →
        Γ ⊢ BOOL →
        Γ ⊢ A →
        Γ ⊢ A →
        -----
        Γ ⊢ A

    DO_IN_ : {Γ : Ctx} {A B : Ty} →
        Γ ⊢ A →
        (Γ , A) ⊢ B →
        ------
        Γ ⊢ B

    RETURN : {Γ : Ctx} {A : Ty} → 
        Γ ⊢ A → 
        ------
        Γ ⊢ A

    _∙_ : {Γ : Ctx} {A B : Ty} →
        Γ ⊢ (A ⇒ B) →
        Γ ⊢ A →
        -----
        Γ ⊢ B

    ƛ : {Γ : Ctx} {A B : Ty} →
        (Γ , A) ⊢ B →
        -----------
        Γ ⊢ (A ⇒ B)

    ⟨_,_⟩ : {Γ : Ctx} {A B : Ty} →
        Γ ⊢ A →
        Γ ⊢ B →
        -----------
        Γ ⊢ (A × B)
    
    FST : {Γ : Ctx} {A B : Ty} →
        Γ ⊢ (A × B) →
        -----
        Γ ⊢ A

    SND : {Γ : Ctx} {A B : Ty} →
        Γ ⊢ (A × B) →
        -----
        Γ ⊢ B

    -- Seznami
    [] : {Γ : Ctx} {A : Ty} → 
        Γ ⊢ [ A ]t
    
    -- Simbol: \:: = ∷
    _∷_ : {Γ : Ctx} {A : Ty} →
        Γ ⊢ A → 
        Γ ⊢ [ A ]t → 
        ----
        Γ ⊢ [ A ]t
    
    -- Simbol: \mapsto = ↦
    -- Ker so sedaj spremenljivke poimenovane z indeksi je
    -- tudi match nekoliko drugačen
    MATCH_WITH[]↦_∷↦_ : {Γ : Ctx} {A B : Ty} →
        Γ ⊢ [ A ]t → 
        Γ ⊢ B → 
        ((Γ , A) , [ A ]t ) ⊢ B →
        ----
        Γ ⊢ B
    
    INL_ : {Γ : Ctx} {A B : Ty} →
        Γ ⊢ A →
        ----
        Γ ⊢ (A + B)

    INR_ : {Γ : Ctx} {A B : Ty} →
        Γ ⊢ B →
        ----
        Γ ⊢ (A + B)
    
    MATCH_INL↦_INR↦_ : {Γ : Ctx} {A B C : Ty} → 
        Γ ⊢ (A + B) → 
        (Γ , A) ⊢ C → 
        (Γ , B) ⊢ C →
        ----
        Γ ⊢ C

extend-renaming : {Γ Δ : Ctx}
  → ({A : Ty} → A ∈ Γ → A ∈ Δ)
    --------------------------------------
  → {A B : Ty} → A ∈ (Γ , B) → A ∈ (Δ , B)
extend-renaming ρ Z = Z
extend-renaming ρ (S x) = S (ρ x)

rename : {Γ Δ : Ctx}
  → ({A : Ty} → A ∈ Γ → A ∈ Δ)
    -------------------------
  → {A : Ty} → Γ ⊢ A → Δ ⊢ A
rename ρ (VAR x) = VAR (ρ x)
rename ρ TRUE = TRUE
rename ρ FALSE = FALSE
rename ρ (IF M THEN N₁ ELSE N₂) = 
    IF (rename ρ M) THEN (rename ρ N₁) ELSE (rename ρ N₂)
rename ρ (M ∙ N) = rename ρ M ∙ rename ρ N
rename ρ (DO M IN N) = DO (rename ρ M) IN (rename (extend-renaming ρ) N)
rename ρ (RETURN V) = RETURN (rename ρ V)
rename ρ (ƛ M) = ƛ (rename (extend-renaming ρ) M)
rename ρ ⟨ M , N ⟩ = ⟨ rename ρ M , rename ρ N ⟩
rename ρ (FST M) = FST (rename ρ M)
rename ρ (SND M) = SND (rename ρ M)
rename ρ [] = []
rename ρ (M₁ ∷ M₂) = (rename ρ M₁) ∷ (rename ρ M₂) 
rename ρ (MATCH M WITH[]↦ M₁ ∷↦ M₂) = MATCH (rename ρ M) WITH[]↦ (rename ρ M₁) ∷↦ (rename (extend-renaming (extend-renaming ρ)) M₂)
rename ρ (INL M) = INL (rename ρ M)
rename ρ (INR M) = INR (rename ρ M)
rename ρ (MATCH M INL↦ M₁ INR↦ M₂) = MATCH (rename ρ M) INL↦ (rename (extend-renaming ρ) M₁) INR↦ (rename (extend-renaming ρ) M₂)


extend-subst : {Γ Δ : Ctx}
  → ({A : Ty} → A ∈ Γ → Δ ⊢ A)
    ---------------------------------------
  → {A B : Ty} → A ∈ (Γ , B) → (Δ , B) ⊢ A
extend-subst σ Z = VAR Z
extend-subst σ (S x) = rename S (σ x)

subst : {Γ Δ : Ctx}
  → ({A : Ty} → A ∈ Γ → Δ ⊢ A)
    -------------------------
  → {A : Ty} → Γ ⊢ A → Δ ⊢ A
subst σ (VAR x) = σ x
subst σ TRUE = TRUE
subst σ FALSE = FALSE
subst σ (IF M THEN N₁ ELSE N₂) =
    IF (subst σ M) THEN (subst σ N₁) ELSE (subst σ N₂)
subst σ (M ∙ N) = subst σ M ∙ subst σ N
subst σ (DO M IN N) = DO (subst σ M) IN (subst (extend-subst σ) N)
subst σ (RETURN V) = RETURN (subst σ V)
subst σ (ƛ M) = ƛ (subst (extend-subst σ) M)
subst σ ⟨ M , N ⟩ = ⟨ subst σ M , subst σ N ⟩
subst σ (FST M) = FST (subst σ M)
subst σ (SND M) = SND (subst σ M)
subst σ [] = []
subst σ (M₁ ∷ M₂) = (subst σ M₁) ∷ (subst σ M₂)
subst σ (MATCH M WITH[]↦ M₁ ∷↦ M₂) = MATCH (subst σ M) WITH[]↦ (subst σ M₁) ∷↦ (subst (extend-subst (extend-subst σ)) M₂)
subst σ (INL M) = INL (subst σ M)
subst σ (INR M) = INR (subst σ M)
subst σ (MATCH M INL↦ M₁ INR↦ M₂) = MATCH (subst σ M) INL↦ (subst (extend-subst σ) M₁) INR↦ (subst (extend-subst σ) M₂)


_[_] : {Γ : Ctx} {A B : Ty}
  → (Γ , B) ⊢ A
  → Γ ⊢ B
    -----
  → Γ ⊢ A
_[_] {Γ} {B = B} N M = subst σ N
  where
  σ : ∀ {A : Ty} → A ∈ (Γ , B) → Γ ⊢ A
  σ Z = M
  σ (S x) = VAR x

-- Za evalvacijo seznamov potrebujemo dvojno hkratno substitucijo
_[_][_] : {Γ : Ctx } {A B C : Ty}
  → ((Γ , A) , B) ⊢ C
  → Γ ⊢ A
  → Γ ⊢ B
    -------------
  → Γ ⊢ C
_[_][_] {Γ} {A} {B} N V W =  subst σ N
  where
  σ : ∀ {C} → C ∈ ((Γ , A) , B) → Γ ⊢ C
  σ Z          =  W
  σ (S Z)      =  V
  σ (S (S x))  =  VAR x


data value : {Γ : Ctx} {A : Ty} → Γ ⊢ A → Set where
    value-VAR : ∀ {Γ : Ctx} {A : Ty} (x : A ∈ Γ) → Γ ⊢ A → 
        -------------
        value (VAR x)

    value-TRUE : {Γ : Ctx} →
        ----------------
        value (TRUE {Γ})
    value-FALSE : {Γ : Ctx} →
        -----------------
        value (FALSE {Γ})
    value-LAMBDA : {Γ : Ctx} {A B : Ty} {M : (Γ , A) ⊢ B} →
        -----------
        value (ƛ M)
    value-PAIR : {Γ : Ctx} {A B : Ty} {M : Γ ⊢ A} {N : Γ ⊢ B} →
        value M →
        value N →
        -----------
        value ⟨ M , N ⟩

    value-NIL : {Γ : Ctx} {A : Ty} →
        value ([] {Γ} {A})
    value-CONS : {Γ : Ctx} {A : Ty} {M : Γ ⊢ A} {N : Γ ⊢ [ A ]t } →
        value M →
        value N →
        -----------
        value (M ∷ N)

    value-INL : {Γ : Ctx} {A B : Ty} {M : Γ ⊢ A} →
        value M → 
        -----------
        value (INL_ {B = B} M )
    value-INR : {Γ : Ctx} {A B : Ty} {M : Γ ⊢ B} →
        value M → 
        -----------
        value (INR_ {A = A} M)



data _↝_ : {Γ : Ctx} {A : Ty} → Γ ⊢ A → Γ ⊢ A → Set where
    IF-TRUE : {Γ : Ctx} {A : Ty} {M₁ M₂ : Γ ⊢ A} →
        ------------------------------
        (IF TRUE THEN M₁ ELSE M₂) ↝ M₁

    IF-FALSE : {Γ : Ctx} {A : Ty} {M₁ M₂ : Γ ⊢ A} →
        ------------------------------
        (IF FALSE THEN M₁ ELSE M₂) ↝ M₂

    DO-STEP : {Γ : Ctx} {A B : Ty} {M M' : Γ ⊢ A} {N : (Γ , A) ⊢ B} →
        M ↝ M' →
        ---------------------------
        (DO M IN N) ↝ (DO M' IN N)

    DO-RETURN-STEP : {Γ : Ctx} {A B : Ty} {V : Γ ⊢ A} {N : (Γ , A) ⊢ B} →
        value V →
        ----------------
        (DO (RETURN V) IN N) ↝ (N [ V ])
    
    APP-BETA : {Γ : Ctx} {A B : Ty} {M : (Γ , A) ⊢ B} {N : Γ   ⊢ A} →
        value N →
        ------------------------------------------------
        ((ƛ M) ∙ N) ↝ ( M [ N ])

    PAIR-STEP1 : {Γ : Ctx} {A B : Ty} {M M' : Γ ⊢ A} {N : Γ   ⊢ B} →
        M ↝ M' →
        ------------------------------------------------
      ⟨ M , N ⟩ ↝ ⟨ M' , N ⟩
    PAIR-STEP2 : {Γ : Ctx} {A B : Ty} {M : Γ ⊢ A} {N N' : Γ   ⊢ B} →
        value M →
        N ↝ N' →
        ------------------------------------------------
        ⟨ M , N ⟩ ↝ ⟨ M , N' ⟩
    FST-BETA : {Γ : Ctx} {A B : Ty} {M : Γ ⊢ A} {N : Γ   ⊢ B} →
        value M →
        value N →
        ------------------------------------------------
        FST ⟨ M , N ⟩ ↝ M
    SND-BETA : {Γ : Ctx} {A B : Ty} {M : Γ ⊢ A} {N : Γ   ⊢ B} →
        value M →
        value N →
        ------------------------------------------------
        SND ⟨ M , N ⟩ ↝ N

    --     
    LIST-STEP1 : {Γ : Ctx} {A : Ty} {M M' : Γ ⊢ A} {N : Γ ⊢ [ A ]t } →
        M ↝ M' →
        ------------------------------------------------
        (M ∷ N) ↝ (M' ∷ N)
        
    LIST-STEP2 : {Γ : Ctx} {A : Ty} {M : Γ ⊢ A} {N N' : Γ ⊢ [ A ]t} →
        value M →
        N ↝ N' →
        ------------------------------------------------
        (M ∷ N) ↝ (M ∷ N')

    LIST-MATCH-STEP : {Γ : Ctx} {A B : Ty} {M M' : Γ ⊢ [ A ]t } {N₁ : Γ ⊢ B} {N₂ : ((Γ , A) , [ A ]t ) ⊢ B } →
        M ↝ M' →
        ------------------------------------------------
        (MATCH M WITH[]↦ N₁ ∷↦ N₂) ↝ (MATCH M' WITH[]↦ N₁ ∷↦ N₂)

    LIST-MATCH-NIL-BETA : {Γ : Ctx} {A B : Ty} {N₁ : Γ ⊢ B} {N₂ : ((Γ , A) , [ A ]t ) ⊢ B } →
        ------------------------------------------------
        (MATCH [] WITH[]↦ N₁ ∷↦ N₂) ↝ N₁

    LIST-MATCH-CONS-BETA : 
            {Γ : Ctx} {A B : Ty} {M₁ : Γ ⊢ A } 
            {M₂ : Γ ⊢ [ A ]t } {N₁ : Γ ⊢ B} 
            {N₂ : ((Γ , A) , [ A ]t ) ⊢ B } →
            value M₁ →
            value M₂ →
            ------------------------------------------------
            (MATCH (M₁ ∷ M₂) WITH[]↦ N₁ ∷↦ N₂) ↝ (N₂ [ M₁ ][ M₂ ])
        -- Namiga:
        --  - Razmislite, ali potrebujete še kakšne dodatne informacije za M₁ in M₂.
        --  - Za substitucijo uporabite _[_][_].
          

    INL-STEP : {Γ : Ctx} {A B : Ty} {M M' : Γ ⊢ A} → 
        M ↝ M' → 
        ------------------------------------------------
        (INL_ {B = B} M) ↝ (INL M')

    INR-STEP : {Γ : Ctx} {A B : Ty} {M M' : Γ ⊢ B} → 
        M ↝ M' → 
        ------------------------------------------------
        (INR_ {A = A} M) ↝ (INR M')
    
    VARIANT-MATCH-STEP : {Γ : Ctx} {A B C : Ty} {M M' : Γ ⊢ (A + B)} {N₁ : (Γ , A) ⊢ C} {N₂ : (Γ , B) ⊢ C } →
        M ↝ M' →
        ------------------------------------------------
        (MATCH M INL↦ N₁ INR↦ N₂) ↝ ((MATCH M' INL↦ N₁ INR↦ N₂))
    
    VARIANT-MATCH-BETA-INL : {Γ : Ctx} {A B C : Ty} {M : Γ ⊢ A } {N₁ : (Γ , A) ⊢ C} {N₂ : (Γ , B) ⊢ C } →
        value M →
        ------------------------------------------------
        (MATCH (INL M) INL↦ N₁ INR↦ N₂) ↝ (N₁ [ M ])

    VARIANT-MATCH-BETA-INR : {Γ : Ctx} {A B C : Ty} {M : Γ ⊢ A } {N₁ : (Γ , B) ⊢ C} {N₂ : (Γ , A) ⊢ C } →
        value M →
        ------------------------------------------------
        (MATCH (INR M) INL↦ N₁ INR↦ N₂) ↝ (N₂ [ M ])
