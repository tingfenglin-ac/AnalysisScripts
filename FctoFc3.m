function [Fc3, durs, upepochs, uppeaks, updurs ] = FctoFc3( Fc, ub, varargin )
% Parse inputs
if isempty(Fc)
    Fc3 = Fc;
    durs = [];
    upepochs = [];
    uppeaks=[];
    updurs = [];
    return
end

% Get upperbase if not provided
if ~exist('ub','var')||ischar(ub)
   ub = upperbase(Fc); 
end

ip = inputParser;
ip.addParameter('pthresh',0.01);
ip.parse(varargin{:});
for j=fields(ip.Results)'
    eval([j{1} '=ip.Results.' j{1} ';']);
end
clear ip;

% Re-zero based on upperbase
in = NaN(size(Fc));
in(Fc<ub(:)') = 1;
medians = nanmedian(Fc.*in);
Fc = Fc-medians;
ub = ub(:)-medians(:);

% Get Z-scores
in = NaN(size(Fc));
in(Fc<0) = 1;
stds = sqrt(nanmean((Fc.*in).^2));
Z=Fc./stds(:)';

% Positive going candidate transients - between +0.5 and 2 deviations away
% from median below ub
upepochs = arrayfun(@(i)double_thresh(Z(:,i),2,0.5),1:size(Fc,2),'UniformOutput',false);% Time windows of transients
updurs = cellfun(@(x)diff(x,[],2)+1,upepochs,'UniformOutput',false);% Duration of transients
uppeaks = arrayfun(@(i)arrayfun(@(k)max(Z(upepochs{i}(k,1):upepochs{i}(k,2),i)),(1:size(upepochs{i},1))'),1:size(Fc,2),'UniformOutput',false);% Peak within each transient

downepochs = arrayfun(@(i)double_thresh(-Z(:,i),2,0.5),1:size(Fc,2),'UniformOutput',false);% Time windows of transients
downdurs = cellfun(@(x)diff(x,[],2)+1,downepochs,'UniformOutput',false);% Duration of transients
downpeaks = arrayfun(@(i)arrayfun(@(k)max(-Z(downepochs{i}(k,1):downepochs{i}(k,2),i)),(1:size(downepochs{i},1))'),1:size(Fc,2),'UniformOutput',false);% Peak within each transient

% ratio_hist = arrayfun(@(i)histcn([downpeaks{i} downdurs{i}],[0:6 inf],[1:25 inf])./histcn([uppeaks{i} updurs{i}],[0:6 inf],[1:25 inf]),find(~cellfun(@isempty,downdurs)),'UniformOutput',false);
% ratio_hist = nanmean(cat(3,ratio_hist{:}),3);
ratio_hist = histcn([cat(1,downpeaks{:}) cat(1,downdurs{:})],[0:6 inf],[1:25 inf])./histcn([cat(1,uppeaks{:}) cat(1,updurs{:})],[0:6 inf],[1:25 inf]);
ratio_hist = ratio_hist<pthresh;

for i=1:size(ratio_hist,1)
   if any(ratio_hist(i,:))||(i>1&&any(ratio_hist(i-1,:)))
       k = find(ratio_hist(i,:),1);
       if i>1
           k = min([find(ratio_hist(i-1,:),1) k]);
       end
       ratio_hist(i,k:end) = true;
   end
end

durs = inf(size(ratio_hist,1),1);
for i=find(any(ratio_hist,2))'
   durs(i) = find(ratio_hist(i,:),1); 
end

Fc3 = zeros(size(Fc));
for i=1:size(Fc3,2)
    for k=find(updurs{i}>=durs(min(floor(uppeaks{i}),size(ratio_hist,1))))'
        Fc3(upepochs{i}(k,1):upepochs{i}(k,2),i)=Fc(upepochs{i}(k,1):upepochs{i}(k,2),i);
    end
end

end

function ups = double_thresh(x, u, l)
%%
    ups = find(x>u);
    downs = find(x<l);
    ups = sortrows([ups ones(size(ups));downs zeros(size(downs))]);
    ups = ups(find(diff(ups(:,2))~=0)+1,:);
    
    if ~isempty(ups)&&~isempty(downs)

    if x(1)>u, ups = ups(3:end,:); end
    if ~ups(1,2), ups = ups(2:end,:); end
    if ups(end,2), ups = ups(1:end-1,:); end;
    
    ups = reshape(ups(:,1),[2 size(ups,1)/2])';
    ups(:,2) = ups(:,2)-1;
    
    end
    
end