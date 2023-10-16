def convert_file(input_file, output_file):
    with open(input_file, 'r') as f_in, open(output_file, 'w') as f_out:
        lines = f_in.readlines()
        width = len(lines[0])
        depth = len(lines)

        f_out.write("WIDTH = {};\n".format(width))
        f_out.write("DEPTH = {};\n".format(depth))
        f_out.write("ADDRESS_RADIX = HEX;\n")
        f_out.write("DATA_RADIX = BIN;\n\n")
        f_out.write("CONTENT\nBEGIN\n")

        for i, line in enumerate(lines):
            hex_address = format(i, '02X')
            binary_data = line.strip()
            f_out.write("{} : {};\n".format(hex_address, binary_data))

        f_out.write("END;")


convert_file("./project_1/algorithms/audio.txt", "./project_1/algorithms/audio.mif")
