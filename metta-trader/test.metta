!(import! &self rule-ops)
;; Travel Info
(TRAVEL_COST A B 1)
(TRAVEL_COST A C 1)
(TRAVEL_COST B A 1)
(TRAVEL_COST B C 1)
(TRAVEL_COST C A 1)
(TRAVEL_COST C B 1)


(FOOD A 8)
(FOOD B 20)
(FOOD C 18)

(METAL A 15)
(METAL B 8)
(METAL C 22)

(FUEL A 25)
(FUEL B 18)
(FUEL C 5)

(AVG_PRICE FOOD 15)
(AVG_PRICE METAL 15)
(AVG_PRICE FUEL 16)

;; Helper Functions
(= (getTravelCost $source $destination) (
    match &self (TRAVEL_COST $source $destination $cost) $cost
))

(= (getFoodCost $planet) (
    match &self (FOOD $planet $cost) $cost
))

(= (getMetalCost $planet) (
    match &self (METAL $planet $cost) $cost
))

(= (getFuelCost $planet) (
    match &self (FUEL $planet $cost) $cost
))

(= (getItemPrice $item $planet) (
    match &self ($item $planet $price) $price
))

(= (getAvgPrice $item) (
    match &self (AVG_PRICE $item $price) $price
))

(= (getItem $contexts) (
    if (== $contexts ())
        ()
        (let* (
            (($head $tail) (decons-atom $contexts))
            ($contextType (index-atom $head 0))
            ($itemName (index-atom $head 1))
        ) (if (== $contextType HAS)
            $itemName
            (getItem $tail)
        ))
))

!(getItem ((HAS FOOD STV) (PLANET A STV) (HAS METAL STV)))

(= (evaluateState $contexts $money) (
    let* (
        ($item (getItem $contexts))
        ($itemValue (getAvgPrice $item))
    ) (+ $itemValue $money)
))

!(evaluateState ((HAS FOOD STV) (PLANET A STV)) 10)


(= (getPlanetFromContexts $contexts) (
    let* (
        (($head $tail) (decons-atom $contexts))
        ($contextType (index-atom $head 0))
        ($contextValue (index-atom $head 1))
    ) (if (== $contextType PLANET)
        $contextValue
        (getPlanetFromContexts $tail)
    ))
)

!(getPlanetFromContexts ((PLANET A) (HAS METAL STV)))

(= (isValidRule $contexts $money $rule) (
    let* (
        ($ruleContext (extractRule ContextValues $rule))
        ($ruleActions (extractRule Action $rule))
        ($ruleGoal (extractRule GoalValues $rule))
        ($_ (println! ($ruleContext $ruleActions $ruleGoal)))

        ($ruleAction (car-atom $ruleActions))
        ($currPlanet (getPlanetFromContexts $contexts))
        ($rulePlanet (getPlanetFromContexts $ruleContext))
        ($_ (println! ($currPlanet $rulePlanet)))
    ) (if (not (== $currPlanet $rulePlanet)) 
        False
        (case $ruleAction (
            (TRAVEL (
                let* (
                    ($source (getPlanetFromContexts $ruleContext))
                    ($destination (getPlanetFromContexts $ruleGoal))
                    ($cost (getTravelCost $source $destination))
                ) (if (> $cost $money)
                    False
                    True
                )
            ))

            (SELL (
                let* (
                    ($item (index-atom $ruleActions 1))
                    ($currItem (getItem $contexts))
                ) (if (== $item $currItem)
                    True
                    False
                )
            ))

            (BUY (
                let* (
                    ($item (getItem $ruleGoal))
                    ($itemPrice (getItemPrice $item $currPlanet))
                ) (if (>= $money $itemPrice ) 
                    True
                    False
                )
            ))
    ))
)))

(= (Rule22) (: Rule 22
            (TTV 0)
            (STV 0.5 0.002)
            (Complexity 1)
            (IMPLICATION
                (AND
                    (Context (STV 0.2 0.1) (AND (
                        (PLANET A (STV 0.2 0.1))
                    )))
                    (Action (SEQ_AND (BUY FUEL)))
                )
                (Goal (STV 0.2 0.1) (AND (
                    (PLANET A (STV 0.2 0.1))
                    (HAS FUEL (STV 0.1 0.1))
                )))
        )))

!(isValidRule ((PLANET A)) 24 (Rule22))

(= (updatePlanet $contexts $planet) (
    if (== $contexts ())
        ()
        (let* (
            (($head $tail) (decons-atom $contexts))
            ($contextType (index-atom $head 0))
            ($contextValue (index-atom $head 1))
            ($rest (updatePlanet $tail $planet))
        ) (if (== $contextType PLANET)
            (cons-atom (PLANET $planet) $rest)
            (cons-atom $head $rest)
        )))
)

!(updatePlanet ((PLANET A) (HAS FOOD)) B)

(= (removeItem $contexts $item) (
    if (== $contexts ())
        ()
        (let* (
            (($head $tail) (decons-atom $contexts))
            ($contextType (index-atom $head 0))
            ($contextValue (index-atom $head 1))
            ($rest (removeItem $tail $item))
        ) (if (== $contextValue $item)
            $rest
            (cons-atom $head $rest)
        ))
))

!(removeItem ((PLANET A) (HAS FOOD) (HAS FUEL)) FOOD)

(= (addItem $contexts $item) (
    if (== $contexts ())
        (cons-atom (HAS $item) ())
        (let* (
            (($head $tail) (decons-atom $contexts))
            ($contextType (index-atom $head 0))
            ($contextValue (index-atom $head 1))
            ($rest (addItem $tail $item))
        ) (if (== $contextValue $item)
            $rest
            (cons-atom $head $rest)
        ))
))

!(addItem ((PLANET A) (HAS FOOD)) FUEL)