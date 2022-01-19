%% Code for time series datapoints and corresponding chemi images
% Requires some adjustments in the final figure

clc
clear

%% Extract and prepare data

set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot, 'defaultAxesTickDir', 'out');
set(groot,  'defaultAxesTickDirMode', 'manual');

delay_time_uncoupled = [413.91 ;324.02 ;324.02 ;82.32 ;65.46 ;64.29 ;...
    69.62 ;32.39 ;124.32 ;413.25 ;98.73 ;389.34];
delay_time_coupled = [498.3; 320.23; 320.23; 71.18; 320.23; 320.23; 320.23;...
    320.23; 320.23; 320.23; 320.23; 320.23];

% mycolormap  = customcolormap(linspace(0,1,5), {'#a60026','#f66e44','#ffffbd','#73add2','#313691'});
% mycolormap2 = customcolormap(linspace(0,1,9), {'#b35806','#e08214','#fdb863','#fee0b6','#f7f7f7','#d8daeb','#b2abd2','#8073ac','#542788'});

length_coupling      = 160;

if length_coupling ~= 215
    length_data_counter   = (length_coupling-90)/10;
else
    length_data_counter = 12;
end

Camera_dataset_Folder = '/media/ankit/My Book/Ankit Sahay/Lab System/Self_coupling_TARA_data/TARA/Experiments/Camera_Data_Sets/';
Length_name           = sprintf('%d cm',length_coupling);
Length_folder         = ([Camera_dataset_Folder Length_name '/']);
Pressure_folder       = 'Pressure';
pres_data_Folder      = ([Length_folder Pressure_folder '/']);

Image_folder            = '/media/ankit/My Book/Ankit Sahay/Lab System/Self_coupling_TARA_data/TARA/Tiff images/'; % Folder containing tiff images
Image_data_folder   = ([Image_folder Length_name '/']);
Coupling_status     = 'During coupling';
Image_data_folder   = ([Image_data_folder Coupling_status '/Test1/1_Cam_8726_Cine2/']);
Chemiimgname        = 'Img';

file_num   = 2;
file_name  = sprintf('%d.txt', file_num);
pres_data  = load([pres_data_Folder, file_name]);
p_near     = pres_data(:,3)*1000/0.2134;
pf_near    = p_near - mean(p_near);
pnear_frms = rms(pf_near);

total_time    = 3;
fs_pres       = 10000;
fs_img        = 2000;
sktime        = 1/fs_pres;
sktime_micros = sktime*1000000;
fs_pres_to_fs_img_ratio = fs_pres/fs_img;
time_actual             = sktime:sktime:total_time;

cam_delay        = delay_time_coupled(length_data_counter);
cam_delay_s      = cam_delay * 1e-6;
skip_data_points = ceil(cam_delay_s * fs_pres);

time_skip         = time_actual(skip_data_points:fs_pres_to_fs_img_ratio:end);
pf_near_raw       = pf_near(skip_data_points:end);
pf_near_skip      = pf_near_raw(1:fs_pres_to_fs_img_ratio:end);
pf_near_skip_norm = pf_near_skip./std(pf_near_skip);

Length_name           = sprintf('%d cm',length_coupling);
Length_folder         = ([Camera_dataset_Folder Length_name '/']);
Pressure_folder       = 'Pressure';
pres_data_Folder      = ([Length_folder Pressure_folder '/']);


PMT_folder      = 'HRR';
pmt_data_Folder = ([Length_folder PMT_folder '/']);
pmt_data        = load([pmt_data_Folder, file_name]);
pmt             = pmt_data(:,2);
pmtf            = pmt - mean(pmt);
pmtf_raw        = pmtf(skip_data_points:end);
pmtf_skip       = pmtf_raw(1:fs_pres_to_fs_img_ratio:end);

row_image       = 574;
col_image       = 764;
tot_matrix_size = row_image*col_image;

%% Plot pressure time series and corresponding camera data points

strtpt          = 100;
no_of_image_pts = 100;

plim = 1000;
qlim = 0.5; % Change limits as required

figure(2)
plot(time_skip(strtpt:strtpt + no_of_image_pts),...
    pf_near_skip(strtpt:strtpt + no_of_image_pts),'-o'...
    ,'MarkerFaceColor','red')
xlim([time_skip(strtpt) time_skip(strtpt + no_of_image_pts)])
ylim([-plim plim])

%% Fixing a reference point

% figure1 = figure('InvertHardcopy','off','WindowState','maximized',...
% 'Color',[1 1 1]);

time_instant_first = 0.2829;
start_idx          = find(abs(time_skip - time_instant_first) < 0.00001);
col_cons           = start_idx:2:start_idx+14;

strtpt          = start_idx - 20;
no_of_image_pts = 50;

%% Plot overlapped p' and q'

figure(2)
subplot(5,2,[1 2])
yyaxis left
plot(time_skip(strtpt:strtpt + no_of_image_pts),...
    pf_near_skip(strtpt:strtpt + no_of_image_pts),'LineWidth',1,...
    'Color','b')
