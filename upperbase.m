function ub = upperbase(Fc,varargin)

warning off stats:mle:EvalLimit;

if nargin>1&&(isequal(varargin{1},true)||isequal(varargin{1},false))
    warning('ImageProcessing:depreciated','This input mode for upperbase is depreciated. Use parameter synax (e.g. >> upperbase(...,''getinput'',true))');
    varargin = {'getinput',varargin{1}};
end

alpha = [];
ip = inputParser;
ip.addParameter('getinput',true);
ip.addParameter('alpha',1-1e-4);
ip.parse(varargin{:});
for j=fields(ip.Results)'
    eval(sprintf('%s=ip.Results.%s;',j{1},j{1}));
end

if ~exist('getinput','var'), getinput = true; end

ub = zeros(size(Fc,2),1);

if getinput
    fig = figure;
end

for i=1:size(Fc,2)
    if getinput
        plot(Fc(:,i));
    end
    mu = 0;
    sig = sqrt(mean((Fc(Fc(:,i)<mu,i)-mu).^2));
    a = mean(Fc(Fc(:,i)>mu,i));
    p = sum(Fc(:,i)>2*sig+mu)/numel(Fc);
    
    try
        LL2=@(x,mu,sig,a,p)max((1-p)*normpdf(x,mu,sig)+p*exppdf(x,a),realmin);        
        phat = mle(...
            Fc(:,i)...
            ,'pdf',LL2...
            ,'start',[mu sig a p]...
            ,'lowerbound',[-inf 0 0 0]...
            ,'options',optimset('maxiter',1000)...
            );
        LL = sum(log(LL2(Fc(:,i),phat(1),phat(2),phat(3),phat(4))));
        
        mu = mean([min(Fc(:,i)) phat(1)]);
        sig = sqrt(mean((Fc(Fc(:,i)<mu,i)-mu).^2));        
        a = mean(Fc(Fc(:,i)>mu,i));
        p = sum(Fc(:,i)>2*sig+mu)/numel(Fc);
        
        phat2 = mle(...
            Fc(:,i)...
            ,'pdf',LL2...
            ,'start',[mu sig a p]...
            ,'lowerbound',[-inf 0 0 0]...
            ,'options',optimset('maxiter',1000)...
            );
        LL2 = sum(log(LL2(Fc(:,i),phat2(1),phat2(2),phat2(3),phat2(4))));
        if LL2>LL
           phat = phat2;
        end        
    catch err
        disp('MLE failed to estimate the upper limit, implement an alternative!');
        keyboard;
    end
    
    ub(i) = norminv(alpha)*phat(2)+phat(1);
    
    if getinput
        plot(Fc(:,i));
        
        line([0 size(Fc,1)],[1 1]*phat(1),'Color','r');
        line([0 size(Fc,1)],[1 1]*phat(2)*2+phat(1),'Color','r');
        
        title(sprintf('unit %i of %i. Click outside plot to use estimate or select upper limit.',i,size(Fc,2)));
        
        [a,b] = ginput(1);
        
        if ~(all(a>xlim)||all(a<xlim)||all(b>ylim)||all(b<ylim))
            %             keyboard
            ub(i) = b;            
            mu = median(Fc(Fc(:,i)<ub(i),i));
            sig = sqrt(mean((Fc(Fc(:,i)<ub(i),i)-mu).^2));
            
%             phat = mle(...
%                 Fc(:,i)...
%                 ,'pdf',@(x,a,p)max((1-p)*normpdf(x,mu,sig)+p*exppdf(x,a),realmin)...
%                 ,'start',[phat(3:4)]...
%                 ,'lowerbound',[0 0]...
%                 ,'options',optimset('maxiter',1000)...
%                 );
%             phat = [mu sig phat];
            
        end
    end
end

if getinput
    close(fig);
end

end