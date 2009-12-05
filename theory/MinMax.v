Require Import
  RelationClasses Morphisms
  abstract_algebra.

Section contents.

  Context `{Equiv A} `{Order A} `{forall x y: A, Decision (x <= y)}.

  Section twovars.

    Variables x y: A.

    Definition sort: prod A A := if decide (x <= y) then (x, y) else (y, x).
    Definition min := fst sort.
    Definition max := snd sort.

    Lemma max_ub_l `{Reflexive _ precedes}: x <= max.
    Proof. unfold max, sort. intros. destruct decide; firstorder. Qed.

    Lemma max_r: x <= y -> max = y.
    Proof. unfold max, sort. intros. destruct decide; firstorder. Qed.

  End twovars.

  Lemma max_idem x: max x x = x.
  Proof. intros. unfold max, sort. destruct decide; reflexivity. Qed.

  Global Instance max_proper `{!Proper (equiv ==> equiv ==> iff) precedes}: Proper (equiv ==> equiv ==> equiv) max.
  Proof with assumption.
   intros p x y E x' y' E'.
   unfold max, sort.
   do 2 destruct decide; simpl.
      firstorder. 
     exfalso. apply n. apply -> (p x y E x')...
    exfalso. apply n. apply <- (p x y E x' y')...
   firstorder.
  Qed.

  Section more_props.

    Context `{!TotalOrder precedes} `{!PartialOrder precedes}.

    Lemma max_comm (x y: A): max x y == max y x.
    Proof. intros. unfold max, sort. destruct (decide (x <= y)); destruct (decide (y <= x)); firstorder. Qed.

    Lemma max_ub_r (x y: A): y <= max x y.
    Proof. intros. rewrite max_comm. apply max_ub_l. firstorder. Qed.

    Lemma max_assoc (x y z: A): max x (max y z) == max (max x y) z.
    Proof with try assumption.
     unfold max, sort.
     intros.
     repeat destruct decide; try reflexivity; try intuition; simpl in *.
      exfalso.
      apply n.
      transitivity y...
     destruct (total_order x y); intuition.
     destruct (total_order y z); intuition.
     apply (antisymmetry precedes)...
     transitivity y...
    Qed.

    Lemma max_l x y: x <= y -> max y x == y.
    Proof. intros. rewrite max_comm, max_r; firstorder. Qed.

  End more_props.

End contents.

(* hm, min should just be max on the inverse order. would be nice if we could do that niftyly *)