xlim([time_skip(strtpt) time_skip(strtpt + no_of_image_pts)])
ylim([-plim plim])
%plot(time_skip_coupled(k), pf_near_skip_coupled(k),...
%    'o','MarkerFaceColor','r','MarkerSize',8)
xlabel('$t$ (s)','Interpreter','latex')
ylabel('$p^\prime$ (Pa)','Interpreter','latex')
set(gca, 'YTick', [-plim,0,plim], 'YTickLabel', [-plim,0,plim])
set(gca,'FontSize',15)
set(gca,'LineWidth',1)

yyaxis right
plot(time_skip(strtpt:strtpt + no_of_image_pts),...
    pmtf_skip(strtpt:strtpt + no_of_image_pts),'LineWidth',1,...
    'Color','r')
xlabel('$t$ (s)','Interpreter','latex')
ylabel('$\dot{q}^\prime$ (a.u.)','Interpreter','latex')
ylim([-qlim qlim])
set(gca,'FontSize',15)
set(gca, 'YTick', [-qlim,0,qlim], 'YTickLabel', [-qlim,0,qlim])

hold on;
yyaxis left
plot(time_skip(col_cons), pf_near_skip(col_cons),...
    'o','MarkerFaceColor','b','MarkerSize',8)
ylim([-plim plim])

% yyaxis right
% plot(time_skip(col_cons), pmtf_skip(col_cons),...
%     'o','MarkerFaceColor','r','MarkerSize',8)
% ylim([-qlim qlim])
%%

clear Chemi_double_reshaped

for counter = 1:length(col_cons)
    k = col_cons(counter);
    
    FileStr              = sprintf('%06d.tif', k);
    dataname_coupled     = strcat(Image_data_folder,...
        Chemiimgname, FileStr);
    Chemi_file_coupled   = importdata(dataname_coupled);
    Chemi_double_coupled = double(Chemi_file_coupled);
    
    % Mask bluff body region
    Chemi_double_coupled(319:421,1:185)   = 0;
    Chemi_double_coupled(216:529,185:262) = 0;
    Chemi_double_coupled(:,765:end)       = [];
    
    % Crop the outer boundaries
    Chemi_double_coupled(1:73,:)       = [];
    Chemi_double_coupled(end-72:end,:) = [];
    
    Chemi_double_reshaped(:,counter) ...
        = reshape(Chemi_double_coupled,tot_matrix_size,1);
end

%% Calculate mean of chemi images
for counter = 1:400
    counter
    FileStr_for_mean              = sprintf('%06d.tif', counter);
    dataname_for_mean     = strcat(Image_data_folder,...
        Chemiimgname, FileStr_for_mean);
    Chemi_file_for_mean   = importdata(dataname_for_mean);
    Chemi_double_for_mean = double(Chemi_file_for_mean);
    
    % Mask bluff body region
    Chemi_double_for_mean(319:421,1:185)   = 0;
    Chemi_double_for_mean(216:529,185:262) = 0;
    Chemi_double_for_mean(:,765:end)       = [];
    
    % Crop the outer boundaries
    Chemi_double_for_mean(1:73,:)       = [];
    Chemi_double_for_mean(end-72:end,:) = [];
    
    Chemi_double_reshaped_for_mean(:,counter) ...
        = reshape(Chemi_double_for_mean,tot_matrix_size,1);
end

mean_chemi = mean(Chemi_double_reshaped_for_mean,2);

%%

chemi_fluc_matrix = (Chemi_double_reshaped - mean_chemi)...
    ./std(Chemi_double_reshaped_for_mean,0,2);
inst_pq_matrix    = chemi_fluc_matrix .* pf_near_skip_norm(col_cons)';

%% Run this section after running "Plot overlapped p' and q'" section above

for counter = 1:length(col_cons)
    data_pt = col_cons(counter);
    inst_chemi_fluc = reshape(chemi_fluc_matrix(:,counter),...
        row_image,col_image);
    inst_pq = reshape(inst_pq_matrix(:,counter),...
        row_image,col_image);
    figure(2)
    subplot(5,2,counter+2);
    imagesc(inst_pq);
    % imagesc(inst_pq)
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    c = colorbar;
    clim = [-2 3]; % Change colorbar axis limits according to visualization
    set(gca,'clim',clim)
    colormap(jet)
    % colormap(custom_color('inst_pq'))
    % plot_matrix(:,:,counter) = Chemi_double_coupled;
    % plot_matrix(:,:,counter) = inst_pq;
    set(c,'TickLabelInterpreter','latex','FontSize',18)
    ylabel('$y$ (mm)','Interpreter','latex');
    set(gca,'Color',[0.6157 0.6157 0.6157],'FontSize',18,'Layer','top',...
            'LineWidth',1,'XTick',[1 255 510 764 1279],'XTickLabel',...
            {'','','','',''},'YTick',[1 297 574],'YTickLabel',...
            {'-45','0','45'});
        
    if counter == length(col_cons) - 1 || counter == length(col_cons)
        set(gca,'Color',[0.6157 0.6157 0.6157],'FontSize',18,'Layer','top',...
            'LineWidth',1,'XTick',[1 255 510 764 1279],'XTickLabel',...
            {'0','40','80','120','0'});
        xlabel('$x$ (mm)','Interpreter','latex');
        
    end
end
