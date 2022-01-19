%% Cross - wavelet transform working example

% Make sample data

clc
clear

rng default;
t = 0:0.001:2;
x = cos(2*pi*10*t).*(t>=0.5 & t<1.1)+ ...
cos(2*pi*50*t).*(t>= 0.2 & t< 1.4)+0.25*randn(size(t));
y = sin(2*pi*10*t).*(t>=0.6 & t<1.2)+...
sin(2*pi*50*t).*(t>= 0.4 & t<1.6)+ 0.35*randn(size(t));
subplot(2,1,1)
plot(t,x)
title('X')
subplot(2,1,2)
plot(t,y)
title('Y')
xlabel('Time (seconds)')

%% Plot cross-wavelet transform

[wcoh,~,period,coi] = wcoherence(x,y,seconds(0.001));
figure
period = seconds(period);
coi = seconds(coi);
h = pcolor(t,log2(period),wcoh);
h.EdgeColor = 'none';
ax = gca;
ytick=round(pow2(ax.YTick),3);
ax.YTickLabel=ytick;
ax.XLabel.String='Time';
ax.YLabel.String='Period';
ax.Title.String = 'Wavelet Coherence';
hcol = colorbar;
hcol.Label.String = 'Magnitude-Squared Coherence';
hold on;
plot(ax,t,log2(coi),'w--','linewidth',2)
%% Different arguments for plotting cross-wavelet transform

wcoherence(x,y,seconds(0.001)); % 0.001 is sampling interval
wcoherence(x,y,1000)            % 1000 is sampling frequency
wcoherence(x,y)
wcoherence(x,y,'NumScalesToSmooth',18)
