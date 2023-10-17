def getReverb(data, k, a):
    result = []
    for i in range(len(data)):
        if i > k-1:
            result.append((1-a)*data[i]+a*result[i-5])
        else:
            result.append((1-a)*data[i])
    return result

def getDeReverb(data, k, a):
    result = []
    for i in range(len(data)):
        if i > k-1:
            result.append((1/(1-a))*data[i]-(a/(1-a))*data[i-5])
        else:
            result.append((1/(1-a))*data[i])
    return result

example = samples[1129:1139]

print("\nLista Original")
print(example)

print("\n Lista Q1.14")
print(samples_q114[1129:1139])

print("\nLista Reverb")
print(getReverb(example, 5, 0.6))

print("\nLista DeReverb")
print(getDeReverb(example, 5, 0.6))




    

