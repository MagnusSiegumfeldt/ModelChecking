from z3 import *


pi0 = Real("pi0")
pi1 = Real("pi1")
pi2 = Real("pi2")
pi3 = Real("pi3")


s = Solver()


s.add(
    pi0 == 0.4 * pi2,
    pi1 == 0.4 * pi0 + 0.5 * pi1,
    pi2 == 0.5 * pi1 + 0.2 * pi2 + pi3,
    pi3 == 0.6 * pi0 + 0.4 * pi2,
    pi0 + pi1 + pi2 + pi3 == 1
)

if s.check():
    print(s.model())
    
