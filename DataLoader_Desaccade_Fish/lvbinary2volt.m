% LVBINARY2VOLT.M  Convert binary data to voltage (or chair degrees)
%
%   volt = lvbinary2volt(binary);
%  chair = lvbinary2volt(binary, 1);
%
%  cjb

function [v] = lvbinary2volt(b, chflag)
  
  if(nargin ==1)
    chflag =0;
  end
  
  if(chflag)
    v = b ./((2^16)/360);
  else
    v = b ./((2^16)/20);
  end
  
