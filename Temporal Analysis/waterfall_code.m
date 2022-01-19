clear;
clc;

%% Waterfall plot


Fs_p = 10000;
dir_p = '/home/ankit/ankit/Research/TARA/2021 Experiments/Results/Waterfall_pressure_folder/';

% Create figure
figure1 = figure;
% Create axes
axes1 = axes('Position',...
    [0.0598434970318403 0.248043050543785 0.376187263896385 0.709706172922202]);
hold(axes1,'on');


for counter1 = 11:-1:1 % Sequence depends on the way the waterfall diagram needs to be plotted
    counter = 12-counter1;
    ai1 = importdata([dir_p,'' sprintf('%d',counter1) '.txt']);
    
    if counter1 == 2 || 3  % For two datasets, only one pressure sensor data is present
        p = ai1(:,2)*1000/0.2134;
    else
        p = ai1(:,3)*1000/0.2134;
    end
     %p = ai1(:,2);
    
    N = size(p);
    t_p = 0:1/Fs_p:N/Fs_p;
    t_p = t_p(2:end)';
    
    pf = (p - mean(p));
    
    % If you are reading different files, put a for loop to calculate FFT below, Outside loop, plot3
    % FFT
    
    Fs = 10000;
    % Get the number of points
    N = size(pf,1);
    % Next power of 2 from length of y
    NFFT = 2^nextpow2(N);
    P = fft(pf, NFFT)/N;
    f = Fs/2*linspace(0, 1, NFFT/2+1);% Power
    f1(:, counter)=f;
    P1 = 2*abs(P(1:NFFT/2+1)).^2;
    dB = pow2db(P1);
    % Amplitude
    % P2 = Pmax*2*abs(P(1:NFFT/2+1));
    P2 = 2*abs(P(1:NFFT/2+1));
    B = smoothdata(P2,'gaussian',5);
    %hold on
    PSD(:,counter) = P1;
    %     X = ones(1,4097)*t(jj);
    %     plot3(f(1,1:end),X,P2(1:end,1));
    %     hold on;
    X = ones(length(f1),1)*counter;
    plot3(f1(2:3000,1),X(2:3000,1),B(2:3000,1),'Parent',axes1,'Color',[0 0 0]);
    xlim([1 700])
    hold on;
end
%h = waterfall(f(1:1200),1:9,PSD(1:1200,:)');
% plot3(158.1*ones(length(f1(2:3000,1)),1),linspace(0,10,length(f1(2:3000,1))),zeros(length(f1(2:3000,1))));
% plot3(477.9*ones(length(f1(2:3000,1)),1),linspace(0,10,length(f1(2:3000,1))),zeros(length(f1(2:3000,1))));

% Create zlabel
zlabel({'$|p^\prime(f)|$'},'Interpreter','latex');

% Create ylabel
ylabel({'$L_c$ (cm)'},'Interpreter','latex');

% Create xlabel
xlabel({'$f$ (Hz)'},'Interpreter','latex');

% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[1 700]);
view(axes1,[34.876362909792 33.0020745084191]);
box(axes1,'off');
hold(axes1,'off');
% Set the remaining axes properties
set(axes1,'FontSize',18,'TickLabelInterpreter','latex','TickLength',...
    [0.01 0.01],'YTick',[1 2 3 4 5 6 7 8 9 10 11],'YTickLabel',...
    {'215','200','190','170','160','140','130','120','110','100','Uncoupled'});
axes1.YTickLabelRotation = -17;
% hYLabel = get(gca,'YLabel');
% set(hYLabel,'rotation',52,'VerticalAlignment','middle')
figure1.WindowState = 'maximized';

%%

dir_q = '/home/ankit/ankit/Research/TARA/2021 Experiments/Results/Waterfall_PMT_folder/';

axes2 = axes('Parent',figure1,...
    'Position',[0.548240690771721 0.241798175930558 0.376726929303833 0.720302199412268]);
hold(axes2,'on');

for counter1 = 11:-1:1
    counter = 12-counter1;
    ai1 = importdata([dir_q,'' sprintf('%d',counter1) '.txt']);
    p = ai1(:,2);
    
    N = size(p);
    t_p = 0:1/Fs_p:N/Fs_p;
    t_p = t_p(2:end)';
    
    pf = (p - mean(p));
    
    % If you are reading different files, put a for loop to calculate FFT below, Outside loop, plot3
    % FFT
    
    Fs = 10000;
    % Get the number of points
    N = size(pf,1);
    % Next power of 2 from length of y
    NFFT = 2^nextpow2(N);
    P = fft(pf, NFFT)/N;
    f = Fs/2*linspace(0, 1, NFFT/2+1);% Power
    f1(:, counter)=f;
    P1 = 2*abs(P(1:NFFT/2+1)).^2;
    dB = pow2db(P1);
    % Amplitude
    % P2 = Pmax*2*abs(P(1:NFFT/2+1));
    P2 = 2*abs(P(1:NFFT/2+1));
    B = smoothdata(P2,'gaussian',5);
    %hold on
    PSD(:,counter) = P1;
    %     X = ones(1,4097)*t(jj);
    %     plot3(f(1,1:end),X,P2(1:end,1));
    %     hold on;
    X = ones(length(f1),1)*counter;
    plot3(f1(2:3000,1),X(2:3000,1),B(2:3000,1),'Parent',axes2,'Color',[0 0 0]);
    xlim([1 700])
    hold on;
end
%h = waterfall(f(1:1200),1:9,PSD(1:1200,:)');
% plot3(158.1*ones(length(f1(2:3000,1)),1),linspace(0,10,length(f1(2:3000,1))),zeros(length(f1(2:3000,1))));
% plot3(477.9*ones(length(f1(2:3000,1)),1),linspace(0,10,length(f1(2:3000,1))),zeros(length(f1(2:3000,1))));

% Create zlabel
zlabel({'$|\dot{q}^\prime(f)|$'},'Interpreter','latex');

% Create ylabel
ylabel({'$L_c$ (cm)'},'Interpreter','latex');

% Create xlabel
xlabel({'$f$ (Hz)'},'Interpreter','latex');

% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[1 700]);
view(axes2,[34.876362909792 33.0020745084191]);
box(axes2,'off');
hold(axes2,'off');
% Set the remaining axes properties
set(axes2,'FontSize',18,'TickLabelInterpreter','latex','TickLength',...
    [0.01 0.01],'YTick',[1 2 3 4 5 6 7 8 9 10 11],'YTickLabel',...
    {'215','200','190','170','160','140','130','120','110','100','Uncoupled'});
axes2.YTickLabelRotation = -17;
% hYLabel = get(gca,'YLabel');
% set(hYLabel,'rotation',52,'VerticalAlignment','middle')
figure1.WindowState = 'maximized';
set(gcf,'color','w');
 