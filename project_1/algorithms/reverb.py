minus_a = 0b0001100110011001

def mult(a,data):
    floatPart_a = int(a,2) & 16383

    sign_data = int(data,2) & 32768
    intPart_data = int(data,2) & 16384
    floatPart_data = int(data,2) & 16383

    low = (floatPart_a*floatPart_data)<<14
    
    mid = floatPart_a*intPart_data

    result = low+mid+sign_data

    print(result)

def reverb():
    # Open a file for reading
    iterador = 0
    with open('audio.txt', 'r') as file:
        # Use a for loop to iterate through the lines in the file
        for line in file:
            if iterador<2:
                print(int(line,2))
                data = bin(int(line,2))
                mult(bin(minus_a),data)
                iterador+=1
            else:
                break


reverb()