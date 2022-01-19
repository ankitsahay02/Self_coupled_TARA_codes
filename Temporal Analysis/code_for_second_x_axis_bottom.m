%% Code to attach a second x-axis at bottom
% Use this with the code generated from the figure

ax1 = gca;
ax1.Position = ax1.Position+[0 0.07 0 0];
xlabel('$L_c$ (cm)','interpreter','latex');

ax2 = axes();
ax2.Position = ax1.Position-[0 0.10 0 0];
ax2.Color = 'none';
ax2.YAxis.Visible = 'off';
xlabel('$L_c/L_{duct}$','interpreter','latex');