
factorA = 16807
factorB = 48271

valueA = 591
valueB = 393
divisor = 2147483647

# sample
#valueA = 65
#valueB = 8921

sm = 0
# part 1
if False:
    # sum is off by one somehow
    for i in range(40000000):
        valueA = valueA * factorA % divisor
        valueB = valueB * factorB % divisor

        # casually print so we know it's working and not frozen
        if i % 5000000 == 0:
            print("Calculated {}, current count is {}".format(i, sm))

        strA = str(bin(valueA))
        strB = str(bin(valueB))
        if strA[len(strA) - 16:] == strB[len(strB) - 16:]:
            sm += 1
            
# part 2
checked = 0

while checked < 5000000:

    valueA = valueA * factorA % divisor
    valueB = valueB * factorB % divisor
    
    while valueA % 4 != 0:
        valueA = valueA * factorA % divisor
    while valueB % 8 != 0:
        valueB = valueB * factorB % divisor
        
    # casually print so we know it's working and not frozen
    if checked % 500000 == 0:
        print("Checked: {}, found: {}".format(checked, sm))
    
    strA = str(bin(valueA))
    strB = str(bin(valueB))
    if strA[len(strA) - 16:] == strB[len(strB) - 16:]:
        sm += 1
    checked += 1

        
print("Sum of matches: {}".format(sm))
   