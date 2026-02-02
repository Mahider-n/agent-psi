;; Travel Info
(TRAVEL_COST A B 1)
(TRAVEL_COST A C 1)
(TRAVEL_COST B A 1)
(TRAVEL_COST B C 1)
(TRAVEL_COST C A 1)
(TRAVEL_COST C B 1)


(FOOD_COST A 8)
(FOOD_COST B 20)
(FOOD_COST C 18)

(METAL_COST A 15)
(METAL_COST B 8)
(METAL_COST C 22)

(FUEL_COST A 25)
(FUEL_COST B 18)
(FUEL_COST C 5)

(AVG_PRICE FOOD 15)
(AVG_PRICE METAL 15)
(AVG_PRICE FUEL 16)

;; Helper Functions
(= (getTravelCost $source $destination) (
    match &self (TRAVEL_COST $source $destination $cost) $cost
))

(= (getFoodCost $planet) (
    match &self (FOOD_COST $planet $cost) $cost
))

(= (getMetalCost $planet) (
    match &self (METAL_COST $planet $cost) $cost
))

(= (getFuelCost $planet) (
    match &self (FUEL_COST $planet $cost) $cost
))

(= (getAvgPrice $item) (
    match &self (AVG_PRICE $item $price) $price
))