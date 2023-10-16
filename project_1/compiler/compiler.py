# binary => string
def twoComplement(binary):

    aux = ""

    for i in binary:

        if(i == "0"):

            aux += "1"
        
        else:

            aux += "0"

    aux = int(aux, 2)

    aux += 1

    aux = bin(aux).replace("0b", "")

    return aux

# number => int
# instructionType => string
# opcode => string
# pointerLine => int
def signExtension(number, instructionType, opcode, pointerLine):

    # control instruction
    if(instructionType == "10"):

        immediate = number - pointerLine

    # memory or data instruction
    else:

        immediate = number

    binary = bin(abs(immediate)).replace("0b", "")

    binaryLength = len(binary)

    # control instruction
    if(instructionType == "10"):

        conditional = opcode[0]

        # conditional instruction
        if(conditional == "1"):

            extension = "0" * (20 - binaryLength)

            binary = extension + binary

            # PC - direction
            if(immediate < 0):

                binary =  twoComplement(binary)

            return binary
            
        # unconditional instruction
        else:

            extension = "0" * (28 - binaryLength)

            binary = extension + binary

            # PC - direction
            if(immediate < 0):

                binary =  twoComplement(binary)

            return binary            

    # memory instruction
    elif(instructionType == "00"):

        extension = "0" * (18 - binaryLength)

        binary = extension + binary

        # PC - direction
        if(immediate < 0):

            binary =  twoComplement(binary)

        return binary 

    # data instruction
    else:

        flagImmediate = opcode[0]

        # immediate
        if(flagImmediate == "1"):

            extension = "0" * (17 - binaryLength)

            binary = extension + binary

            # PC - direction
            if(immediate < 0):

                binary =  twoComplement(binary)

            return binary

# Insert stall after a label 
def stallInsertionAfterLabel(instructionElementsList):

    stall = ['suma', 'r14', 'r14', 'r14', "********************"]
    
    result = instructionElementsList.copy()

    i = 0
    # loop to iterate each instruction
    for j in result:       

        if(len(j) == 1):

            result.insert(i + 1, stall)

        i += 1

    print(result)
    return result

# case 0: control risks
def stallInsertionCase0(instructionElementsList, typeDictionary):

    stall = ['suma', 'r14', 'r14', 'r14', "********************"]

    result = instructionElementsList.copy()


    i = 0
    # loop to iterate each instruction
    for j in result:       

        if(len(j) > 1):

            currentInstruction = j[0]

            currentInstructionType = typeDictionary[currentInstruction]

            # control instruction
            if(currentInstructionType == "10"):

                result.insert(i + 1, stall)
                result.insert(i + 2, stall)
                result.insert(i + 3, stall)
                result.insert(i + 4, stall)           

        i += 1

    print("case 0:", result)
    return result

