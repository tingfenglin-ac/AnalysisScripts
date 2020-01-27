function [R, res, timefit, fit,msg] = JL_fit_exp(time, V, t1,t2,x0,p)

options=optimset('Display', 'on');


if (nargin < 6), p = 0; end
if (nargin < 5), x0 = ones(size(V,2),5); end
if (size(V,2) > 1 & size(x0,1) == 1), x0 = repmat(x0,size(V,2),1) ; end
if (size(time, 1) == 1)  ; time = time'; end

R = zeros(size(V,2),5) ;
res = zeros(1,size(V,2)) ;
for i = 1:size(V,2)
    if (x0(i,4) == 0 & x0(i,5) == 0)
        if(isnan(x0(i,1)))
            fprintf(1,'Fitting with f(t) = x(2)*exp(-t/x(3)) ') ;
            f_VOR = @(x,t)(x(1)*exp(-t/x(2)) ) ;
            t = time; data = V(:,i) ;
            t = t(not(isnan(data))) ; data = data(not(isnan(data))) ;
            t = t-t1 ; data = data(t > 0 & t < t2-t1) ;t = t(t > 0 & t < t2-t1) ;
            [x, r] = lsqcurvefit(f_VOR,x0(i,2:3),t,data,[],[],options) ;
            res(i) = r ;
            R(i,:) = [0 x 0 0] ;
        else
            fprintf(1,'Fitting with f(t) = x(1) + x(2)*exp(-t/x(3)) ') ;
            f_VOR = @(x,t)(x(1) + x(2)*exp(-t/x(3))  ) ;
            t = time; data = V(:,i) ;
            t = t(not(isnan(data))) ; data = data(not(isnan(data))) ;
            t = t-t1 ; data = data(t > 0 & t < t2-t1) ;t = t(t > 0 & t < t2-t1) ;
            [x, r] = lsqcurvefit(f_VOR,x0(i,1:3),t,data,[],[],options) ;
            R(i,:) = [x 0 0] ;
            res(i) = r ;
        end

    else
        if(isnan(x0(i,1)))
            fprintf(1,'Fitting with f(t) =  x(2)*exp(-t/x(3)) + x(4)*exp(-t/x(5))') ;
            f_VOR = @(x,t)(x(1)*exp(-t/x(2)) + x(3)*exp(-t/x(4)) ) ;
            t = time; data = V(:,i) ;
            t = t(not(isnan(data))) ; data = data(not(isnan(data))) ;
            t = t-t1 ; data = data(t > 0 & t < t2-t1) ;t = t(t > 0 & t < t2-t1) ;
            [x, r] = lsqcurvefit(f_VOR,x0(i,2:end),t,data,[],[],options) ;
            res(i) = r ;
            R(i,:) = [0 x] ;
        else
            fprintf(1,'Fitting with f(t) = x(1) +  x(2)*exp(-t/x(3)) + x(4)*exp(-t/x(5))') ;
            f_VOR = @(x,t)(x(1) + x(2)*exp(-t/x(3)) + x(4)*exp(-t/x(5)) ) ;
            t = time; data = V(:,i) ;
            t = t(not(isnan(data))) ; data = data(not(isnan(data))) ;
            t = t-t1 ; data = data(t > 0 & t < t2-t1) ;t = t(t > 0 & t < t2-t1) ;
            [x, r] = lsqcurvefit(f_VOR,x0(i,:),t,data,[],[],options) ;
            R(i,:) = x ;
            res(i) = r ;
        end
    end
    if p, hold on; plot(sort(t+t1), [f_VOR(x,sort(t'))],'-k','LineWidth',2); plot(sort(t+t1),data) ; hold off ;end
    fprintf(1,':  x = %2.1f %2.1f %2.1f %2.1f %2.1f\n',R(i,:)) ;
    msg{i} = sprintf('f(t) = %2.2f +  %2.2f e^{-t/%2.2f} + %2.2f e^{-t/%2.2f}',x) ;
end
res = res / numel(t) ;
timefit = t1:0.01:t2;  fit = f_VOR(x,t1:0.01:t2) ;
