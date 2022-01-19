%% Use this code to create background FaceAlpha patch in existing 2D figure

xd = get(gca, 'xlim'); xd = [xd(1) xd(2)];
yd = get(gca, 'ylim'); yd = [yd(1) yd(2)];
x = [xd(1) xd(2) xd(2) xd(1) xd(1)];
y = [yd(1) yd(1) yd(2) yd(2) yd(1)];
p = patch(x,y,[0.7098 0.8706 1], ...
    'EdgeColor', 'none', 'FaceAlpha', 0.3);
set(gca,'children',flipud(get(gca,'children')))

