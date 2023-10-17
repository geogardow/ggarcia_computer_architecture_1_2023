def remove_blank_lines_from_file(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    non_blank_lines = [line for line in lines if line.strip()]

    with open(file_path, 'w') as file:
        file.writelines(non_blank_lines)


script_file_path = 'reverb.txt'

remove_blank_lines_from_file(script_file_path)
