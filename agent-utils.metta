;; Match from the rules using the goal
(= (match-goal $goal $space) (
    match $space (: Rule $id $stv $context $action (Goal $goal)) (: Rule $id $stv $context $action (Goal $goal))
))

(= (extract-action $rule) (
    let (: Rule $id $stv $context (Action $action) $goal) $rule $action
))
; !(extract-action (: Rule 2 (STV 0.8 0.6) (Context ((Position 3) (Standing))) (Action (Claim)) (Goal (Reward))))

(= (extract-stv $rule) (
    let (: Rule $id (STV $s $c) $context (Action $action) $goal) $rule ($s $c)
))
; !(extract-stv (: Rule 2 (STV 0.8 0.6) (Context ((Position 3) (Standing))) (Action (Claim)) (Goal (Reward))))

(= (confidence-to-count $confidence) (
    / (* $confidence 800) (- 1 $confidence)
))

(= (count-to-confidence $count) (
    / $count (+ 800 $count)
))

(= (stv-to-beta ($strength $confidence)) (
    let* (
        ($count (confidence-to-count $confidence))
        ($alpha (* $strength $count))
        ($beta (- $count $alpha))
    ) ($alpha $beta)
))

(= (beta-to-stv ($alpha $beta)) (
    let* (
        ($count (+ $alpha $beta))
        ($strength (/ $alpha $count))
        ($confidence (count-to-confidence $count))
    ) ($strength $confidence)
))

; !(stv-to-beta (0.8 0.5))
; !(beta-to-stv (stv-to-beta (0.8 0.5)))
; !(index-atom (1 2 3 3 5) 4)