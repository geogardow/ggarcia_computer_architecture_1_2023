from pymata4 import pymata4
import time

FLAG_PIN = 2
DATA_PIN_0 = 3
DATA_PIN_1 = 4
DATA_PIN_2 = 5
DATA_PIN_3 = 6
DATA_PIN_4 = 7
DATA_PIN_5 = 8
DATA_PIN_6 = 9
DATA_PIN_7 = 10
DATA_PIN_8 = 11
DATA_PIN_9 = 12
DATA_PIN_10 = 13

def generate_audio_file():
    flag_last_state = 0
    is_processing = 0
    final_audio = []
    while is_processing < 128000:
        flag_current_state  = board.digital_read(FLAG_PIN)[0]
        if (flag_current_state == 1 and flag_last_state == 0): 
            print(is_processing)
            data = []
            for i in range (11):
                data.append(str(board.digital_read(i+3)[0]))
            final_audio.append(data)
            is_processing += 1
        flag_last_state  = flag_current_state  
    return final_audio

def main():
    print("Starting process...")
    filename = time.strftime("%Y_%m_%d__%I_%M_%S_%p") + ".txt"
    audio = generate_audio_file()   
    with open(filename, "a+" ) as f:
        for data in audio:
            audio_string = ''.join(data)
            print(audio_string)
            f.write(audio_string + '\n')
    print("Process done!")


board = pymata4.Pymata4()
board.set_pin_mode_digital_input(DATA_PIN_0)
board.set_pin_mode_digital_input(DATA_PIN_1)
board.set_pin_mode_digital_input(DATA_PIN_2)
board.set_pin_mode_digital_input(DATA_PIN_3)
board.set_pin_mode_digital_input(DATA_PIN_4)
board.set_pin_mode_digital_input(DATA_PIN_5)
board.set_pin_mode_digital_input(DATA_PIN_6)
board.set_pin_mode_digital_input(DATA_PIN_8)
board.set_pin_mode_digital_input(DATA_PIN_9)
board.set_pin_mode_digital_input(DATA_PIN_10)

board.set_pin_mode_digital_input(FLAG_PIN)

main()

