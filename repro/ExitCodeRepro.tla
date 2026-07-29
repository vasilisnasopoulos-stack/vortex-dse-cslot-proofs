---- MODULE ExitCodeRepro ----
(***************************************************************************)
(* Minimal reproducer: one obligation that closes, one that cannot.        *)
(* Expectation under discussion: tlapm should signal the failure through   *)
(* its exit status, not only through its output text.                      *)
(***************************************************************************)
EXTENDS Naturals

THEOREM Provable == 1 = 1
  OBVIOUS

THEOREM Unprovable == 1 = 2
  OBVIOUS

====
