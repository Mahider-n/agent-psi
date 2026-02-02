(= (loop $contexts $money $ruleSpace) (
    let* (
        ($reasonedRules (pln-reasoner $ruleSpace))
        ;; ($_ (let $rule (superpose $reasonedRules) (add-reduct $rule $ruleSpace)))
        ($applicableRules (getApplicableRules $contexts $money $ruleSpace))
        ($selectedRule (thompson-sample $applicableRules))
        ($newContexts (applyRule $selectedRule $contexts))
        ($newMoney (updateMoney $selectedRule $money))  
    )
    (loop $newContexts $newMoney $ruleSpace)
))

