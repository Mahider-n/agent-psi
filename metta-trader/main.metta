(= (loop $contexts $money $ruleSpace) (
    let* (
        ;; ($reasonedRules (pln-reasoner $ruleSpace))
        ;; ($_ (let $rule (superpose $reasonedRules) (add-reduct $rule $ruleSpace)))
        ($rules (collapse (get-atoms $ruleSpace)))
        ($applicableRules (getApplicableRules $contexts $money $rules))
        ($selectedRule (thompson-sample $applicableRules))
        (($newContexts $newMoney) (applyRule $selectedRule $contexts))
        ($oldStateValue (evaluateState $contexts $money))
        ($newStateValue (evaluateState $newContexts $newMoney))
        ($reward (- $newStateValue $oldStateValue))
        ($_ (updateRule $selectedRule $reward $ruleSpace))
    )
    (loop $newContexts $newMoney $ruleSpace)
))


!(bind! &ruleSpace (new-space))
!(initializeSpace &ruleSpace)

!(loop ((PLANET A)) 100 &ruleSpace)