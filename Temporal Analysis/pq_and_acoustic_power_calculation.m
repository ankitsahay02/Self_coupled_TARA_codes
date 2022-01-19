clc
clear
close all

%%

set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

mycolormap  = customcolormap(linspace(0,1,5), {'#a60026','#f66e44','#ffffbd','#73add2','#313691'});
mycolormap2 = customcolormap(linspace(0,1,9), {'#b35806','#e08214','#fdb863','#fee0b6','#f7f7f7','#d8daeb','#b2abd2','#8073ac','#542788'});

Pressure_Folder = '/home/ankit/ankit/Research/TARA/2021 Experiments/November/23 Nov 2021/Combustion Experiments/Trial 5/';
Pressdataname   = strcat(Pressure_Folder, '1.txt');
cam_delay       = 932.84;
Chemi_Folder    = '/home/ankit/ankit/Research/TARA/2021 Experiments/November/23 Nov 2021/Combustion Experiments/Trial 5/24sec/Test1/5_Cam_8726_Cine1/';
Chemiimgname    = 'Img';
PMT_Folder      = '/home/ankit/ankit/Research/TARA/2021 Experiments/PMT/November/23 Nov 2021/Trial 5/';
PMTdataname     = strcat(PMT_Folder, '1.txt');

total_time = 24;
fs_pres    = 10000;
fs_img     = 500;

sktime    = 1/fs_pres;
sktime_ms = sktime*1000000;
presta    = ceil(cam_delay/sktime_ms);

ds_timser = fs_pres/fs_img;
timeact   = sktime:sktime:total_time;

timser           = importdata(Pressdataname);
p_near_inst_raw  = timser(presta:end,3);
p_near           = p_near_inst_raw*1000/0.2134;
p_near_full_Skip = p_near(1:ds_timser:end);
pf_near          = p_near - mean(p_near);
pf_near_skip     = pf_near(1:ds_timser:end);

timserPMT = importdata(PMTdataname);
pmt_raw   = timserPMT(presta:end,2);
pmt       = pmt_raw./1;
pmtf      = pmt - mean(pmt);
pmt_skip  = pmt(1:ds_timser:end);
pmtf_skip = pmtf(1:ds_timser:end);

time_skip = timeact(presta:ds_timser:end);


%%
% 24690
strtpt = 3701;
endpt  = 3705;

figure1 = figure('InvertHardcopy','off','WindowState','maximized',...
    'Color',[1 1 1]);

