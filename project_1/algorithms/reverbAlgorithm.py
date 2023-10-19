from audio_preprocessing import *
import array
import wave

def create_audio(audio_data, path):

    sample_width = 2  # 8 bytes (64-bit)
    num_channels = 1  # Mono audio
    sample_rate = 32000 

    with wave.open(path, "w") as wf:
        wf.setnchannels(num_channels)
        wf.setsampwidth(sample_width)
        wf.setframerate(sample_rate)

        # Convert and write the audio data to the file
        audio_array = array.array('h', [int(x * 32767) for x in audio_data])  # Scale to 16-bit range
        #print(audio_array)
        wf.writeframes(audio_array.tobytes())
    print("WAV file created successfully.")

def getReverb(data, k, a):
    result = []
    for i in range(len(data)):
        if i > k-1:
            result.append((1-a)*data[i]+a*result[i-5])
        else:
            result.append((1-a)*data[i])
    return result

file_path_to_open = "./project_1/algorithms/audioSinReverb.wav"
file_path_to_create = "./project_1/algorithms/addedReverb.wav"
reverbSamples = getReverb(read_wav_file(file_path_to_open, 32000, 4),1600, 0.6)
create_audio(reverbSamples, file_path_to_create)
