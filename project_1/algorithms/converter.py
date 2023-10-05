def get_q78_samples(element):
    if element < 0:
        binary = "1"
    else: 
        binary = "0"
    integer = int(abs(element))
    binary = binary + str(integer)
    decimal = abs(element) - int(abs(element))
    sum = 0
    for i in range(14):
        if sum + 2**(-(i+1)) < decimal:
            sum += 2**(-(i+1))
            binary = binary + "1"
        else:
            binary = binary + "0"

    return binary

print(get_q78_samples(0.6))