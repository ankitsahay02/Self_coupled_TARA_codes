%% Code for plotting pressure data time series and chemi image data movies
% Code for Linux machines

% Movie isn't working properly in Ubuntu (was working great in Windows)
% Movie can be viewed in Matlab figure, but cannot save it to an .avi file
% (or any other format)
% I need to fix this!!!

clc
clear

%%
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot, 'defaultAxesTickDir', 'out');
set(groot,  'defaultAxesTickDirMode', 'manual');

delay_time_uncoupled = [413.91 ;324.02 ;324.02 ;82.32 ;65.46 ;64.29 ;...
    69.62 ;32.39 ;124.32 ;413.25 ;98.73 ;389.34];
delay_time_coupled = [498.3; 320.23; 320.23; 71.18; 320.23; 320.23; 320.23;...
    320.23; 320.23; 320.23; 320.23; 320.23];

mycolormap  = customcolormap(linspace(0,1,5), {'#a60026','#f66e44','#ffffbd','#73add2','#313691'});
mycolormap2 = customcolormap(linspace(0,1,9), {'#b35806','#e08214','#fdb863','#fee0b6','#f7f7f7','#d8daeb','#b2abd2','#8073ac','#542788'});

%% Coupled data preparation

length_coupling      = 160;

length_coupling_mm = length_coupling*10;
if length_coupling ~= 215
    length_data_counter   = (length_coupling-90)/10;
else
    length_data_counter = 12;
end

Camera_dataset_Folder    = '/media/ankit/My Book/Ankit Sahay/Lab System/Self_coupling_TARA_data/TARA/Experiments/Camera_Data_Sets/';
Length_name              = sprintf('%d cm',length_coupling);
Length_folder            = ([Camera_dataset_Folder Length_name '/']);
Pressure_folder          = 'Pressure';
pres_data_Folder         = ([Length_folder Pressure_folder '/']);

Image_folder             = '/media/ankit/My Book/Ankit Sahay/Lab System/Self_coupling_TARA_data/TARA/Tiff images/'; % Folder containing tiff images
Image_data_folder        = ([Image_folder Length_name '/']);
Coupling_status          = 'During coupling';
Image_coup_data_folder   = ([Image_data_folder Coupling_status '/Test1/1_Cam_8726_Cine2/']);
Chemiimgname             = 'Img';

file_num_coupled         = 2;
file_name_coupled        = sprintf('%d.txt', file_num_coupled);
pres_data_coupled        = load([pres_data_Folder, file_name_coupled]);
p_near_coupled           = pres_data_coupled(:,3)*1000/0.2134;
pf_near_coupled          = p_near_coupled - mean(p_near_coupled);
pnear_frms_coupled       = rms(pf_near_coupled);
 
total_time               = 3;
fs_pres                  = 10000;
fs_img                   = 2000;
sktime                   = 1/fs_pres;
sktime_micros            = sktime*1000000;
fs_pres_to_fs_img_ratio  = fs_pres/fs_img;
time_actual              = sktime:sktime:total_time;

cam_delay_coupled        = delay_time_coupled(length_data_counter);
cam_delay_s_coupled      = cam_delay_coupled * 1e-6;
skip_data_points_coupled = ceil(cam_delay_s_coupled * fs_pres);

time_skip_coupled        = time_actual(skip_data_points_coupled:fs_pres_to_fs_img_ratio:end);
pf_near_raw_coupled      = pf_near_coupled(skip_data_points_coupled:end);
pf_near_skip_coupled     = pf_near_raw_coupled(1:fs_pres_to_fs_img_ratio:end);

%% Uncoupled data preparation

Uncoupling_status          = 'Before coupling';
Image_uncoup_data_folder   = ([Image_data_folder Uncoupling_status '/Test1/1_Cam_8726_Cine1/']);

file_num_uncoupled         = 1;
file_name_uncoupled        = sprintf('%d.txt', file_num_uncoupled);
pres_data_uncoupled        = load([pres_data_Folder, file_name_uncoupled]);
p_near_uncoupled           = pres_data_uncoupled(:,3)*1000/0.2134;
pf_near_uncoupled          = p_near_uncoupled - mean(p_near_uncoupled);
pnear_frms_uncoupled       = rms(pf_near_uncoupled);

cam_delay_uncoupled        = delay_time_uncoupled(length_data_counter);
cam_delay_s_uncoupled      = cam_delay_uncoupled * 1e-6;
skip_data_points_uncoupled = ceil(cam_delay_s_uncoupled * fs_pres);

time_skip_uncoupled        = time_actual(skip_data_points_uncoupled:fs_pres_to_fs_img_ratio:end);
pf_near_raw_uncoupled      = pf_near_uncoupled(skip_data_points_uncoupled:end);
pf_near_skip_uncoupled     = pf_near_raw_uncoupled(1:fs_pres_to_fs_img_ratio:end);

%% Dimnensions of image

row             = 574;
col             = 764;
tot_matrix_size = row*col;

%% Movie time!!

strtpt          = 13;
no_of_image_pts = 20;

figure1 = figure('InvertHardcopy','off','WindowState','maximized',...
    'Color',[1 1 1]);
clear movievector

