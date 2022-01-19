%% Dimensionalization

% L = 1;
% c0 = 340;
%
% time = t.*(L/c0);

%% FFT of signals for checking signals frequency content
% xf_act = 0.66;
% K_act = 2.1;
% ind = 460*K_act - 100*xf_act + 76;


dt    = 1e-4;
N     = 30000;
t_arr = 0:dt:(N-1)*dt;
time  = t_arr;

for counter = 19
    pf_1  = pf_near(:,counter);
    pmtf_1 = pmtf(:,counter);
    % pf_1  = pp_f(end/2:end);
    % pf_1  = pf_near(96000:170000,1);
    fs    = 1/(time(2)-time(1));
    T     = 1/fs;
    L     = length(pf_1);           % Length of Pressure data in one column
    nfft  = 2^nextpow2(L);         % New input length that is the next power of 2 from the original signal length
    fVals = fs/2*linspace(0,1,nfft/2+1); % Frequency
    kp     = fft(pf_1, nfft)/L;      % FFT
    P1p    = 2*abs(kp(1:nfft/2+1)).^2; % Power Spectrum
    Pxp    = 2*abs(kp(1:nfft/2+1)); % Amplitude spectrum
    dBp    = pow2db(P1p);
    dBp_smooth = smoothdata(dBp,'gaussian',5);
    
    kq     = fft(pmtf_1, nfft)/L;      % FFT
    P1q    = 2*abs(kq(1:nfft/2+1)).^2; % Power Spectrum
    Pxq    = 2*abs(kq(1:nfft/2+1)); % Amplitude spectrum
end

%%
% figure(1)
% yyaxis left
% subplot(121)
plot(fVals, Pxp, 'LineWidth',1,'Color',[0 0.616 0.679]);
xlim([0 700])
xlabel('$f$ (Hz)','Interpreter', 'latex','fontsize', 20,'fontweight','n','FontAngle','italic' );
%ylabel('$\widehat{p}(f)$ (10 Pa per div$^{-1}$)','Interpreter', 'latex','fontsize',15,'fontweight','n','FontAngle','italic');
% title('FFT','Interpreter', 'latex','fontsize',20,'fontweight','n','FontAngle','italic');
set(gca,'TickLabelInterpreter','latex')
set(gca,'TickDir','out');
ax = gca;
ax.FontSize = 15;

%%
% figure(2)
% yyaxis right
% subplot(122)
plot(fVals,Pxq,'LineWidth',1,'Color',[0.88 0.365 0.365]);
%ylabel('$|\widehat{\dot{q}}(f)|$ (0.1 a.u. per div$^{-1})$','Interpreter', 'latex','fontsize',18,'fontweight','n','FontAngle','italic');
xlim([0 700])
set(gca,'TickLabelInterpreter','latex')
set(gca,'TickDir','out');
ax = gca;
ax.FontSize = 15;
% ax.YAxis(1).FontSize = 15;
% ax.YAxis(2).FontSize = 15;
% ax.YAxis(1).Color = [0 0.616 0.679];
% ax.YAxis(2).Color = [0.88 0.365 0.365];
xlabel('$f$ (Hz)','Interpreter', 'latex','fontsize', 20,'fontweight','n','FontAngle','italic' );

