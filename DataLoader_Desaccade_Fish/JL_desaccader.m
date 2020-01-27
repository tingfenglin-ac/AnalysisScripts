function [Y] = JL_desaccader(X, iV, dV,dwin, da)
% iV = velocity histogram abscissa
% dV = vel. threshold
% dwin = time window

if nargin < 2,  iV = -150:150 ; end
if nargin < 3,  dV = 10 ; end
if nargin < 4,  dwin = 300 ; end
if nargin < 5, da = 100 ; end
%%
tetaS = 2 ;
[n,mX] =  size(X) ;
%mX = 2 ;

acc= gradient(X')' ;

S = zeros(n,mX) ;
I = dwin+1:round(dwin/3):n-dwin-1 ;
dX = sign([zeros(1,size(X,2)) ; X(2:end,:)-X(1:end-1,:)]) ;
for j = 1:mX
    % Find saccade for a direction (Hor or Ver or Tor)
    for i = 1:length(I)
        Itmp = I(i)-dwin:I(i)+dwin ;
        h = hist(X(Itmp,j),iV) ;
        h(1) = 0; h(end) = 0 ;
        m = find(h == max(h),1,'first') ;
        
        if m == 1
           s = X(Itmp,j) > iV(m)+dV ;
        else
           if m == length(iV)
               s = X(Itmp,j) < iV(m)-dV ;
           else
                s = X(Itmp,j) < iV(m)-dV |  X(Itmp,j) > iV(m)+dV ;
           end
        end
        
        S(Itmp,j) =  S(Itmp,j) + s ;
    end
    S(X(:,j) < min(iV),j) = S(X(:,j) < min(iV),j) + tetaS ;
    S(X(:,j) > max(iV),j) = S(X(:,j) > max(iV),j) + tetaS ;
    S(:,j) = ( S(:,j) >= tetaS | abs(acc(:,j)) > da)  ;
    
    % Soo, now go backward
    Itrack = find(not(S(1:end-1,j)) & S(2:end,j)) ;
    Itrack = Itrack(Itrack < size(X,1))     ;
    while(not(isempty(Itrack)))
        Itrack  = Itrack( dX(Itrack,j) == dX(Itrack+1,j)  ) ;
        S(Itrack,j) = 1 ;
        Itrack = Itrack-1 ; Itrack = Itrack(Itrack > 0) ;
    end
    
    % Soo, now go forward
    Itrack = find(not(S(2:end,j)) & S(1:end-1,j)) ;
    Itrack = Itrack(Itrack > 1)     ;    
    while(not(isempty(Itrack)))
        Itrack  = Itrack( dX(Itrack,j) == dX(Itrack-1,j)  ) ;
        S(Itrack,j) = 1 ;
        Itrack = Itrack+1 ; Itrack = Itrack(Itrack <= size(X,1)) ;
    end            
end

% OKI
Y = X ;
Y(sum(S,2)>0,:) = NaN ;