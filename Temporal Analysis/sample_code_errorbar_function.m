%% Sample code to play around with errorbar function 

X = [ -120 -110 -100 -90 -80 -70 -60 -50 -40 -30 -20 -10]';
Y = [0.9996 1.0000 0.9772 0.8978 0.6916 0.3253 0.0680 0.0091 0.0089 0.0088 0.0098 0.0119]';

data = Y + 0.1*randn(12, 8);                        % Create (12x8) Data Array

data_mean = mean(data,2);                           % Mean Across Columns
data_SEM = std(data,[],2)/sqrt(size(data,2));       % SEM Across Columns

figure(1)
errorbar(X, data_mean, data_SEM)
grid
axis([-130  0    ylim])

%%

x = 1:10;                                   % Create Data
y1 = rand(1,10);                            % Create Data
y2 = rand(1,10);                            % Create Data
y3 = rand(1,10);                            % Create Data

ym = [y1; y2; y3];
N = size(ym,1);
y = mean(ym);
SEM = std(ym) / sqrt(N);                    % Standard Error Of The Mean
CI95 = SEM * tinv(0.975, N-1);              % 95% Confidence Intervals

figure
errorbar(x, y, CI95)
grid