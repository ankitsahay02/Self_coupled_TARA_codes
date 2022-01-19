%% Plot wavelet coherence

clc
clear

%% Input time series

length_coupling       = 160;

Camera_dataset_Folder = '/media/ankit/My Book/Ankit Sahay/Lab System/Self_coupling_TARA_data/TARA/Experiments/Camera_Data_Sets/';
Length_name           = sprintf('%d cm',length_coupling);
Length_folder         = ([Camera_dataset_Folder Length_name '/']);
Pressure_folder       = 'Pressure';
pres_data_Folder      = ([Length_folder Pressure_folder '/']);

file_num   = 2;
file_name  = sprintf('%d.txt', file_num);
pres_data  = load([pres_data_Folder, file_name]);
p_near     = pres_data(:,3)*1000/0.2134;
pf_near    = p_near - mean(p_near);

fs = 10000;
t = 1/fs:1/fs:3;

%%
% figure('color',[1 1 1])
% % subplot(421)
% t=0.0001:1/fs:3;
% wt(pf_near)
% colormap(jet) 
% % % Convert period scale to frequency scale on y-axis
% % freq=[4096 2048 1024 512 256 128 64 32 16 8 4 2 1];
% % set(gca,'ytick',log2(1./freq),'yticklabel',freq)
% ylabel('Frequency (Hz)')
% % xlim([0 3])
% 
% %%
% COEFS = cwt(pf_near,1:64,'cgau4');
% 
% % Compute and plot the scalogram (image option)
% figure;
% SC = wscalogram('image',COEFS);

%% Plot wavelet coherence and time series
% Not able to link axes of the tqwo subplots

[cfs,f] = cwt(pf_near,1e4);

subplot(211)
ax1 = newplot;
surf(t,f,abs(cfs));
ax1.YScale = 'log';
view(0,90); shading interp;
axis tight;
colormap jet
% cb = colorbar(ax1);
% ylabel(cb,'magnitude','interpreter','latex');
% clim = [0 6000];
% set(gca,'clim',clim)
xlabel ('$t$ (s)', 'FontSize',18, 'Interpreter','Latex')
ylabel ('$f$ (Hz)', 'FontSize',18, 'Interpreter','Latex')
set(ax1,'xtick',([0.01 1 2 3]),'FontSize',18,'FontName','Arial');
set(ax1,'xticklabel',([0 1 2 3]));
set(ax1,'ytick',([10 100 1000]),'FontSize',18,'FontName','Arial');

subplot(212)
ax2 = plot(t, pf_near);
