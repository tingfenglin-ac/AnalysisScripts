function [Stim_signal,Stim_idx]=Edge2Signal(ArrayL,Rise,Fall);
%ArrayL is the lenghth of the signal
%Rise is index of rising edge
%Fall is index of falling edge

Imat = repmat((1:ArrayL)',1,length(Rise));
Rmat = repmat(Rise',ArrayL,1);
Fmat = repmat(Fall',ArrayL,1);
Stim_signal = sum(Imat>Rmat & Imat<Fmat,2); %signal of stimulus
Stim_idx = find(Stim_signal==1); %index of stimulus
end