for k=strtpt:strtpt + no_of_image_pts
    clf;
    FileStr      = sprintf('%06d.tif', k);
    dataname_coupled     = strcat(Image_coup_data_folder, Chemiimgname, FileStr);
    Chemi_file_coupled   = importdata(dataname_coupled);
    Chemi_double_coupled = double(Chemi_file_coupled);
    
    % Mask bluff body region
    Chemi_double_coupled(319:421,1:185)   = 0;
    Chemi_double_coupled(216:529,185:262) = 0;
    Chemi_double_coupled(:,765:end)       = [];
    
    % Crop the outer boundaries
    Chemi_double_coupled(1:73,:)       = [];
    Chemi_double_coupled(end-72:end,:) = [];
    
    dataname_uncoupled     = strcat(Image_uncoup_data_folder, Chemiimgname, FileStr);
    Chemi_file_uncoupled   = importdata(dataname_uncoupled);
    Chemi_double_uncoupled = double(Chemi_file_uncoupled);
    
    % Mask bluff body region
    Chemi_double_uncoupled(319:421,1:185)   = 0;
    Chemi_double_uncoupled(216:529,185:262) = 0;
    Chemi_double_uncoupled(:,765:end)       = [];
    
    % Crop the outer boundaries
    Chemi_double_uncoupled(1:73,:)       = [];
    Chemi_double_uncoupled(end-72:end,:) = [];
    
    subplot(2,2,1,'Parent',figure1)
    plot(time_skip_uncoupled(strtpt:strtpt + no_of_image_pts),...
        pf_near_skip_uncoupled(strtpt:strtpt + no_of_image_pts),'LineWidth',1.2)
    xlim([time_skip_uncoupled(strtpt) time_skip_uncoupled(strtpt + no_of_image_pts)])
    ylim([-7000 7000])
    hold on
    plot(time_skip_uncoupled(k), pf_near_skip_uncoupled(k),...
        'o','MarkerFaceColor','r','MarkerSize',8)
    xlabel('$t$ (s)','Interpreter','latex')
    ylabel('$p^\prime$ (Pa)','Interpreter','latex')
    set(gca, 'YTick', [-7000,0,7000], 'YTickLabel', [-7000,0,7000])
    set(gca,'FontSize',20)
    set(gca,'LineWidth',1.5)
    title(sprintf('Thermoacoustic Instability, time = %0.4f s',...
        time_skip_uncoupled(k)),'interpreter','latex')
    
    hold off
    subplot(2,2,3,'Parent',figure1)
    imagesc(Chemi_double_uncoupled);
    view(2)
    colormap(mycolormap2);
    set(gca,'color',[0.6157 0.6157 0.6157]);
    set(gca, 'XTick', [1,255,510,764,1279], 'XTickLabel', (0:40:120))
    set(gca, 'YTick', [1,297,574], 'YTickLabel', [45,0,-45])
    xlabel('$x$ (mm)','Interpreter','latex')
    ylabel('$y$ (mm)','Interpreter','latex')
    set(gca,'FontSize',20)
    set(gca,'LineWidth',1.5)
    %colorbar
    % caxis([-ceil(climit/3) climit/3]);
    caxis([0 8000])
    
    subplot(2,2,2,'Parent',figure1)
    plot(time_skip_coupled(strtpt:strtpt + no_of_image_pts),...
        pf_near_skip_coupled(strtpt:strtpt + no_of_image_pts),'LineWidth',1.2)
    xlim([time_skip_coupled(strtpt) time_skip_coupled(strtpt + no_of_image_pts)])
    ylim([-7000 7000])
    hold on
    plot(time_skip_coupled(k), pf_near_skip_coupled(k),...
        'o','MarkerFaceColor','r','MarkerSize',8)
    xlabel('$t$ (s)','Interpreter','latex')
    ylabel('$p^\prime$ (Pa)','Interpreter','latex')
    set(gca, 'YTick', [-7000,0,7000], 'YTickLabel', [-7000,0,7000])
    set(gca,'FontSize',20)
    set(gca,'LineWidth',1.5)
    title(sprintf('Coupled with $L_c = $%d mm, time = %0.4f s',length_coupling_mm...
        , time_skip_coupled(k)),'interpreter','latex')
    
    hold off
    subplot(2,2,4,'Parent',figure1)
    imagesc(Chemi_double_coupled);
    % view(2)
    colormap(mycolormap2);
    % colormap gray
    set(gca,'color',[0.6157 0.6157 0.6157]);
    set(gca, 'XTick', [1,255,510,764,1279], 'XTickLabel', (0:40:120))
    set(gca, 'YTick', [1,297,574], 'YTickLabel', [45,0,-45])
    xlabel('$x$ (mm)','Interpreter','latex')
    ylabel('$y$ (mm)','Interpreter','latex')
    set(gca,'FontSize',20)
    set(gca,'LineWidth',1.5)
    %colorbar
    % caxis([-ceil(climit/3) climit/3]);
    caxis([0 8000])
    movievector(k) = getframe(figure1,[100 0.1 1400 800]); % Might have to modify this according to screen size and OS
    pause(0.001)
end

movievector(all(cell2mat(arrayfun(@(x) structfun(@isempty, x), movievector, 'UniformOutput', false)),1)) = [];
% To remove empty rows in the movievector structure
% Refer to https://in.mathworks.com/matlabcentral/answers/473384-delete-empty-field-rows-in-a-structure#answer_384733

mywriter = VideoWriter(sprintf('Coupling with %d mm',length_coupling_mm),'Motion JPEG AVI');
mywriter.FrameRate = 0.05;

open(mywriter);
writeVideo(mywriter,movievector);
close(mywriter);

winopen(sprintf('%d mm.avi',length_coupling_mm)); % Only for Windows OS
close all
