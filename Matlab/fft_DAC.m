clc; close all;
data = importdata('verilogA_DAC_output.csv');
%data = importdata('ideal_DAC_output.csv');
t = data(:,1);
x = data(:,2);
plot(t,x,'linewidth',2); grid on;
xlabel('time(s)'); ylabel('Voltage(V)')

FS = 1;
fs = 100e6;
fnyquist = fs/2;
N = length(x);
cycles = 31;
fx = (cycles/N)*fs;
Afs = 1;

% spectrum
% PrettyFFT Gives ENOB, SNDR, SFDR, SNR
figure
prettyFFT(x); grid on;

figure
s = abs(fft(x))
p = s(1:(N/2)+1);
p = 2*p/N/FS;
f = [0:(N/2)]
stem(f,p,'linewidth',2); grid on;

figure
f = [0:N-1]
s = 20*log10(2*s/N/FS)
plot(f,s,'linewidth',2); grid on;
xlabel('frequency[bin]'); ylabel('DFT magnitude [dBFS]')

figure
m = s(1:(N/2)+1);
f = [0:(N/2)]
plot(f,m,'linewidth',2); grid on;
xlabel('frequency[bin]'); ylabel('DFT magnitude [dBFS]')