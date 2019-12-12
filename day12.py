import numpy as np
from sympy import lcm
moons = np.array([[17, 5, 1],[-2, -8, 8],[7, -6, 14],[1, -10, 4]])
velocity = moons*0

def calcVel(positions):
    vel = []
    for moon in positions:
        a = moons*0
        a += moon-moons < 0
        a -= moon-moons > 0
        vel.append (np.sum(a,axis=0).tolist())
    return vel

# part 1
for _ in range(1000):
    velocity += calcVel(moons)
    moons += velocity
print (np.sum( np.sum(np.abs(moons),axis=1)*np.sum(np.abs(velocity),axis=1) ))

# part 2
moons = np.array([[17, 5, 1],[-2, -8, 8],[7, -6, 14],[1, -10, 4]])
velocity = moons*0
uniqueX, uniqueY, uniqueZ = set(), set(), set()
addX, addY, addZ = True, True, True
while addX or addY or addZ:
    mn = [m.tobytes() for m in moons.T]
    x, y, z = [v.tobytes()+m for v,m in zip(velocity.T,mn)]
    velocity += calcVel(moons)
    moons += velocity
    if addX and x not in uniqueX:
        uniqueX.add(x)
    else:
        addX = False
    if addY and y not in uniqueY:
        uniqueY.add(y)
    else:
        addY = False
    if addZ and z not in uniqueZ:
        uniqueZ.add(z)
    else:
        addZ = False
print (lcm([len(uniqueX),len(uniqueY),len(uniqueZ)]))
