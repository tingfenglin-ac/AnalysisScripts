function [trigtime] = findtrigger(dat, defaultstart)

figure(768)
plot(dat, '.-')
hold on
if nargin ==1
  mk = plot(1, dat(1), 'go', 'Visible', 'off');
else
  mk = plot(defaultstart, dat(defaultstart), 'go', 'Visible', 'on');
end

zoom on;
set(gcf, 'Name', ': Zoom in - then hit ENTER to start selection');
title('Press q to accept point and quit')
% change by cjb to get around an apparent bug in version 7
%pause;
while(~waitforbuttonpress)
end
gc= get(gcf, 'Currentcharacter');

if strcmp(gc, 'q')
  trigtime = defaultstart;
  return
end


set(gcf, 'Name', 'Click a point');
zoom off;

[x y] = ginput(1);
%[ w  wi ] = min( abs(a-x));
wi = round(x);
shg
set(mk, 'Visible', 'on', 'Xdata', wi, 'Ydata', dat(wi), 'Color', [1 0 0])
drawnow
set(gcf, 'Name', 'Use arrow keys to adjust, Enter or q to end')
kpp =1;

while kpp
    shg
    waitforbuttonpress;
    k =get(gcf, 'CurrentKey');
    if strcmp(k, 'rightarrow')
        xd = get(mk, 'Xdata');
        set(mk, 'Xdata', xd+1, 'Ydata', dat(xd+1));
    elseif strcmp(k, 'leftarrow')
        xd = get(mk, 'Xdata');
        set(mk, 'Xdata', xd-1, 'Ydata', dat(xd-1));
    elseif strcmp(k, 'return') || strcmp(k, 'q')
        kpp =0;
    end
end
trigtime = get(mk, 'Xdata');
close(768)
