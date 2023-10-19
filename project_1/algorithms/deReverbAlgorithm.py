from audio_preprocessing import *

def getDeReverb(data, k, a):
    result = []
    for i in range(len(data)):
        if i > k-1:
            result.append((1/(1-a))*data[i]-(a/(1-a))*data[i-5])
        else:
            result.append((1/(1-a))*data[i])
    return result

file_path = "./project_1/algorithms/audioConReverb.wav"
deReverbSamples = getDeReverb(read_wav_file(file_path, 32000, 5),1600, 0.6)
print(deReverbSamples)