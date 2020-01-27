function [DATA]=FillUP2nan(DATA)
NoNAN=find(~isnan(DATA))
for i=1:length(DATA)
    if isnan(DATA(i))
        if sum(~isnan(DATA(i:end)))
        DATA(i)=DATA(min(NoNAN(NoNAN>i)));
        end
    end
end