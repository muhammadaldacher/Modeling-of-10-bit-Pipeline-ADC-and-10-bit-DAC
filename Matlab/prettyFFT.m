function [ENOB, SNDR, SFDR, SNR] = prettyFFT(wave,f_S,maxh,no_annotation,no_plot,baseline);
% Programmed by: Skyler Weaver, Ph.D.
% Date: December 7, 2010
% Version: 1.0
%
% This function plots a very pretty FFT plot and annotates all of the
% relevant data. This is intended to be used by Nyquist guys and expects
% coherently sampled data. Maybe in the future I will modify it to
% automatically detect windowed data for Delta-Sigma or allow two input
% tones. As for now, it is just for single sine-wave test, coherent data.
%
% The full function is:
% [ENOB, SNDR, SFDR, SNR] = prettyFFT(wave,f_S,maxh,no_annotation,no_plot)
%   'wave' can be any length but should be coherently sampled
%       (required)
%   'f_S' is the SAMPLING rate (i.e. f_Nyquist * 2) 
%       (optional, default = 1)
%   'maxh' is the highest harmonic plotted, 0 means all harmonics 
%       (optional, default = 12) NOTE: lowering this value will affect SNR 
%       since SNR is calculated as SNDR with harmonics removed. Setting 
%       maxh to 1 will effectivly set SNR = SNDR. (1 means only the 
%       fundamental is a 'harmonic')
%   'no_annotation' set to anything but 0 to turn off annotation 
%       (optional, default = 0)
%   'no_plot' set to anything but 0 to not create a plot 
%       (optional, default = 0)
%   'baseline' is the minimum value on the y-axis. When set to '0' the
%       y-axis is auto-scaled such that some of the noise floor is
%       displayed. It is useful to set this parameter when comparing two
%       FFT plots by keeping the scale the same.
%       (optional, default = 0)
%
% Here are some usage examples:
% 
%    prettyFFT(some_data)
% 
% In it's most default state, it will take some_data, grab the last 
% 2^integer data points, FFT it, plot it in a pretty way, normalize the 
% x-axis to Nyquist-rate, tag the first 12 harmonics (if above the noise 
% floor), annotate SFDR and SNDR/SNR (if there is room on the plot), draw a
% red line where the effective noise floor is, and returns ENOB. Use this 
% to just plot an FFT from command line and get some useful visual feedback.
% 
%    [ENOB,SNDR,SFDR,SNR]=prettyFFT(some_data)
% 
% does the same thing, but you now have your stats in variables too.
% 
%    prettyFFT(some_data,100e6,15)
% 
% does the same thing, but the x-axis is normalized to 100MHz sampling rate. 
% The default of up to 12 harmonics is overridden to 15. (set to 0, it will
% tag anything significantly above the noise floor, even harmonic 1032 if 
% it is high enough)
% 
%    prettyFFT(some_data,100e6,15,1)
% 
% same thing but annotation is turned off. For journals and stuff
% 
%    prettyFFT(some_data,100e6,15,1,1)
% 
% the extra '1' means it doesn't plot. This is in case you have a loop and 
% you need to get SNR, but you don't want it to keep plotting.
% 
% Feel free to edit, but keep my name at the top. 
%
% Enjoy!
%   -Skyler

if(nargin <= 0)
        disp('prettyFFT: What are you trying to do, exactly?')
        wave = rand(1,100);
        f_S = 1;
        maxh = 1;
        no_annotation = 0;
        no_plot = 0;
        baseline = 0;
end
if(nargin == 1)
        f_S = 1;
        maxh = 12;
        no_annotation = 0;
        no_plot = 0;
        baseline = 0;
end
if(nargin == 2)
        maxh = 12;
        no_annotation = 0;
        no_plot = 0;
        baseline = 0;
end
if(nargin == 3)
        no_annotation = 0;
        no_plot = 0;
        baseline = 0;
end
if(nargin == 4)
        no_plot = 0;
        baseline = 0;
end
if(nargin == 5)
        baseline = 0;
end
if(nargin > 6)
        disp('prettyFFT: Too many arguments, man.')
end

text_y_offset = 4; %height above bar for harmonic # txt (def. = 4)
plev = 9; %dB above noise floor to be considered a harmonic (def. = 9)

[a,b]=size(wave);
if(a>b)
    wave=wave(:,1)';
else
    wave=wave(1,:);
end
fft_ord = floor(log(length(wave))./log(2));

wave = wave(end-2^fft_ord+1:end);
wave=wave-mean(wave); % remove DC offset
f2 = abs(fft(wave)); % fft
f2 = f2(2:floor(length(f2)/2)); % remove bin 1 (DC)

[bin bin] = max(f2);
f2a=[f2(1:(bin-1)) f2((bin+1):end)];
f2a=[f2(1:(bin-1)) mean(f2) f2((bin+1):end)];
step = (bin);
pts = 2*(length(f2)+1);

SNDR = db((f2(bin).^2/(sum(f2.^2)-f2(bin).^2)))/2; % get SNDR (f_in / sum(the rest))
ENOB=(SNDR-1.76)/6.02; % ENOB from SNDR

scaledby = 1./max(f2);
dbf2=db(f2.*scaledby);
dbf2a=[dbf2(1:(bin-1)) dbf2((bin+1):end)];
dbf2a=[dbf2(1:(bin-1)) mean(dbf2) dbf2((bin+1):end)];
[bins bins] =max(dbf2a);
SFDR = -dbf2a(bins);

