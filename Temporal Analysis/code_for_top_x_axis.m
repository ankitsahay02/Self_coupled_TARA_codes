%% Code to attach a second x-axis at top
% Use this with the code generated from the figure

ax1 = gca; % current axes
ax1_pos = ax1.Position; % position of first axes
ax2 = axes('Position',ax1_pos,'XAxisLocation','top','YAxisLocation','right','Color','none','YTick',[],'TickLength',[.00014 .0014]);
xlabel(ax2,'$L_c/L_{duct}$');