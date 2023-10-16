def convert_file(input_file1, input_file2, output_file):
    with open("./project_1/algorithms/"+input_file1+".txt", 'r') as f_in1, open("./project_1/algorithms/"+input_file2+".txt", 'r') as f_in2, open("./project_1/algorithms/"+output_file+".mif", 'w') as f_out:
        lines1 = f_in1.readlines()
        lines2 = f_in2.readlines()

        width = 16
        depth = 321602

        f_out.write("WIDTH = {};\n".format(width))
        f_out.write("DEPTH = {};\n".format(depth))
        f_out.write("ADDRESS_RADIX = HEX;\n")
        f_out.write("DATA_RADIX = BIN;\n\n")
        f_out.write("CONTENT BEGIN\n")

        current_line_number = 0 # 1 - a
        f_out.write("{} : {};\n".format(format(current_line_number, '02X'), "0001100110011001"))
        current_line_number += 1 # a
        f_out.write("{} : {};\n".format(format(current_line_number, '02X'), "0010011001100110")) 
        current_line_number += 1

        for i in range(1600):
            hex_address = format(current_line_number, '02X')
            binary_data = "".zfill(16)
            f_out.write("{} : {};\n".format(hex_address, binary_data))
            current_line_number += 1

        for line in lines1:
            hex_address = format(current_line_number, '02X')
            binary_data = line.strip()
            f_out.write("{} : {};\n".format(hex_address, binary_data))
            current_line_number += 1

        for line in lines2:
            hex_address = format(current_line_number, '02X')
            binary_data = line.strip()
            f_out.write("{} : {};\n".format(hex_address, binary_data))
            current_line_number += 1

        f_out.write("END;")


convert_file("audioSinReverb", "audioConReverb", "audio")
