function [S] = JL_desaccader(X, iV, dV,dwin,method, da)
% iV = velocity histogram abscissa
% dV = vel. threshold
% dwin = time window

if nargin < 2,  iV = -150:150 ; end
if nargin < 3,  dV = 10 ; end
if nargin < 4,  dwin = 300 ; end
if nargin < 5, method = 2 ; end
if nargin < 6, da = 100 ; end
%%
tetaS = 2 ;
[n,mX] =  size(X) ;
%mX = 2 ;

acc= gradient(X')' ;

S = zeros(n,mX) ;
I = dwin+1:round(dwin/3):n-dwin-1 ; %I is the list of center of the moving window, so that it doesn't it the border and move in step of 1/3
if method==2
    dX = sign(medfilt1(X,30)) ; % A vector with the sign of the velocity
elseif method==1
    dX = sign([zeros(1,size(X,2)) ; X(2:end,:)-X(1:end-1,:)]) ; % A vector with the sign of the derivative
end

for j = 1:mX %It makes one colon at time... each colon is a different vector (Hor, ver, tor)
    % Find saccade for a direction (Hor or Ver or Tor)
    for i = 1:length(I)
        Itmp = I(i)-dwin:I(i)+dwin ;
        if ~(isinteger(Itmp(1))||islogical(Itmp(1)))
            Itmp=round(Itmp);
        end
            
        try
        h = hist(X(Itmp,j),iV) ;
        h(1) = 0; h(end) = 0 ;
        catch
            a=1;
        end
        m = find(h == max(h),1,'first') ;% Find the most frequent value
        
        if m == 1
           s = X(Itmp,j) > iV(m)+dV ;
        else
           if m == length(iV)
               s = X(Itmp,j) < iV(m)-dV ;
           else
                s = X(Itmp,j) < iV(m)-dV |  X(Itmp,j) > iV(m)+dV ; % Mark all the point within the window outside the most frequent value+/- treshold
           end
        end
        
        S(Itmp,j) =  S(Itmp,j) + s ; %Store the marks summing to previous marks for the same point
    end
    S(X(:,j) < min(iV),j) = S(X(:,j) < min(iV),j) + tetaS ; % Marks teta-times all the point which exceed the min or max range tested
    S(X(:,j) > max(iV),j) = S(X(:,j) > max(iV),j) + tetaS ;
    S(:,j) = ( S(:,j) >= tetaS );%| abs(acc(:,j)) > da)  ; % Keep only the point marked more than teta-times or which exceed a certain acc)

    S=(S & or([S(2:end); 0],[0; S(1:end-1)]))+0; % Get rid of single points
    % Soo, now go backward
    Itrack = find(not(S(1:end-1,j)) & S(2:end,j)) ; % Find all the beginnnings of a series of marked points
    Itrack = Itrack(Itrack < size(X,1))     ; %(exlude the last point)
    while(not(isempty(Itrack)))
        Itrack  = Itrack( dX(Itrack,j) == dX(Itrack+1,j)  ) ; % Go on till the derivative (i.e. acceleration) have always the same sign
        S(Itrack,j) = 1 ;
        Itrack = Itrack-1 ; Itrack = Itrack(Itrack > 0) ;
    end
    
    % Soo, now go forward
    Itrack = find(not(S(2:end,j)) & S(1:end-1,j))+1 ; % Same as above... the +1 is need as we start from S(2). Important: Is the one that is "negated", which determine the position respect to the original S vector
    Itrack = Itrack(Itrack > 1)     ;    
    while(not(isempty(Itrack)))
        Itrack  = Itrack( dX(Itrack,j) == dX(Itrack-1,j)  ) ;
        S(Itrack,j) = 1 ;
        Itrack = Itrack+1 ; Itrack = Itrack(Itrack <= size(X,1)) ;
    end            
end

% OKI
