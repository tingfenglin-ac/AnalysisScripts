function i=fpeak(data,tau,threshold,peakval,show)
%
% finds indexes of local peaks and troufs
%
% i=fpeak(data,tau,threshold,peakval,show)
%
% data         - input vector
% tau       - number of points to be considered 'local'
%             in other words the number of points between peaks
% threshold - min value for peak (max if peakval = -1)
% 						if threshold is data vector of length 2, then fpeak looks for peaks 
%						between the values (order insensitive)
%									
% peakval   -  look for peaks, valleys or both
%
%               1 - peaks (default)
%               0 - both
%              -1 - valleys
% show      - 1 show progressive plot (default)
%             0 don't
%
%
%
% i - indexes of peaks
%

if nargin<3
  threshold=0;
end

if nargin<4
  peakval=1;
end

if nargin<5
  show=0;
end

dataplot=data;

if length(threshold) == 2;
	threshold = sort(threshold);
	window = 1;
else 
	window = 0;
end

switch peakval
  case 1
    % do nothing
  case 0
    data=abs(data);
  case -1
    data=-data;
end

N=length(data);
k=[1:N];
t2=tau*2+1;
i=[];

% compare each point to the point tau-samples before and after it
i1=tau+find(data(tau+1:N-tau)>=data(1:N-2*tau) & data(tau+1:N-tau)>data(2*tau+1:N));
if show
  clf
  han=plot(k,dataplot,1,dataplot(1),'ko');
  han=han(2);
  set(gca,'xlim',[1 N])
  hold on
end


Ni=length(i1);
Ni1=round(Ni*.1);
ilast=-1*tau-10;
for j=1:Ni
  if tau<=(i1(j)-ilast)
    if sum(data(i1(j))>=data(i1(j)-tau:i1(j)+tau))==t2
			if window
				if threshold(1) < data(i1(j))& threshold(2) > data(i1(j))
          i=[i i1(j)];
          ilast=i1(j);
        end
	  	else
        if data(i1(j))>threshold
          i=[i i1(j)];
          ilast=i1(j);
        end
	  	end
    end
  end
  if rem(j,Ni1)==0 & show,
    % disp([num2str(round(100*j/Ni)),'%    have found ',num2str(length(i))]);
    set(han,'xdata',i,'ydata',dataplot(i))
    drawnow
  end
end

if show,
  set(han,'xdata',i,'ydata',dataplot(i))
  drawnow
end



return
