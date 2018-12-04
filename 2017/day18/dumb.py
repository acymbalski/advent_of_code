from collections import deque

registers_0={"p":0,"counter":0}
registers_1={"p":1,"counter":0}
queue_for_0=deque()
queue_for_1=deque()

# runs until termination or wait state. Returns False on termination
def run_program(registers,queue_in,queue_out):

    def value(r):
        if r.isalpha():
            return registers.get(r,0)
        else:
            return int(r)

    #first_rcv_done=False
    while (registers["counter"]>=0) and (registers["counter"]<len(commands)):
        parsed=commands[registers["counter"]].strip().split()
        if parsed[0]=="rcv":
            if len(queue_in)==0:
                return True
            registers[parsed[1]]=queue_in.popleft()
        if parsed[0]=="jgz":
            if value(parsed[1])>0:
                registers["counter"]+=value(parsed[2])
                continue
        if parsed[0]=="snd":
            queue_out.append(value(parsed[1]))
            registers["sent"]=value("sent")+1
        if parsed[0]=="set":
            registers[parsed[1]]=value(parsed[2])
        if parsed[0]=="add":
            registers[parsed[1]]=value(parsed[1])+value(parsed[2])
        if parsed[0]=="mul":
            registers[parsed[1]]=value(parsed[1])*value(parsed[2])
        if parsed[0]=="mod":
            registers[parsed[1]]=value(parsed[1])%value(parsed[2])
        registers["counter"]+=1
    return False

commands=open("input18.txt").readlines()
while True:
    if not run_program(registers_0,queue_for_0,queue_for_1): break
    if not run_program(registers_1,queue_for_1,queue_for_0): break
    if len(queue_for_0)==0 and len(queue_for_1)==0: break

print(registers_1["sent"])