# Digital Filtering: Sensor Signal and Audio Hum Removal

**Student:** Fozle Arafat Chowdhury  
**Assignment:** Digital Filtering  
**Software:** MATLAB R2026b Update 2  
**Toolbox:** Signal Processing Toolbox 26.2

---

## 1. Introduction

The purpose of this assignment was to design and test digital filters using MATLAB. Two different signals were studied: a synthetic sensor signal and an audio recording with added 50 Hz hum.

In Part A, FIR and IIR low-pass filters were compared. In Part B, narrow and wide band-stop filters were used to reduce 50 Hz hum in audio.

The performance was evaluated using time-domain plots, frequency responses, frequency spectra and numerical measurements.

## 2. Part A – Sensor Signal Filtering

### 2.1 Signal generation

The sensor signal was sampled at 1000 Hz for two seconds. The wanted signal contained two frequency components:

- 5 Hz with amplitude 1.
- 12 Hz with amplitude 0.35.

Interference was added at 50 Hz and 137 Hz. Random noise was also added using MATLAB.

The random generator was initialized with `rng(7)` to make the experiment reproducible.

The clean signal was available, so the filtering results could be compared directly with the original signal.

### 2.2 Filter design

Two low-pass filters were designed with a 20 Hz cutoff frequency.

**FIR filter:**
- Filter type: Low-pass FIR.
- Filter order: 60.
- Number of coefficients: 61.

**IIR filter:**
- Filter type: Butterworth low-pass.
- Filter order: 4.
- Cutoff frequency: 20 Hz.

Both filters were applied using `filtfilt`. This method filters the signal forward and backward. It removes the normal phase delay for offline processing.

### 2.3 Sensor time-domain comparison

Figure 1 shows the clean signal, noisy signal and both filtered outputs over a 0.2-second interval.

The noisy signal contains unwanted variations caused by interference and random noise. Both filters produce smoother outputs.

The filtered signals follow the main shape of the clean signal. The unwanted high-frequency components are reduced.

**Figure 1. Sensor time-domain comparison**

[Insert sensor-time-comparison.png here]

### 2.4 Frequency response comparison

Figure 2 shows the frequency responses of the FIR and IIR filters.

Both filters have a 20 Hz cutoff frequency. Frequencies below the cutoff are mainly preserved, while higher frequencies are attenuated.

The FIR filter uses 61 coefficients. The IIR filter uses fewer coefficients because it is a recursive filter.

The FIR design generally has a more gradual transition for this order, while the Butterworth IIR provides a relatively efficient low-pass response with a much lower order.

**Figure 2. FIR and IIR frequency responses**

[Insert sensor-filter-responses.png here]

### 2.5 Frequency spectrum

Figure 3 shows the spectra of the noisy signal and both filtered outputs.

The wanted components are located at 5 Hz and 12 Hz. These frequencies are below the 20 Hz cutoff and should be preserved.

The unwanted components are located at 50 Hz and 137 Hz. Both filters reduce these components because they are above the cutoff frequency.

Some attenuation of the wanted 12 Hz component is also possible because it is relatively close to the cutoff frequency.

**Figure 3. Sensor frequency spectra**

[Insert sensor-spectra.png here]

### 2.6 RMSE results

The root mean square error (RMSE) was calculated by comparing each signal with the known clean signal.

The measured results were:

| Signal | RMSE |
|---|---:|
| Noisy input | 0.380117 |
| FIR output | 0.105590 |
| IIR output | 0.054774 |

The IIR filter produced the lowest RMSE.

The FIR filter also reduced the error compared with the noisy input.

The IIR filter reduced the RMSE by approximately 85.6% compared with the noisy input. This indicates that it gave the best numerical result in this experiment.

RMSE measures the overall difference between two signals. However, it does not explain which frequencies were removed or whether useful signal components were affected.

**Figure 4. RMSE comparison**

[Insert sensor-rmse.png here]

### 2.7 FIR and IIR comparison

The FIR filter uses 61 coefficients, while the IIR filter has order 4.

The FIR filter can provide linear phase in a single forward pass, but it requires more coefficients and calculations.

The IIR filter uses fewer coefficients and gives a good result in this experiment. However, IIR filters generally have nonlinear phase in a single pass.

The use of `filtfilt` removes the phase delay for this offline experiment, but it requires processing the complete signal and can produce edge effects.

I would choose FIR when linear phase and predictable delay are important. I would choose IIR when computational efficiency and low filter order are important.

## 3. Part B – Audio Hum Removal

### 3.1 Audio signal preparation

The built-in MATLAB Handel audio recording was used.

The recording had:
- Sampling frequency: 8192 Hz.
- Duration: 8.92 seconds.

A 50 Hz sinusoidal hum with amplitude 0.15 was added to the original audio.

The original recording was kept as a clean reference.

### 3.2 Notch filter design