for ii = strtpt:endpt
    clf;
    idx      = ii;
    FileStr  = sprintf('%06d.tif', ii);
    dataname = strcat(Chemi_Folder, Chemiimgname, FileStr);
    Xtt      = importdata(dataname);
    Xttdou   = double(Xtt);
    
    % Mask bluff body region
    Xttdou(291:429,1:195)   = NaN;
    Xttdou(175:545,196:298) = NaN;
    
    XttSelVec(:,idx) = Xttdou(:); % picks elements from Xttdou column-wise
    qmovTSsum(idx)   = sum(sum(Xttdou));
    
    pf_near_skip_inst = pf_near_skip(idx);
    pmtf_skip_inst    = pmtf_skip(idx);
    time_skip_inst    = time_skip(idx);
    
    
    % Create axes
    axesp = axes('Parent',figure1,...
        'Position',[0.0534268753372909 0.616024973985432 0.36913113869401 0.324661810613944]);
    hold(axesp,'on');
    box on;
    
    plot(time_skip(strtpt:endpt),pf_near_skip(strtpt:endpt) ,'Parent',axesp,'LineWidth',1.25,'Color',[0 0 1]);
    ylabel('$p^{\prime} \  \rm(kPa)$','LineWidth',1.25,'FontSize',16,...
        'Interpreter','latex');
    xlabel('$t \ \rm(s)$','LineWidth',1.25,'FontSize',14,...
        'Interpreter','latex');
    % title(['$p^\prime$ time series, t = ',num2str(t_k),'\ s'],'LineWidth',1.25,'FontWeight','bold','FontSize',16,...
       %  'Interpreter','latex');
    
    hold on;
    
    % Create running marker
    plot(time_skip_inst,pf_near_skip_inst,'Parent',axesp,'MarkerFaceColor',[1 0.6 0.6],...
        'MarkerEdgeColor',[1 0 0],...
        'MarkerSize',35,...
        'Marker','.',...
        'LineWidth',1.25,...
        'LineStyle','none');
    
    % Create axes
    axesq = axes('Parent',figure1,...
        'Position',[0.538586076632488 0.617065556711764 0.374527792768484 0.323621227887624]);
    hold(axesq,'on');
    box on;
    
    % Plot full time series
    plot(time_skip(strtpt:endpt),pmtf_skip(strtpt:endpt),'Parent',axesq,'LineWidth',1.25,'Color',[0 0 1]);
    ylabel('$\dot{q}^{\prime} \  \rm(a.u.)$','LineWidth',1.25,'FontSize',16,...
        'Interpreter','latex');
    xlabel('$t \ \rm(s)$','LineWidth',1.25,'FontSize',14,...
        'Interpreter','latex');
    % title(['$\dot{q}^\prime$ time series'],'LineWidth',1.25,'FontWeight','bold','FontSize',16,...
      %  'Interpreter','latex');
    hold on;
    
    % Create running marker
    plot(time_skip_inst,pmtf_skip,'Parent',axesq,'MarkerFaceColor',[1 0.6 0.6],...
        'MarkerEdgeColor',[1 0 0],...
        'MarkerSize',35,...
        'Marker','.',...
        'LineWidth',1.25,...
        'LineStyle','none');
    
    hold on;
    
    % Create axes
    axesimg = axes('Parent',figure1,...
        'Position',[0.247166756610901 0.0988553590010408 0.472207231516459 0.36212278876172]);
    hold(axesimg,'on');
    box on;
    
    imagesc(Xttdou)
    
end


% pfQf_field = sum(pfQf_inst, 2); % summing up along each pixel (rows -> pixel, columns -> time)
% AcoPow = reshape(pfQf_field, [size(Xttdou, 1), size(Xttdou, 2)]);