# case 1: dependencies between instructions with 0 instructions among them
def stallInsertionCase1(instructionElementsList, typeDictionary, opcodeDictionary):

    result = instructionElementsList.copy()

    # this insertion avoids index out of range error
    result.append("*")

    stall = ['suma', 'r14', 'r14', 'r14', "********************"]

    i = 0

    # loop to iterate each instruction
    for j in result:

        if(len(j) > 1):

            if(result[i + 1] == "*"):
                break

            currentInstruction = j[0]

            currentInstructionType = typeDictionary[currentInstruction]

            currentDestiny = j[1]

            if(currentDestiny != "r14"):
 
                # instruction
                if(len(result[i + 1]) > 1):

                    nextinstructionElementsList = result[i + 1]

                # label
                else:

                    nextinstructionElementsList = result[i + 2]

                nextInstruction = nextinstructionElementsList[0]

                nextInstructionType = typeDictionary[nextInstruction]           

                # memory instruction
                if(currentInstructionType == "00" and currentInstruction == "cargar"):

                    # control instruction
                    if(nextInstructionType == "10"):

                        nextOpcode = opcodeDictionary[nextInstruction]

                        nextBranch = nextOpcode[0]

                        # conditional instruction
                        if(nextBranch == "1"):

                            nextSource1 = nextinstructionElementsList[1]
                            nextSource2 = nextinstructionElementsList[2]

                            if(currentDestiny == nextSource1 or currentDestiny == nextSource2):

                                result.insert(i + 1, stall)
                                result.insert(i + 2, stall)
                                result.insert(i + 3, stall)

                    # memory instruction
                    elif(nextInstructionType == "00"):

                        nextOpcode = opcodeDictionary[nextInstruction]

                        nextIns = nextOpcode[0]
                        
                        # guardar instruction
                        if(nextIns == "01"):

                            nextSource = nextinstructionElementsList[1]
                            nextDestiny = nextinstructionElementsList[3]

                            if(currentDestiny == nextSource or currentDestiny == nextDestiny):

                                result.insert(i + 1, stall)
                                result.insert(i + 2, stall)
                                result.insert(i + 3, stall)
                        
                        # cargar instruction
                        else:

                            nextSource = nextinstructionElementsList[3]

                            if(currentDestiny == nextSource):

                                result.insert(i + 1, stall)
                                result.insert(i + 2, stall)
                                result.insert(i + 3, stall)

                    # data instruction
                    else:

                        nextSource2 = nextinstructionElementsList[2]
                        nextSource3 = nextinstructionElementsList[3]

                        if(currentDestiny == nextSource2 or currentDestiny == nextSource3):

                            result.insert(i + 1, stall)
                            result.insert(i + 2, stall)
                            result.insert(i + 3, stall)

                # data instruction
                else:
                    
                    # control instruction
                    if(nextInstructionType == "10"):

                        nextOpcode = opcodeDictionary[nextInstruction]

                        nextBranch = nextOpcode[0]

                        # conditional instruction
                        if(nextBranch == "1"):

                            nextSource1 = nextinstructionElementsList[1]
                            nextSource2 = nextinstructionElementsList[2]

                            if(currentDestiny == nextSource1 or currentDestiny == nextSource2):

                                result.insert(i + 1, stall)
                                result.insert(i + 2, stall)
                                result.insert(i + 3, stall)
                        
                    # memory instruction
                    elif(nextInstructionType == "00"):

                        nextOpcode = opcodeDictionary[nextInstruction]

                        nextIns = nextOpcode[0]
                        
                        # guardar instruction
                        if(nextIns == "01"):

                            nextSource = nextinstructionElementsList[1]
                            nextDestiny = nextinstructionElementsList[3]

                            if(currentDestiny == nextSource or currentDestiny == nextDestiny):

                                result.insert(i + 1, stall)
                                result.insert(i + 2, stall)
                                result.insert(i + 3, stall)
                        
                        # cargar instruction
                        else:

                            nextSource = nextinstructionElementsList[3]

                            if(currentDestiny == nextSource):

                                result.insert(i + 1, stall)
                                result.insert(i + 2, stall)
                                result.insert(i + 3, stall)

                    # data instruction
                    elif(nextInstructionType == "01"):

                        nextSource2 = nextinstructionElementsList[2]
                        nextSource3 = nextinstructionElementsList[3]

                        if(currentDestiny == nextSource2 or currentDestiny == nextSource3):

                            result.insert(i + 1, stall)
                            result.insert(i + 2, stall)
                            result.insert(i + 3, stall)

        i += 1

    print("Case 1 ",result)
    return result[:-1]

