ampControl = [3,8,1001,8,10,8,105,1,0,0,21,42,55,76,89,114,195,276,357,438,99999,3,9,1001,9,3,9,1002,9,3,9,1001,9,3,9,1002,9,2,9,4,9,99,3,9,102,2,9,9,101,5,9,9,4,9,99,3,9,102,3,9,9,101,5,9,9,1002,9,2,9,101,4,9,9,4,9,99,3,9,102,5,9,9,1001,9,3,9,4,9,99,3,9,1001,9,4,9,102,5,9,9,1001,9,5,9,1002,9,2,9,101,2,9,9,4,9,99,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,99]

class intCode:
    def __init__(self,program):
        self.code = program.copy()
        self.halt = False
        self.i = 0

    def run(self,inputs=[]):
        i = self.i
        while self.code[i] != 99:
            opcode = self.code[i]
            p1, p2 = self.code[i+1:i+3]

            if opcode > 1000:
                opcode -= 1000
            elif opcode not in (3,4):
                p2 = self.code[p2]

            if opcode > 100:
                opcode -= 100
            elif opcode != 3:
                p1 = self.code[p1]

            if opcode == 1:
                self.code[self.code[i+3]] = p1 + p2
            elif opcode == 2:
                self.code[self.code[i+3]] = p1 * p2
            elif opcode == 7:
                self.code[self.code[i+3]] = 1 if p1 < p2 else 0
            elif opcode == 8:
                self.code[self.code[i+3]] = 1 if p1 == p2 else 0
            elif opcode == 3:
                self.code[p1] = inputs.pop(0) if inputs else int(input('input required:'))
                i += 2
            elif opcode == 4:
                self.i = i+2
                return p1
            elif opcode == 5:
                i = p2 if p1 != 0 else i+3
            elif opcode == 6:
                i = p2 if p1 == 0 else i+3
            i += 4 if opcode in (1,2,7,8) else 0
        self.halt = True
        return self.code[0]

from itertools import permutations 
l = list(permutations(range(5)))

trials = 0
for trial in l:
    a = 0
    for phase in trial:
        amp = intCode(ampControl)
        a = amp.run([phase,a])
    trials = max(a,trials)
print (trials)

class ampChain:
    def __init__(self,program, numAmps=5):
        self.amps = [intCode(program.copy()) for _ in range(numAmps)]
        self.ampNum = 0
        self._temp = 0
    def run(self,phases):
        while True:
            amp = self.amps[self.ampNum]
            if phases:
                temp = amp.run([phases.pop(0), self._temp])
            else:
                temp = amp.run([self._temp])
            if amp.halt:
                return self._temp
            else:
                self._temp = temp
            self.ampNum += 1 if self.ampNum < len(self.amps)-1 else -len(self.amps)+1

l = list(permutations(range(5,10)))
trials = 0
for trial in l:
    a = ampChain(ampControl)
    trials = max(a.run(list(trial)), trials)
print (trials)
