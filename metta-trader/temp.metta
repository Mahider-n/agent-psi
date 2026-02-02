!(import! &self rule-ops)

(= (TestRule) (: Rule 12
    (TTV 0)
    (STV 0.5 0.002)
    (Complexity 1)
    (IMPLICATION
        (AND
            (Context (STV 0.2 0.1) (AND (
                (PLANET_C (STV 0.2 0.1))
            )))
            (Action (SEQ_AND (BUY METAL)))
        )
        (Goal (STV 0.2 0.1) (AND (
            (PLANET_C (STV 0.2 0.1))
            (HAS_METAL (STV 0.2 0.1))
        )))
))
)

!(assertEqual (extractRule Id (TestRule)) 1)
!(assertEqual (extractRule TTV (TestRule)) 3)
!(assertEqual (extractRule STV (TestRule)) (STV 0.5 0.002))

!(assertEqual (extractRule AllContext (TestRule)) (Context (STV 0.3 0.15) (AND ((LEFT_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1))))))
!(assertEqual (extractRule Context (TestRule)) ((LEFT_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1))))
!(assertEqual (extractRule ContextSTV (TestRule)) (STV 0.3 0.15))
!(assertEqual (extractRule ContextValues (TestRule)) (LEFT_SQUARE STILL_ALIVE))

!(assertEqual (extractRule Action (TestRule)) (MOVE_RIGHT JUMP))
!(assertEqual (extractRule ContextAndAction (TestRule)) (AND (Context (STV 0.3 0.15) (AND ((LEFT_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1))))) (Action (SEQ_AND (MOVE_RIGHT JUMP)))))

!(assertEqual (extractRule AllGoal (TestRule)) (Goal (STV 0.4 0.1) (AND ((CENTER_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1))))))
!(assertEqual (extractRule Goal (TestRule)) ((CENTER_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1))))
!(assertEqual (extractRule GoalSTV (TestRule)) (STV 0.4 0.1))
!(assertEqual (extractRule GoalValues (TestRule)) (CENTER_SQUARE STILL_ALIVE))