noise_top = mean(dbf2a)+plev;
noise_floor=mean(dbf2a);
noise_bottom = mean(dbf2a)-plev;
%noise_bottom = min(dbf2a);

% GET HARMONICS
harm = bin;
t=1;
nyqpts=(pts/2-1);
all_harms = harm:step:(harm*nyqpts);
all_harms = mod(all_harms,pts);
all_harms = (pts-all_harms).*(all_harms>nyqpts) ...
            + all_harms.*(all_harms<=nyqpts);
all_harms = all_harms.*(all_harms>0 & all_harms<pts/2) ...
            + (all_harms<=0) ...
            + (all_harms>=pts/2).*nyqpts;
if (maxh==0 || maxh>length(all_harms))
    maxh=length(all_harms);
end
for k=1:maxh
    if(dbf2(all_harms(k)) > noise_top)
        harm(t) = all_harms(k);
        hnum(t) = k;
        t=t+1;
    end
end

% GET REAL SNR
numbins=2.^(fft_ord-1)-1;
non_harm=1:numbins;
non_harm([harm]) = [];
SNR = db((f2(bin).^2/(sum(f2(non_harm).^2))))/2; % get SNR (f_in / sum(the rest))
%SNRpb = db(sqrt((f2(bin).^2/(sum(f2(non_harm).^2))))/numbins)-25 % get SNR (f_in / sum(the rest))
SNRpb = -SNR-3.*(fft_ord-1);

if(~no_plot)
% MAKE FFT
hold off
f=f_S/nyqpts/2:f_S/nyqpts/2:f_S/2;
h=bar(f,dbf2);
if(~baseline)
xx=max([min([SNRpb noise_bottom])-plev -250]);
else
    xx=baseline;
end

set(get(h,'BaseLine'),'BaseValue',xx);
set(h,'ShowBaseLine','off');
set(h,'BarWidth',1.0);
set(h,'LineStyle','none');
axis([f(1)/2 f(end)+f(1)/2 xx 0]);

if(~no_annotation)
% HARMONIC RED SQUARES
hold on
plot(f(harm),dbf2(harm),'rs')
text_y_offset = -xx/100*text_y_offset;
if (length(harm) > 2)
    for n=2:length(harm)
        if sum(harm(1:n-1)==harm(n))
            n=n-1; break, end

    end
    if (n<length(harm))
        disp('prettyFFT: Not prime-coherent sampling!')
    end
else
    n=length(harm);
end

% PRINT HARMONICS
%text_y_offset = -xx/100*text_y_offset;
for t=2:n
text(f(harm(t)),dbf2(harm(t))+text_y_offset,num2str(hnum(t)),'HorizontalAlignment','center');
end
hold off

hh=line([f(1)/2 f(end)+f(1)/2],[-SFDR -SFDR]);
set(hh,'LineStyle','--');
set(hh,'Color','k');
hh1=line([f(1)/2 f(end)+f(1)/2],[SNRpb SNRpb]);
set(hh1,'LineStyle','-');
set(hh1,'Color','r');

% where to put SFDR arrow
numbins=floor(pts/2);
dbin=round(numbins/32);
if(numbins>4)
if(bin>numbins/2+dbin*2)
    if(bins<(numbins/4-dbin))|(bins>(numbins/4+dbin))
        abin=round(numbins/4);
    elseif (bins>numbins/4)
        abin=round(numbins/4)-dbin;
    else
        abin=round(numbins/4)+dbin;
    end
else
    if(bins<(3*numbins/4-dbin))|(bins>(3*numbins/4+dbin))
        abin=round(3*numbins/4);
    elseif (bins>3*numbins/4)
        abin=round(3*numbins/4)-dbin;
    else
        abin=round(3*numbins/4)+dbin;
    end
end
else
    abin=12;
end

tempSFDR=SFDR;
if(SFDR > -(.13*xx))
    if(SFDR>250)
        SFDR=250;
    end
dx=f(end)/100;
dy=-xx/30;
x=f(abin);
tdx=max([dx (f(2)-f(1))]);
hh2=line([x-dx x x+dx x x x-dx x x+dx],[-dy 0 -dy 0 -SFDR dy-SFDR -SFDR dy-SFDR]);
set(hh2,'LineStyle','-');
set(hh2,'Color','k');
text(f(abin)+tdx,-SFDR/2,['SFDR =\newline' num2str(tempSFDR,4) 'dB'],'HorizontalAlignment','left');

if(SFDR > -(.25*xx))
infostr=...%['ENOB =\newline' num2str(ENOB,4) ' bits\newline\newline' ...
    ['SNDR =\newline' num2str(SNDR,4) 'dB\newline' ...
    '\newlineSNR =\newline' num2str(SNR,4) 'dB'];
else
infostr=...%['ENOB =\newline' num2str(ENOB,4) ' bits\newline\newline' ...
    ['SNDR = ' num2str(SNDR,4) 'dB\newline' ...
    'SNR =' num2str(SNR,4) 'dB'];
end
if(bin<numbins/2)
    text(f(bin)+tdx,-SFDR/2,infostr,'HorizontalAlignment','left');
else
    text(f(bin)-tdx,-SFDR/2,infostr,'HorizontalAlignment','right');
end
end
SFDR = tempSFDR;
end % end if(~no_annotation)
end % end if(~no_plot)