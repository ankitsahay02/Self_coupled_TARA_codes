%% Sample code to use plotyyy function

x=0:10; 
y1=x;  y2=x.^2;   y3=x.^3;
ylabels{1}='First y-label';
ylabels{2}='Second y-label';
ylabels{3}='Third y-label';
[ax,hlines] = plotyyy(x,y1,x,y2,x,y3,ylabels);
