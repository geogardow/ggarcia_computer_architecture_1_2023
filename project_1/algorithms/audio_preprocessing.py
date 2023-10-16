import wave
import numpy as np

def normalize_list(data):
    mu = np.mean(data, 0)
    sigma = np.std(data, 0)
    data = (data - mu ) / sigma

    max_value = data.max()
    min_value = data.min()
    normalized_data = -1 + 2 * (data - min_value) / (max_value - min_value)
    return normalized_data

def read_wav_file(path, sampling_rate, time):
    try:
        # Open the WAV file
        with wave.open(path, 'rb') as wav_file:
            # Check if the WAV file's sample width is 16 bits
            if wav_file.getsampwidth() != 2:
                print("The WAV file must have a sample width of 16 bits.")
                return None

            # Read audio samples from the WAV file
            audio_samples = np.frombuffer(wav_file.readframes(-1), dtype=np.int16)

            # Check if the WAV file is stereo (2 channels) and convert to mono if needed
            if wav_file.getnchannels() == 2:
                audio_samples = audio_samples[::2]

            audio_samples_normalized = normalize_list(audio_samples)[:wav_file.getframerate()*time]
            audio_resample = []
            for i in range(sampling_rate*time):
                audio_resample.append(audio_samples_normalized[int((wav_file.getframerate()/sampling_rate)*i)])
            return audio_resample
        
    except FileNotFoundError:
        print("File not found.")
        return None
    except Exception as e:
        print(f"An error occurred: {str(e)}")
        return None
    
def get_q114_samples(samples):
    samples_q114 = []
    for element in samples:
        if element < 0:
            binary = "1"
        else: 
            binary = "0"
        integer = int(abs(element))
        binary = binary + str(integer)
        decimal = abs(element) - int(abs(element))
        sum = 0
        for i in range(14):
            if sum + 2**(-(i+1)) <= decimal:
                sum += 2**(-(i+1))
                binary = binary + "1"
            else:
                binary = binary + "0"
        samples_q114.append(binary)

    return samples_q114


def makeTxt(file_name):
    file_path = "./project_1/algorithms/"+file_name+".wav"
    samples = read_wav_file(file_path, 32000, 5)
    if samples is not None:
        samples_q114 = get_q114_samples(samples)

    with open("./project_1/algorithms/"+file_name+".txt", 'w') as f:
        for i, value in enumerate(samples_q114):
            f.write(f"{value}\n")




makeTxt("audioSinReverb")
makeTxt("audioConReverb")