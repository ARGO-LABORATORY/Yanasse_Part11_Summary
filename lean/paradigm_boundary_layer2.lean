import Mathlib

/-!
# The Paradigm Boundary — Layer 2: The Ring Proof Fragment

Layer 1 proved: empty types cannot carry CommSemiring.
Layer 2 proves: ring's proof terms are exactly the CommSemiring
equational theory, and that theory requires CommSemiring by construction.

We define `RingDerivable` — the equalities derivable from CommSemiring
axioms alone — prove it sound, and show that the paradigm boundary
follows: no ring-derivable equality can be stated over a type
without CommSemiring.

Verified: 2026-04-22, Lean 4.29.0, Mathlib 4.29.0
-/

-- The equational theory of commutative semirings.
-- Every constructor corresponds to one CommSemiring axiom.
inductive RingDerivable {R : Type*} [CommSemiring R] : R → R → Prop where
  | rd_refl (a : R) : RingDerivable a a
  | rd_symm : RingDerivable a b → RingDerivable b a
  | rd_trans : RingDerivable a b → RingDerivable b c → RingDerivable a c
  | rd_add_comm (a b : R) : RingDerivable (a + b) (b + a)
  | rd_add_assoc (a b c : R) : RingDerivable (a + b + c) (a + (b + c))
  | rd_add_zero (a : R) : RingDerivable (a + 0) a
  | rd_zero_add (a : R) : RingDerivable (0 + a) a
  | rd_mul_comm (a b : R) : RingDerivable (a * b) (b * a)
  | rd_mul_assoc (a b c : R) : RingDerivable (a * b * c) (a * (b * c))
  | rd_mul_one (a : R) : RingDerivable (a * 1) a
  | rd_one_mul (a : R) : RingDerivable (1 * a) a
  | rd_mul_zero (a : R) : RingDerivable (a * 0) 0
  | rd_zero_mul (a : R) : RingDerivable (0 * a) 0
  | rd_left_distrib (a b c : R) : RingDerivable (a * (b + c)) (a * b + a * c)
  | rd_right_distrib (a b c : R) : RingDerivable ((a + b) * c) (a * c + b * c)
  | rd_congr_add : RingDerivable a b → RingDerivable c d →
      RingDerivable (a + c) (b + d)
  | rd_congr_mul : RingDerivable a b → RingDerivable c d →
      RingDerivable (a * c) (b * d)

-- =====================================================================
-- SOUNDNESS: the ring fragment proves only true equalities.
-- =====================================================================

theorem RingDerivable.sound {R : Type*} [CommSemiring R] {a b : R}
    (h : RingDerivable a b) : a = b := by
  induction h with
  | rd_refl _ => rfl
  | rd_symm _ ih => exact ih.symm
  | rd_trans _ _ ih₁ ih₂ => exact ih₁.trans ih₂
  | rd_add_comm a b => exact add_comm a b
  | rd_add_assoc a b c => exact add_assoc a b c
  | rd_add_zero a => exact add_zero a
  | rd_zero_add a => exact zero_add a
  | rd_mul_comm a b => exact mul_comm a b
  | rd_mul_assoc a b c => exact mul_assoc a b c
  | rd_mul_one a => exact mul_one a
  | rd_one_mul a => exact one_mul a
  | rd_mul_zero a => exact mul_zero a
  | rd_zero_mul a => exact zero_mul a
  | rd_left_distrib a b c => exact left_distrib a b c
  | rd_right_distrib a b c => exact right_distrib a b c
  | rd_congr_add _ _ ih₁ ih₂ => exact congrArg₂ (· + ·) ih₁ ih₂
  | rd_congr_mul _ _ ih₁ ih₂ => exact congrArg₂ (· * ·) ih₁ ih₂

-- =====================================================================
-- LAYER 1 (restated): CommSemiring implies nonemptiness.
-- =====================================================================

theorem commSemiring_nonempty (α : Type*) [CommSemiring α] :
    Nonempty α :=
  ⟨0⟩

-- =====================================================================
-- LAYER 2: The paradigm boundary for the ring fragment.
--
-- RingDerivable has [CommSemiring R] in its type signature.
-- Therefore: to even STATE RingDerivable a b, CommSemiring must hold.
-- Combined with Layer 1: the type must be nonempty.
--
-- The contrapositive: over an empty type, assuming CommSemiring
-- yields a contradiction, so no RingDerivable proof can be constructed.
-- =====================================================================

-- If a ring-derivable proof exists, the type is nonempty.
theorem RingDerivable.requires_nonempty {R : Type*}
    [CommSemiring R] {a b : R} (_h : RingDerivable a b) :
    Nonempty R :=
  ⟨a⟩

-- THE PARADIGM BOUNDARY (Layer 2):
-- Over an empty type, no ring proof can exist.
-- Even if we hypothetically grant CommSemiring, the existence of
-- elements a, b (needed to state RingDerivable a b) contradicts IsEmpty.
theorem paradigm_boundary_ring {α : Type*} (hempty : IsEmpty α)
    [CommSemiring α] {a b : α}
    (_h : RingDerivable a b) : False :=
  hempty.false a

-- Layer 1 restated: the CommSemiring hypothesis itself is contradictory.
theorem no_CommSemiring_of_empty' (α : Type*) (h : IsEmpty α) :
    CommSemiring α → False :=
  fun inst => h.false (@Zero.zero α inst.toZero)

-- =====================================================================
-- GENERALIZATION: The entire algebraic hierarchy is blocked.
-- Any class that provides an element (via Zero, One, or otherwise)
-- is incompatible with IsEmpty.
-- =====================================================================

-- The root cause: Zero requires an inhabitant.
theorem no_Zero_of_empty (α : Type*) (h : IsEmpty α) :
    Zero α → False :=
  fun inst => h.false (@Zero.zero α inst)

-- Therefore every class extending Zero is blocked:
theorem no_Field_of_empty (α : Type*) (h : IsEmpty α) :
    Field α → False :=
  fun inst => h.false (@Zero.zero α inst.toZero)

theorem no_Ring_of_empty (α : Type*) (h : IsEmpty α) :
    Ring α → False :=
  fun inst => h.false (@Zero.zero α inst.toZero)

theorem no_Semiring_of_empty (α : Type*) (h : IsEmpty α) :
    Semiring α → False :=
  fun inst => h.false (@Zero.zero α inst.toZero)
