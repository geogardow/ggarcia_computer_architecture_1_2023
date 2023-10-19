import wave
import array


def create_audio(audio_data):

    sample_width = 2  # 8 bytes (64-bit)
    num_channels = 1  # Mono audio
    sample_rate = 32000 

    with wave.open("script0_miercoles_prueba2.wav", "w") as wf:
        wf.setnchannels(num_channels)
        wf.setsampwidth(sample_width)
        wf.setframerate(sample_rate)

        # Convert and write the audio data to the file
        audio_array = array.array('h', [int(x * 32767) for x in audio_data])  # Scale to 16-bit range
        #print(audio_array)
        wf.writeframes(audio_array.tobytes())
    print("WAV file created successfully.")

def file_to_list(file_name):
    value_list = []

    with open(file_name, 'r') as file:
        for line in file:
            line = line.strip()
            if line:
                value_list.append(line)

    return value_list

def q19_to_decimal(list_values):
    result = []
    for sample in list_values:
        result_audio = 0
        sign = -1 if sample[0] == '1' else 1
        whole = sample[1]
        decimal = sample[2:]
        if (whole == '1'):
            result.append(sign * 1)
        else:
            for i in range(9):
                result_audio += (2**(-(i+1)))*int(decimal[i])
            result.append(result_audio*sign)
    return result



file_name = 'script0_miercoles_prueba2.txt'

values = file_to_list(file_name)
q19_valules = q19_to_decimal(values)
create_audio(q19_valules)

#print('Values in the list [1129:1139]:', values[1129:1139])
#print('Total number of values:', len(q19_valules))
#print(q19_valules)