# case 2: dependencies between instructions with 1 instruction among them
# instructionElementsList => string list
# typeDictionary => string dictionary
# opcodeDictionary => string dictionary
def stallInsertionCase2(instructionElementsList, typeDictionary, opcodeDictionary):

    result = instructionElementsList.copy()

    # this insertion avoids index out of range error
    result.append("*")

    stall = ['suma', 'r14', 'r14', 'r14', "********************"]

    i = 0

    # loop to iterate each instruction
    for j in result:

        if(len(j) >= 1):

            if(result[i + 2] == "*"):
                break
            if(len(j) > 1):

                currentInstruction = j[0]

                currentInstructionType = typeDictionary[currentInstruction]

                currentDestiny = j[1]

                if(currentDestiny != "r14"):

                    # instruction
                    if(len(result[i + 2]) > 1):

                        nextinstructionElementsList = result[i + 2]

                    # label
                    else:

                        nextinstructionElementsList = result[i + 3]

                    nextInstruction = nextinstructionElementsList[0]

                    nextInstructionType = typeDictionary[nextInstruction]           
                        
                    # memory instruction
                    if(currentInstructionType == "00" and currentInstruction == "cargar"):            
                        
                        # control instruction
                        if(nextInstructionType == "10"):

                            nextOpcode = opcodeDictionary[nextInstruction]

                            nextBranch = nextOpcode[0]

                            # conditional instruction
                            if(nextBranch == "1"):

                                nextSource1 = nextinstructionElementsList[1]
                                nextSource2 = nextinstructionElementsList[2]

                                if(currentDestiny == nextSource1 or currentDestiny == nextSource2):

                                    result.insert(i + 1, stall)
                                    result.insert(i + 2, stall)

                        # memory instruction
                        elif(nextInstructionType == "00"):

                            nextOpcode = opcodeDictionary[nextInstruction]

                            nextIns = nextOpcode[0]
                            
                            # guardar instruction
                            if(nextIns == "01"):

                                nextSource = nextinstructionElementsList[1]
                                nextDestiny = nextinstructionElementsList[3]

                                if(currentDestiny == nextSource or currentDestiny == nextDestiny):

                                    result.insert(i + 1, stall)
                                    result.insert(i + 2, stall)
                            
                            # cargar instruction
                            else:

                                nextSource = nextinstructionElementsList[3]

                                if(currentDestiny == nextSource):

                                    result.insert(i + 1, stall)
                                    result.insert(i + 2, stall)
                                            
                        # data instruction
                        elif(nextInstructionType == "01"):

                            nextSource2 = nextinstructionElementsList[2]
                            nextSource3 = nextinstructionElementsList[3]

                            if(currentDestiny == nextSource2 or currentDestiny == nextSource3):

                                result.insert(i + 1, stall)
                                result.insert(i + 2, stall)

                    # data instruction
                    elif(nextInstructionType == "01"):
                        
                        # control instruction
                        if(nextInstructionType == "10"):

                            nextOpcode = opcodeDictionary[nextInstruction]

                            nextBranch = nextOpcode[0]

                            # conditional instruction
                            if(nextBranch == "1"):

                                nextSource1 = nextinstructionElementsList[1]
                                nextSource2 = nextinstructionElementsList[2]

                                if(currentDestiny == nextSource1 or currentDestiny == nextSource2):

                                    result.insert(i + 1, stall)
                                    result.insert(i + 2, stall)

                        # memory instruction
                        elif(nextInstructionType == "00"):

                            nextOpcode = opcodeDictionary[nextInstruction]

                            nextIns = nextOpcode[0]
                            
                            # guardar instruction
                            if(nextIns == "01"):

                                nextSource = nextinstructionElementsList[1]
                                nextDestiny = nextinstructionElementsList[3]

                                if(currentDestiny == nextSource or currentDestiny == nextDestiny):

                                    result.insert(i + 1, stall)
                                    result.insert(i + 2, stall)
                            
                            # cargar instruction
                            else:

                                nextSource = nextinstructionElementsList[3]

                                if(currentDestiny == nextSource):

                                    result.insert(i + 1, stall)
                                    result.insert(i + 2, stall)

                        # data instruction
                        elif(nextInstructionType == "01"):

                            nextSource2 = nextinstructionElementsList[2]
                            nextSource3 = nextinstructionElementsList[3]

                            if(currentDestiny == nextSource2 or currentDestiny == nextSource3):

                                result.insert(i + 1, stall)
                                result.insert(i + 2, stall)

            i += 1

    print("Case 2 ",result[:-1])
    return result[:-1]

