(= (loop $contexts $money $ruleSpace) (
    let* (
        ($reasonedRules (pln-reasoner $ruleSpace))
        ;; ($_ (let $rule (superpose $reasonedRules) (add-reduct $rule $ruleSpace)))
        ($applicableRules (getApplicableRules $contexts $money $ruleSpace))
        ($selectedRule (thompson-sample $applicableRules))
        ($newContexts (applyRule $selectedRule $contexts))
        ($newMoney (updateMoney $selectedRule $money))  
        ($oldStateValue (evaluateState $contexts $money))
        ($newStateValue (evaluateState $newContexts $money))
        ($reward (evaluateReward $oldStateValue $newStateValue))
        ($_ (updateRuleSTV $selectedRule $reward))
    ) (if (or ($newMoney <= 0) (== 0 (size-atom $applicableRules)))
        "Out of money!"
        (loop $newContexts $newMoney $ruleSpace)
    )
))

(= (isValidRule $context $rule) (

))

(= (getApplicableRules $contexts $money $ruleSpace) (
    
))

(= (applyRule $rule $contexts) (

))

(= (updateMoney $rule $money) (
    let* (
        ($action (extractRule Action $rule))
    )
))

(= (evaluateState $contexts $money) (
    
))