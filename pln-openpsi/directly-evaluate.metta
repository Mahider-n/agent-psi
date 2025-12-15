!(import! &self utils:rule-ops)
!(import! &self utils:util)
!(import! &self utils:directly-evaluate-utils)

;; ============================================================================
;; Main Entry Point: pln-directly-evaluate
;; ============================================================================

(= (pln-directly-evaluate $ruleSpace $perceptaSpace) (
    let* (
        ($_ (println! "PLN Direct Evaluation Started"))
        ($rules (collapse (get-atoms $ruleSpace)))
        ($allPerceptas (collapse (get-atoms $perceptaSpace)))
        ($perceptas (map-atom $allPerceptas $percept (extract-percepta-values $percept)))
        ($evaluatedRules (evaluate-all-rules $rules $perceptas))
        ($_ (println! "PLN Direct Evaluation Completed"))
    ) $evaluatedRules
))

;; ============================================================================
;; Rule Evaluation Recursion
;; ============================================================================

(= (evaluate-all-rules $rules $perceptas) (
    if (<= (size-atom $rules) 0)
        ()
        (let* (
            (($rule $remRules) (decons-atom $rules))
            ($evaluatedRule (directly-evaluate $rule $perceptas))
            ($_ (println! ("Evaluated Rule: " (extractRule Id $rule))))
            ($restEvaluated (evaluate-all-rules $remRules $perceptas))
        ) (cons-atom $evaluatedRule $restEvaluated))
))

;; ============================================================================
;; Core Evaluation Function: directly-evaluate
;; ============================================================================


(= (directly-evaluate $rule $perceptas) (
    let* (
        ;; Step 1: Extract context information from rule
        ($ruleContext (extractRule ContextValues $rule))
        
        ;; Step 2: Get all perceptions from percepta space
        ($perceptaCount (size-atom $perceptas))
        
        ;; Step 3: Count matching perceptions
        ($matchCount (facts-in-percepta $ruleContext $perceptas))
        ($_ (println! (Match Count: $matchCount " out of " $perceptaCount)))
        ($totalCount $perceptaCount)
        ;; Step 4 & 5: Calculate frequency and confidence
        ($frequency (if (== $totalCount 0) 0 (div $matchCount $totalCount)))
        ($confidence (calculate-confidence $matchCount $totalCount))
        ($roundedConfidence (round $confidence 4))
        ($newContextSTV (STV $frequency $roundedConfidence))
        ($_ (println! (Total Count: $totalCount " | Match Count: " $matchCount " | Frequency: " $frequency " | Confidence: " $roundedConfidence)))
        
        ;; Step 6 & 7: Build updated rule with new context STV
        ($updatedRule (construct-rule-with-new-context-stv $rule $newContextSTV))
        ($_ (println! ("Rule ID: " (extractRule Id $rule) " | Matches: " $matchCount " / " $totalCount " | Frequency: " $frequency)))
    ) $updatedRule
))

;; ============================================================================
;; Utility Functions for directly-evaluate
;; ============================================================================

;; (count-matching-perceptions $contextFacts $perceptions $accumulator) -> $count

;; Can be simplified using superpose or map-atom
(= (count-matching-perceptions $contextFacts $perceptions) (
    if (== $perceptions ())
        0
        (let* (
            (($perception $remaining) (decons-atom $perceptions))
            ; ($perceptionFacts (extract-percepta-values $perception))
            ($isMatch (facts-in-percepta $contextFacts $perceptions))
            ($_ (println! ("Checking perception:" $perceptions Resulted: $isMatch)))
            ($rest (count-matching-perceptions $contextFacts $remaining))
        ) (if $isMatch
            (+ 1 $rest)
            $rest))
))
; !(count-matching-perceptions (LEFT_SQUARE STILL_ALIVE) 
;     (
;         (LEFT_SQUARE STILL_ALIVE)
;         (CENTER_SQUARE STILL_ALIVE)
;         (LEFT_SQUARE STILL_ALIVE)
;     )
; ) 

;; (facts-in-percepta $contextFacts $perceptionFacts) -> Bool
;;
;; Purpose:
;;   Checks if all context facts are present in a perception
;;
;; Process:
;;   Uses areSimilar to verify all required facts exist in the perception
(= (facts-in-percepta $contextFact $perceptionFacts) (
    if (== () $perceptionFacts)
        0
        (let* (
            (($pfact $remPfacts) (decons-atom $perceptionFacts))
            ($matchFound (areSimilar $contextFact $pfact))
            ; ($_ (println! ("Comparing Context Fact:" $contextFact " with Perception Fact:" $pfact " Resulted: " $matchFound)))
            ($restResult (facts-in-percepta $contextFact $remPfacts))
        ) (if $matchFound
            (+ 1 $restResult)
            $restResult))
))

;; (extract-percepta-values $percepta) -> $factsList

(= (extract-percepta-values $percepta) (
    ; unify (: Percepta $id (AND $facts)) $percepta
    ;     $facts
    ;     (unify (: Percepta $id $fact) $percepta
    ;         ($fact)
    ;         ()
    ;     )
    unify (: Percepta $id $facts) $percepta
        $facts
        ()
))

; !(extract-percepta-values (: Percepta 0 (LEFT_SQUARE STILL_ALIVE))) --- IGNORE ---

;; (construct-rule-with-new-context-stv $rule $newContextSTV) -> $updatedRule
; (: Rule 3
;     (TTV 0)
;     (STV 0.5 0.002)
;     (Complexity 1)
;     (IMPLICATION
;         (AND 
;             (Context (STV 0.2 0.1) (AND (
;                 (RIGHT_SQUARE)
;                 (STILL_ALIVE))))
;             (Action (SEQ_AND (MOVE_LEFT))))
;         (Goal (STV 0.2 0.1) (AND (
;                 (CENTER_SQUARE)
;                 (STILL_ALIVE)))
;     ))
; )
(= (construct-rule-with-new-context-stv $rule $newContextSTV) (
    ; unify (: Rule $id $ttv $stv $complexity (IMPLICATION (AND (Context $_ (AND $contextFacts)) $action) $goal))
    ;     $rule
    ;     (: Rule $id $ttv $stv $complexity (IMPLICATION (AND (Context $newContextSTV (AND $contextFacts)) $action) $goal))
    ;     $rule
    let* (
        ((: Rule $id $ttv $stv $complexity (IMPLICATION (AND (Context $_ $contexts) $action) $goal)) $rule)
    ) (: Rule $id $ttv $stv $complexity (IMPLICATION (AND (Context $newContextSTV $contexts) $action) $goal))
))

;; ============================================================================
;; Confidence Calculation
;; ============================================================================

;; (calculate-confidence $matchCount $totalCount) -> $confidence
(= (calculate-confidence $matchCount $totalCount) (
    let $K 800
    (if (== $totalCount 0)
        0
        (div $matchCount (+ $K $matchCount))
    )
))