# case 3: dependencies between instructions with 2 instructions among them
# instructionElementsList => string list
# typeDictionary => string dictionary
# opcodeDictionary => string dictionary
def stallInsertionCase3(instructionElementsList, typeDictionary, opcodeDictionary):

    result = instructionElementsList.copy()

    # this insertion avoids index out of range error
    result.append("*")

    stall = ['suma', 'r14', 'r14', 'r14', "********************"]


    i = 0
    # loop to iterate each instruction
    for j in result:

        if(len(j) > 1):

            if(result[i + 3] == "*"):
                break

            currentInstruction = j[0]

            currentInstructionType = typeDictionary[currentInstruction]

            currentDestiny = j[1]

            if(currentDestiny != "r14"):

                # instruction
                if(len(result[i + 3]) > 1):

                    nextinstructionElementsList = result[i + 3]

                # label
                else:

                    nextinstructionElementsList = result[i + 4]

                nextInstruction = nextinstructionElementsList[0]

                nextInstructionType = typeDictionary[nextInstruction]           
                    
                # memory instruction
                if(currentInstructionType == "00" and currentInstruction == "cargar"):            
                    
                    # control instruction
                    if(nextInstructionType == "10"):

                        nextOpcode = opcodeDictionary[nextInstruction]

                        nextBranch = nextOpcode[0]

                        # conditional instruction
                        if(nextBranch == "1"):

                            nextSource1 = nextinstructionElementsList[1]
                            nextSource2 = nextinstructionElementsList[2]

                            if(currentDestiny == nextSource1 or currentDestiny == nextSource2):

                                result.insert(i + 1, stall)
                    
                    # memory instruction
                    elif(nextInstructionType == "00"):

                        nextOpcode = opcodeDictionary[nextInstruction]

                        nextIns = nextOpcode[0]
                        
                        # guardar instruction
                        if(nextIns == "01"):

                            nextSource = nextinstructionElementsList[1]
                            nextDestiny = nextinstructionElementsList[3]

                            if(currentDestiny == nextSource or currentDestiny == nextDestiny):

                                result.insert(i + 1, stall)
                        
                        # cargar instruction
                        else:

                            nextSource = nextinstructionElementsList[3]

                            if(currentDestiny == nextSource):

                                result.insert(i + 1, stall)

                    # data instruction
                    else:

                        nextSource2 = nextinstructionElementsList[2]
                        nextSource3 = nextinstructionElementsList[3]

                        if(currentDestiny == nextSource2 or currentDestiny == nextSource3):

                            result.insert(i + 1, stall)

                # data instruction
                else:
                    
                    # control instruction
                    if(nextInstructionType == "10"):

                        nextOpcode = opcodeDictionary[nextInstruction]

                        nextBranch = nextOpcode[0]

                        # conditional instruction
                        if(nextBranch == "1"):

                            nextSource1 = nextinstructionElementsList[1]
                            nextSource2 = nextinstructionElementsList[2]

                            if(currentDestiny == nextSource1 or currentDestiny == nextSource2):

                                result.insert(i + 1, stall)

                    # memory instruction
                    elif(nextInstructionType == "00"):

                        nextOpcode = opcodeDictionary[nextInstruction]

                        nextIns = nextOpcode[0]
                        
                        # guardar instruction
                        if(nextIns == "01"):

                            nextSource = nextinstructionElementsList[1]
                            nextDestiny = nextinstructionElementsList[3]

                            if(currentDestiny == nextSource or currentDestiny == nextDestiny):

                                result.insert(i + 1, stall)
                        
                        # cargar instruction
                        else:

                            nextSource = nextinstructionElementsList[3]

                            if(currentDestiny == nextSource):

                                result.insert(i + 1, stall)

                    # data instruction
                    else:

                        nextSource2 = nextinstructionElementsList[2]
                        nextSource3 = nextinstructionElementsList[3]

                        if(currentDestiny == nextSource2 or currentDestiny == nextSource3):

                            result.insert(i + 1, stall)

            i += 1

    print("case 3 ", result[:-1])
    return result[:-1]

# instructionElementsList => string list
# typeDictionary => string dictionary
# opcodeDictionary => string dictionary
def riskControlUnit(instructionElementsList, typeDictionary, opcodeDictionary):

    case0 = stallInsertionCase0(instructionElementsList, typeDictionary)

    case1 = stallInsertionCase1(case0, typeDictionary, opcodeDictionary)

    case2 = stallInsertionCase2(case1, typeDictionary, opcodeDictionary)

    case3 = stallInsertionCase3(case2, typeDictionary, opcodeDictionary)    

    caseAfterLabel = stallInsertionAfterLabel(case3)

    return caseAfterLabel