%%
% MF = 7.2; %(1mm = 7.8 pixels)
% xxmm = ([1:800]./MF);
% xx =xxmm-xxmm(1);
% yymm = ([1:600]./MF);
% yy =yymm-yymm(1);
%
%
% set(gcf,'Renderer','Zbuffer','Position',[10 10 400 220]);
% ax(1) = axes('position', [0.13 0.22 0.75 0.72]);
% box on
% subplot(ax(1))
% contourf(xx, yy, AcoPow, 100,'LineColor','none')
% colormap(mycolormap2);
% cbap = colorbar;
% %     caxis([0 7E4])
% %     cbap.Location = 'southoutside';
% cbap.Label.String = '$p^{\prime} \dot q^{\prime}$';
% cbap.Label.Interpreter = 'latex';
% cbap.TickLabelInterpreter = 'latex';
% axis tight;
% xlabel ('$ x \ $[mm]', 'FontSize',14, 'Interpreter','Latex')
% ylabel ('$ y \ $[mm]', 'FontSize',14, 'Interpreter','Latex')
% set(gca,'xtick',([0:50:100]),'FontSize',12);
% set(gca,'xticklabel',([0:50:100]));
% set(gca,'ytick',([0:35:70]),'FontSize',12);
% set(gca,'yticklabel',([0:35:70]));
% xlim([xx(1), xx(end)]);
% ylim([yy(1), yy(end)]);
%
% % save('AcoPow_BL_phi085_075.mat','xx', 'yy', 'AcoPow')
% % save('AcoPow_BL_phi097_088_dou.mat','xx', 'yy', 'AcoPow')
% % save('AcoPow_IS_phi097_088_dou.mat','xx', 'yy', 'AcoPow')
% % save('AcoPow_MH_phi097_088_dou.mat','xx', 'yy', 'AcoPow')
% save('AcoPow_BL_phi097_088_dou_Rev02.mat','xx', 'yy', 'AcoPow')
% % save('AcoPow_IS_phi097_088_dou_Rev02.mat','xx', 'yy', 'AcoPow')
% % save('AcoPow_MH_phi097_088_dou_Rev02.mat','xx', 'yy', 'AcoPow')
% %%
%
% for ii = idxsel
%     idx = find(idxsel==ii);
%     FileStr = sprintf('%05d.tif', ii);
%     dataname = strcat(Chemi_Folder, Chemiimgname, FileStr);
%     Xtt = importdata(dataname);
%     Xttdou = im2double(Xtt);
%     %                 Xttdou = double(Xtt);
%     XttSelVec = Xttdou(:);
%     XttSel2D(:, idx) = XttSelVec;
% end
% %              qmovflu(:, idx1+gp1-1) = XttSel2D(:,end)-mean(XttSel2D,2);
% qmovflu = XttSel2D(:,:)-mean(XttSel2D,2);
% qmovfluTS = sum(qmovflu,1);
% Pf_Skip_sel = (pf_near_skip(idxsel))';
% Pf_mat_sel = repmat(Pf_Skip_sel, size(qmovflu, 1), 1);
% pfQf_inst = Pf_mat_sel.*qmovflu;
% pfQf_field = sum(pfQf_inst, 2);
% AcoPow = reshape(pfQf_field, [size(Xttdou, 1), size(Xttdou, 2)]);
%
% MF = 7.2; %(1mm = 7.8 pixels)
% xxmm = ([1:800]./MF);
% xx =xxmm-xxmm(1);
% yymm = ([1:600]./MF);
% yy =yymm-yymm(1);
%
%
% set(gcf,'Renderer','Zbuffer','Position',[10 10 400 220]);
% ax(1) = axes('position', [0.13 0.22 0.75 0.72]);
% box on
% subplot(ax(1))
% contourf(xx, yy, AcoPow, 100,'LineColor','none')
% colormap(mycolormap2);
% cbap = colorbar;
% %     caxis([0 7E4])
% %     cbap.Location = 'southoutside';
% cbap.Label.String = '$p^{\prime} \dot q^{\prime}$';
% cbap.Label.Interpreter = 'latex';
% cbap.TickLabelInterpreter = 'latex';
% axis tight;
% xlabel ('$ x \ $[mm]', 'FontSize',14, 'Interpreter','Latex')
% ylabel ('$ y \ $[mm]', 'FontSize',14, 'Interpreter','Latex')
% set(gca,'xtick',([0:50:100]),'FontSize',12);
% set(gca,'xticklabel',([0:50:100]));
% set(gca,'ytick',([0:35:70]),'FontSize',12);
% set(gca,'yticklabel',([0:35:70]));
% xlim([xx(1), xx(end)]);
% ylim([yy(1), yy(end)]);
%
% %%
% % Pf_Skip_sel = (Pf_kpa_Skip(idxsel))';
% Pf_Skip_sel_nor = Pf_Skip_sel./(max(Pf_Skip_sel));
% qmovfluTS_sel = qmovfluTS;
% qmovflu_Skip_sel_nor = qmovfluTS_sel./(max(qmovfluTS_sel));
%
% PMTinst_Kpa_Sel = (pmtf_skip(idxsel))';
% PMTflu_Kpa_Sel = PMTinst_Kpa_Sel - mean(PMTinst_Kpa_Sel);
% PMTf_kpa_Skipnor = PMTflu_Kpa_Sel./(max(PMTflu_Kpa_Sel));
%
%
%
% figure(2)
% plot(Pf_Skip_sel_nor)
% hold on
% plot(qmovflu_Skip_sel_nor)
% hold on
% plot(PMTf_kpa_Skipnor)
% hold off
% % save('AcoPow_BL_phi097_088New.mat','xx', 'yy', 'AcoPow')
% % save('AcoPow_IS_phi097_088.mat','xx', 'yy', 'AcoPow')
% % save('AcoPow_MH_phi097_088.mat','xx', 'yy', 'AcoPow')