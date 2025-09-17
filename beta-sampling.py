import random
from math import sqrt, log, exp

class BetaSampler:
    def __init__(self, seed: float):
        self.rng = random.Random(seed)
    
    def sample(self, a: float, b: float) -> float:
        alpha = a + b
        beta = 0
        u1, u2, w, v = 0.0, 0.0, 0.0, 0.0,

        if min(a, b) <= 1:
            beta = max(1 / a, 1 / b)
        else:
            beta = sqrt((alpha - 2) / (2 * a * b - alpha))
        gamma = a + 1 / beta

        failure_count = 0
        while True:
            u1 = self.rng.random()
            u2 = self.rng.random()

            v = beta * log(u1 / (1 - u1))
            w = a * exp(v)

            temp = log(alpha / (b + w))
            if (alpha * temp + (gamma * v) - 1.3862944 >= log(u1 * u1 * u2)):
                break
            failure_count += 1
        
        x = w / (b + w)
        # print(failure_count, x)
        return x


# Plot the distribution
import matplotlib.pyplot as plt

sampler = BetaSampler(seed=42)
samples = [sampler.sample(a=20, b=10) for _ in range(1000000)]

plt.hist(samples, bins=100, density=True)
plt.show()