def getinstructionElementsList(filename):

    # open code.txt file for reading
    codeFile = open(filename, 'r')
    codeLines = codeFile.readlines()

    # variable to store all the instruction elements
    instructionElementsList = []

    # loop to iterate the code file line by line
    for line in codeLines:
        
        # variable to know if the current instruction is a memory one (type 01)
        memoryFlag = 0   

        elements = []
        temp = ""

        # slicing the current line to get the last element
        aux = line[-2]

        # current line contains a label
        if(aux == ":"):
            
            instructionElementsList.append([line[:-2]])

        # current line contains an instruction
        else:

            #pointerLine += 1

            # loop to iterate the current line char by char
            for char in line:
                if(char == " " or char == "," or char == "(" or char == ")" or char == '\t'):

                    # check if the current instruction is a memory one to change the flag
                    if(char == "("):
                        memoryFlag = 1

                    if(temp != ""):
                        elements.append(temp)

                    temp = ""            

                else:

                    temp += char

            # slice \n from the last element
            temp = temp[:-1]

            elements.append(temp)    
            
            # remove last element if the current instruction is a memory one
            if(memoryFlag == 1):
                elements.pop()

            instructionElementsList.append(elements) 
            
    return instructionElementsList

# instructionElementsList => string list list
def getLabelDictionary(instructionElementsList):
    
    labelDictionary = {}

    # variable to know the number of the current line
    pointerLine = 0

    for instruction in instructionElementsList:

        pointerLine += 1

        instructionLength = len(instruction)

        # label
        if(instructionLength == 1):

            labelDictionary[instruction[0]] = pointerLine

            instructionElementsList.remove(instruction)

    return labelDictionary, instructionElementsList

# instructionElementsList => string list list
def binaryInstructions(filename, instructionElementsList, typeDictionary, opcodeDictionary, registerDictionary, labelDictionary):

    # open binaryCode.txt file for writing
    binaryCodeFile = open(filename, 'w')

    # variable to know the number of the current line
    pointerLine = 0

    for elements in instructionElementsList:

        pointerLine += 1

        print("elements = ", elements)        
            
        instructionType = typeDictionary[elements[0]]
        opcode = opcodeDictionary[elements[0]]

        fillingMemory = "000"
        fillingData = "0000000000000"

        # control instruction
        if(instructionType == "10"):

            conditional = opcode[0]

            # conditional instruction
            if(conditional == "1"):

                register1 = registerDictionary[elements[1]]
                register2 = registerDictionary[elements[2]]

                direction = elements[3]
                direction = labelDictionary[direction]
                direction = signExtension(direction, instructionType, opcode, pointerLine)

                instruction = instructionType + opcode + register1 + register2 + direction
                print(instructionType + " " + opcode + " " + register1 + " " + register2 + " " + direction)

                with open("data.txt", "a+") as file:
                    file.write( " ".join(elements)+ "  ")
                    file.write(instructionType + " " + opcode + " " + register1 + " " + register2 + " " + direction + '\n')


            # unconditional instruction
            else:
                direction = elements[1]
                direction = labelDictionary[direction]
                direction = signExtension(direction, instructionType, opcode, pointerLine)

                instruction = instructionType + opcode + direction
                print(instructionType + " " + opcode + " " + direction)

                with open("data.txt", "a+") as file:
                    file.write(" ".join(elements)+ "  ")
                    file.write(instructionType + " " + opcode + " " + direction + '\n')

        # memory instruction
        elif(instructionType == "00"):

            register1 = registerDictionary[elements[1]]

            immediate = int(elements[2])
            immediate = signExtension(immediate, instructionType, opcode, pointerLine)

            register2 = registerDictionary[elements[3]]       

            instruction = instructionType + opcode + fillingMemory + register1 + register2 + immediate
            print(instructionType + " " + opcode + " " + fillingMemory + " " + register1 + " " + register2 + " " + immediate)
            
            with open("data.txt", "a+") as file:
                file.write(" ".join(elements)+ "  ")
                file.write(instructionType + " " + opcode + " " + fillingMemory + " " + register1 + " " + register2 + " " + immediate+ '\n')

        # data instruction
        else:

            flagImmediate = opcode[0]

            # immediate
            if(flagImmediate == "1"):

                register1 = registerDictionary[elements[1]]
                register2 = registerDictionary[elements[2]]
                
                immediate = int(elements[3])
                immediate = signExtension(immediate, instructionType, opcode, pointerLine)

                instruction = instructionType + opcode + register1 + register2 + immediate

                print(instructionType + " " + opcode + " " + register1 + " " + register2 + " " + immediate)

                with open("data.txt", "a+") as file:
                    file.write(" ".join(elements) + "  ")
                    file.write(instructionType + " " + opcode + " " + register1 + " " + register2 + " " + immediate + '\n')

            # no immediate
            else:

                register1 = registerDictionary[elements[1]]
                register2 = registerDictionary[elements[2]]
                register3 = registerDictionary[elements[3]]

                instruction = instructionType + opcode + register1 + register2 + register3 + fillingData

                print(instructionType + " " + opcode + " " + register1 + " " + register2 + " " + register3 + " " + fillingData)

                with open("data.txt", "a+") as file:
                    file.write( " ".join(elements)+ "  ")
                    file.write(instructionType + " " + opcode + " " + register1 + " " + register2 + " " + register3 + " " + fillingData+ '\n')
        print(" ")

        binaryCodeFile.write(instruction + "\n")

    return instructionElementsList


