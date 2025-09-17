
;; Returns a random number between 0 - 1
; TODO: implement manually for mettalog compatibility
(= (getRandom) (
    (py-atom random.random)
))

;; Returns the logarithm of a value to the base given
; TODO: implement manually
(= (log $value) (
    (py-atom math.log) $value
))

(= (sqrt $num) (
    (py-atom math.sqrt) $num
))

(= (exp $num) (
    (py-atom math.exp) $num
))

(= (max $x $y) (if (> $x $y) $x $y))
(= (min $x $y) (if (> $x $y) $y $x))

(= (sample-engine $alpha $beta $a $b $gamma) (
    let* (
        ($u1 (getRandom))
        ($u2 (getRandom))
        ($v (* $beta (log (/ $u1 (- 1 $u1)))))
        ($w (* $a (exp $v)))
        ($temp (log (/ $alpha (+ $b $w))))
        ($left (+ (* $alpha $temp) (* $gamma $v)))
        ($right (+ (log 4) (log (* (* $u1 $u1) $u2))))
    ) (if (>= $left $right)
        (/ $w (+ $b $w))
        (sample-engine $alpha $beta $a $b $gamma)
    )
))

(= (sample $a $b) (
    let* (
        ($alpha (+ $a $b))
        ($beta (if (<= (min $a $b) 1) (max (/ 1 $a) (/ 1 $b)) (sqrt (/ (- $alpha 2) (- (* 2 (* $a $b)) $alpha))))) 
        ($gamma (/ (+ $a 1) $beta))
    ) (sample-engine $alpha $beta $a $b $gamma)
))

!(sample 100000 1)