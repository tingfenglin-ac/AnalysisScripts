function [ptr_cell, y_val] = seltime(time,mtx, message, plot_type)

%SELTIME	Function to select a data-range interactively
%
%Purpose
%Let's the user select a section of matrix
%as a function of time with a rubberband and 
%returns the selected time vector with
%the corresponding matrix.
%
%Call
%ptr_cell = seltime(time,mtx)
%
%Input
%time     time vector
%mtx      matrix of values, number of rows must 
%         be as the length of the time vector
%
%Output
%ptr_cell cell with groups of pointers for each selection
%y_val ... y-values of the edges of the selected cells
%	ThH, Nov-2003
%	Ver 1.3
%Program Structure:
%\general_th\seltime.m
%*****************************************************************
ptr_cell = {};
y_val = {};  

if nargin < 2 | nargin > 4
   disp('Incorrect number of arguments.');
   ptr_cell = {};
   return
end

if nargin == 2
   message = '';
end

if nargin ~= 4
   plot_type = '-';
end

[rr,cc] = size(time);
if rr < cc
   time = time';
end
[rr,cc] = size(time);
if cc > 1
   disp('Time vector must be one-dimensional.');
   return
end

[rr,cc] = size(mtx);
if rr ~= length(time)
   disp('Number of rows of input matrix must be equal the length of time vector.');
   return
end

xvec0 = min(time);
xvec1 = max(time);
max_vec = max(mtx')';
min_vec = min(mtx')';
yvec0 = min(min_vec);
yvec1 = max(max_vec);
xdiff = xvec1 - xvec0;
ydiff = yvec1 - yvec0;

figure (100)
% make figure big, about screen size
scrsz = get(0, 'ScreenSize');  % get screen size
set(gcf, 'Position', [20  40 (scrsz(3)/1 -50) (scrsz(4) -110)]);

hold on
plot(time,mtx, plot_type);
axis([xvec0 xvec1 yvec0-ydiff/10 yvec1+ydiff/10]);

figure(gcf);
button = 1;

zoom on;
set(gcf, 'Name', [message ': Zoom in - then hit ENTER to start selection']);

% change by cjb to get around an apparent bug in version 7
%pause;
while(~waitforbuttonpress)
end

set(gcf, 'Name', message);
zoom off;

title('End process by pressing ''q'' !');
counter = 0;
while button ~= 'q'
   counter = counter+1;
   k = waitforbuttonpress;
   point1 = get(gca,'CurrentPoint');% button down detected
   rbbox; % return Figure units
   point2 = get(gca,'CurrentPoint');% button up detected

   if k == 1
      button = get(gcf, 'CurrentCharacter');
   end

   x0 = point1(1,1);
   y0 = point1(1,2);
   x1 = point2(1,1);
   y1 = point2(1,2);

   if x0 > x1	   % if the rectangle was selected right to left
      xmin = x1;
      xmax = x0;
   else
      xmin = x0;
      xmax = x1;
   end

   if y0 > y1	   % if the rectangle was selected up to down
      ymin = y1;
      ymax = y0;
   else
      ymin = y0;
      ymax = y1;
   end

   % Check if the values are within the range:

   ev = (time > xmin) & (time < xmax);

   pos = find(ev);

   if sum(pos) >= 1
      ptr_cell{counter} = pos;
	  y_val{counter} = [ymin ymax];
   end
   plot([xmin xmax xmax xmin xmin], [ymin ymin ymax ymax ymin], 'r--');

end

hold off
close(gcf)
pause(0.1)
return
