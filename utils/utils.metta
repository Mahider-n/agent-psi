;; Add rules to space 
(= (addRules $space) (
    add-reduct $space 
        (superpose (
            (: Rule 1
                (STV 0.5 0.1) 
                (Context ((Position 1)))
                (Action (Move Right))
                (Goal (Position-2))
            )       

            (: Rule 2
                (STV 0.5 0.1) 
                (Context ((Position 2)))
                (Action (Move Left))
                (Goal (Position 1))
            )  

            (: Rule 3
                (STV 0.5 0.1) 
                (Context ((Position 2)))
                (Action (Move Right))
                (Goal (Position 3))
            )  

            (: Rule 4
                (STV 0.5 0.1) 
                (Context ((Position 3)))
                (Action (Move Left))
                (Goal (Position 2))
            ) 

            (: Rule 5
                (STV 0.5 0.1) 
                (Context ((Position 3)))
                (Action (Move Right))
                (Goal (Position 4))
            ) 

            (: Rule 6
                (STV 0.5 0.1) 
                (Context ((Position 4)))
                (Action (Move Left))
                (Goal (Position 3))
            ) 

            (: Rule 7
                (STV 0.8 0.6) 
                (Context ((Standing)))
                (Action (Sitting Down))
                (Goal (Sitting))
            ) 

            (: Rule 8
                (STV 0.8 0.6) 
                (Context (Sitting))
                (Action (Standing Up))
                (Goal (Standing))
            )

            (: Rule 9
                (STV 0.8 0.6) 
                (Context ((Position 3) (Standing)))
                (Action (Claim))
                (Goal (Reward))
            )
        ))
))

; !(bind! &space (new-space))
; !(addRules &space)

; !(get-atoms &space)
