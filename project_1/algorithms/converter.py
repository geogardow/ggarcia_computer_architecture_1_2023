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

def get_decimal(decimal):
    binary = bin(decimal)[2:].zfill(16)
    numbers = list(map(int, [x for x in binary][2:]))
    result = 0
    print(numbers)
    for i, c in enumerate(numbers):
        result += (2**(-(i+1)))*c

    return result


print(get_decimal(33264))