def convert_to_mif(input_file, output_file):
    # Read the binary data from the text file
    with open(input_file, 'r') as file:
        binary_data = file.readlines()

    # Remove leading/trailing whitespace and convert to MIF format
    mif_content = f"""WIDTH = {len(binary_data[0].strip())};\n"""
    mif_content += f"""DEPTH = {len(binary_data)};\n"""
    mif_content += "ADDRESS_RADIX = HEX;\n"
    mif_content += "DATA_RADIX = BIN;\n\n"
    mif_content += "CONTENT\nBEGIN\n"

    for address, data in enumerate(binary_data):
        mif_content += f"{address:02X} : {data.strip()};\n"

    mif_content += "END;\n"

    # Write the formatted data to the output .mif file
    with open(output_file, 'w') as file:
        file.write(mif_content)




# instr type dictionary 
typeDictionary = {
    "cargar": "00",
    "guardar": "01",

    "suma": "01",
    "resta": "01",
    "mult": "01",
    "div": "01",
    "sumita": "01",
    "restita": "01",
    "multi": "01",
    "divi": "01",
    "cad": "01",
    "cld": "01",
    "cli": "01",

    "igual": "10",
    "geq": "10",
    "leq": "10",
    "brinco": "10",
}

# opcode dictionary definition
opcodeDictionary = {
    "cargar": "00",
    "guardar": "01",

    "suma": "00000",
    "resta": "00001",
    "mult": "00010",
    "div": "00011",
    "sumita": "10100",
    "restita": "10101",
    "multi": "10110",
    "divi": "10111",
    "cad": "11000",
    "cld": "11001",
    "cli": "11010",

    "igual": "10",
    "geq": "11",
    "leq": "01",
    "brinco": "00",
}

# register dictionary definition
registerDictionary = {
    "r0": "0000",
    "r1": "0001",
    "r2": "0010",
    "r3": "0011",
    "r4": "0100",
    "r5": "0101",
    "r6": "0110",
    "r7": "0111",
    "r8": "1000",
    "r9": "1001",
    "r10": "1010",
    "r11": "1011",
    "r12": "1100",
    "r13": "1101",
    "r14": "1110",
    "r15": "1111"
}

instructionElementsList = getinstructionElementsList('test.txt')

instructionElementsList = riskControlUnit(instructionElementsList, typeDictionary, opcodeDictionary)

labelDictionary, instructionElementsList = getLabelDictionary(instructionElementsList)

binaryInstructions('binaryCode.txt', instructionElementsList, typeDictionary, opcodeDictionary, registerDictionary, labelDictionary)

input_file = 'BinaryCode.txt'
output_file = 'output.mif'

convert_to_mif(input_file, output_file)