Two Butterworth band-stop filters were designed.

**Narrow filter:**
- Stop band: 49–51 Hz.
- Filter order: 2.

**Wide filter:**
- Stop band: 45–55 Hz.
- Filter order: 2.

Both filters were applied using `filtfilt`.

The narrow filter targets the 50 Hz interference while protecting more nearby frequencies. The wide filter removes a larger frequency range.

### 3.3 Audio waveform comparison

Figure 5 shows the original audio, audio with added hum, and the outputs from both notch filters.

The filters reduce the added interference. The wide filter removes a larger frequency range around 50 Hz.

The comparison helps show how filtering changes the audio waveform.

**Figure 5. Audio waveform comparison**

[Insert audio-waveform.png here]

### 3.4 Audio frequency spectrum

Figure 6 compares the spectra of the clean audio, hum-added audio and filtered outputs.

The added 50 Hz hum creates an unwanted component around 50 Hz.

After filtering, this component is reduced.

The narrow filter affects a smaller frequency range. The wide filter removes a wider range around the interference frequency.

**Figure 6. Audio frequency spectrum**

[Insert audio-spectra.png here]

### 3.5 Notch filter response

Figure 7 shows the frequency responses of the two notch filters.

Both filters attenuate frequencies around 50 Hz.

The narrow filter has a smaller stop band. The wide filter has a larger stop band.

The wider filter can remove more interference if its frequency changes slightly. However, it can also remove useful low-frequency audio content.

**Figure 7. Notch filter frequency responses**

[Insert audio-notch-responses.png here]

### 3.6 Hum reduction measurements

The original added hum was compared with the filtered version of the known hum signal.

The measured results were:

| Measurement | Result |
|---|---:|
| Original hum RMS | 0.10606486 |
| Narrow filtered hum RMS | 0.00507470 |
| Wide filtered hum RMS | 0.00212782 |
| Narrow filter attenuation | -26.40 dB |
| Wide filter attenuation | -33.95 dB |

The wide filter reduced the added hum more than the narrow filter in this experiment.

The measurements were calculated using the RMS values of the original hum and the filtered hum.

The negative attenuation values indicate that the hum amplitude was reduced.

## 4. Discussion and Report Questions

### 4.1 Why is a 20 Hz low-pass reasonable for Part A?

The wanted sensor signal contains 5 Hz and 12 Hz components. Both frequencies are below 20 Hz.

The unwanted components are at 50 Hz and 137 Hz. Therefore, a 20 Hz low-pass filter is a reasonable choice.

This design assumes that useful sensor information is mainly below 20 Hz. If useful information exists above 20 Hz, the filter could remove it.

### 4.2 Which filter gives the better result?

The IIR filter gave the better result in this experiment.

The RMSE of the FIR output was 0.105590, while the IIR output had an RMSE of 0.054774.

The time-domain and frequency-domain plots also show that both filters reduce unwanted components.

The IIR filter achieved a lower RMSE using a much lower filter order. Therefore, I would choose the IIR filter for this particular offline sensor experiment.

### 4.3 How would the implementation change for live filtering?

For live filtering, I would not use `filtfilt` because it requires future samples and processes the signal in both directions.

Instead, I would use a causal filtering method such as `filter`.

I would divide the incoming sensor data into small blocks and process them continuously.

The filter order, processing delay and computational requirements would need to be considered.

### 4.4 Why is a narrow band-stop appropriate for steady 50 Hz hum?

A narrow band-stop filter is suitable because the interference is concentrated around 50 Hz.

It reduces the unwanted frequency while preserving more nearby audio frequencies.

If the interference frequency changes over time, I would consider a wider stop band or an adaptive notch filter that follows the changing frequency.

### 4.5 One limitation and one improvement

One limitation is that the experiment uses artificially generated interference and noise. Real sensor noise and electrical interference can be more complex.

The audio experiment also uses a controlled 50 Hz sinusoidal hum instead of real electrical interference.

One improvement would be to test the filters using real sensor measurements and real audio recordings. I would also investigate adaptive filtering and test the filters under different noise conditions.

## 5. Conclusion

This assignment demonstrated how digital filters can reduce unwanted signal components.

In Part A, both FIR and IIR low-pass filters reduced the sensor noise. The IIR filter produced the lowest RMSE of 0.054774.

In Part B, both narrow and wide notch filters reduced the added 50 Hz hum. The wide filter achieved greater hum reduction, but it also affected a wider frequency range.

The experiments showed that filter selection depends on the wanted signal, interference frequency, computational requirements and preservation of useful information.

## 6. Software and AI Use

The experiments were completed using MATLAB R2026b Update 2 and Signal Processing Toolbox version 26.2.

ChatGPT was used to help understand the assignment, organize MATLAB code, debug errors and prepare explanations. The MATLAB scripts were run by the student, and the figures and numerical results were checked in MATLAB.

---
