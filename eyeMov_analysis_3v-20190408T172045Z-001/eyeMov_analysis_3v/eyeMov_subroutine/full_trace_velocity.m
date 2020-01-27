addpath 'H:\eyeMov_analysis_3v\eyeMov_subroutine';
FigHandle = figure('Position', [0, 0, 1000, 800]);
i_length=2;
fish=[2 3 0 1];%0=wt 1=bel
tit=cell(2);%title
xA=[0 60];
xB=[0 60];
xC=[48 52];
xscale=[xA xB xC];
yaxis=[-20 40;-5 10];
grating_frq=2; %how many grating per minute
xBAR=0.3;%label position from left
yBAR=0.05;%label position from top
ylebel=[38 18]; %ylabel position from the median of raw trace
Nproto=[1]; %which picture need protocol
scaleBAR=[2]; %which picture need scale bar


i=1
subplot(i_length,1,i);
raw_trace(i,i_length,fish(i),tit{i},xscale(i*2-1:i*2),yaxis(i,:),grating_frq,xBAR,yBAR,ylebel(i),Nproto,scaleBAR);
if any(Nproto(:) == i);
    text_x=[2.5 10 20]-0.2;
    text_label={'Dark','Stim','Dark'}
    text_high=ylebel(i)+3;
    text(text_x,text_high*ones(1,length(text_x)),text_label);
end

i=2
subplot(i_length,1,i);
Vslop(i,i_length,fish(i),tit{i},xscale(i*2-1:i*2),yaxis(i,:),grating_frq,xBAR,yBAR,ylebel(i),Nproto,scaleBAR);



set(gcf,'Color',[1 1 1]);