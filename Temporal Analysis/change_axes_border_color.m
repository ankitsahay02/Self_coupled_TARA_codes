%% Code to change axis border color


h = gca;                  %fixed relative to jonas's suggestion
set(h,'ycolor','none')
h.YAxis.Label.Color=[0 0 0]; h.YAxis.Label.Visible='on';