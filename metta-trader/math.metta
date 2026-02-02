(= (sum $list) (
    if (== $list ())
        0
        (+ (car-atom $list) (sum (cdr-atom $list)))
))