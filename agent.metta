!(register-module! ../agent-psi)
!(import! &self agent-psi:utils:math)
!(import! &self agent-psi:utils:utils)
!(import! &self agent-psi:agent-utils)


(= (agent-loop $contexts $goal) (
    let* (
        ($applicableRules (matchGoal $goal &rules))
        ($applicableActions )
    )
))

!(bind! &rules (new-space))

!(addRules &rules)
!(agent-loop ((Position 1) (Sitting)) (Reward))