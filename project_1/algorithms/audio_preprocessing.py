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

def read_wav_file(path, sampling_frequency):
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

            audio_samples_normalized = normalize_list(audio_samples)[:240000]
            audio_resample = []
            for i in range(160000):
                audio_resample.append(audio_samples_normalized[int(1.5*i)])
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


# Example usage:
file_path = "./project_1/algorithms/input_audio.wav"
desired_sampling_frequency = 32000  # Change this to your desired sampling frequency
samples = read_wav_file(file_path, desired_sampling_frequency)
if samples is not None:
    samples_q114 = get_q114_samples(samples)

with open("./project_1/algorithms/audio.txt", 'w') as f:
    for i, value in enumerate(samples_q114):
        f.write(f"{value}\n")

def getReverb(data, k, a):
    result = []
    for i in range(len(data)):
        if i > k-1:
            result.append((1-a)*data[i]+a*result[i-5])
        else:
            result.append((1-a)*data[i])
    return result

def getDeReverb(data, k, a):
    result = []
    for i in range(len(data)):
        if i > k-1:
            result.append((1/(1-a))*data[i]-(a/(1-a))*data[i-5])
        else:
            result.append((1/(1-a))*data[i])
    return result

example = samples[1129:1139]

print("\nLista Original")
print(example)

print("\n Lista Q1.14")
print(samples_q114[1129:1139])

print("\nLista Reverb")
print(getReverb(example, 5, 0.6))

print("\nLista DeReverb")
print(getDeReverb(example, 5, 0.6))




    

