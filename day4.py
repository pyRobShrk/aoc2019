def hasDupe(v):
    for d in '0123456789':
        if d+d in str(v):
            return True
    return False

def isAsc(v):
    V = str(v)
    for i in range(len(V)-1):
        if V[i+1] < V[i]:
            return False
    return True

passwords = []
for i in range(183564,657474):
    if hasDupe(i) and isAsc(i):
        passwords.append(i)

print (len(passwords))

def hasDupe2(v):
    for d in '0123456789':
        if d+d in str(v) and d*3 not in str(v):
            return True
    return False

for p in passwords[::-1]:
    if not hasDupe2(p):
        passwords.pop(passwords.index(p))

print (len(passwords))
