from pymata4 import pymata4
import time

FLAG_PIN = 4
DATA_PIN_0 = 2
DATA_PIN_1 = 4
DATA_PIN_2 = 5
DATA_PIN_3 = 6
DATA_PIN_4 = 7
DATA_PIN_5 = 8
DATA_PIN_6 = 9
DATA_PIN_7 = 10
FILE_LIMIT = 10

def generate_audio_file(audio_file):
    flag_last_state = 0
    is_processing = True
    while is_processing:
        flag_current_state  = board.digital_read(FLAG_PIN)[0]
        if (flag_current_state == 1 and flag_last_state == 0): 
                print("reading....")
                data = []
                '''
                for i in range (8):
                    data.append(board.digital_read(i+3)[0])   
                '''
                data.append(str(board.digital_read(2)[0]))
                with open(audio_file, "r+") as f:
                    audio_string = ''.join(data)
                    print(audio_string)
                    f.write(audio_string + '\n')
                    if(len(f.readlines()) == FILE_LIMIT):
                        is_processing = False
        flag_last_state  = flag_current_state
        time.sleep(0.1)

board = pymata4.Pymata4()
board.set_pin_mode_digital_input(DATA_PIN_0)
'''
board.set_digital_input(DATA_PIN_1)
board.set_digital_input(DATA_PIN_2)
board.set_digital_input(DATA_PIN_3)
board.set_digital_input(DATA_PIN_4)
board.set_digital_input(DATA_PIN_5)
board.set_digital_input(DATA_PIN_6)
board.set_digital_input(DATA_PIN_7)

'''
board.set_pin_mode_digital_input(FLAG_PIN)

#Generate first file
generate_audio_file("example.txt")


