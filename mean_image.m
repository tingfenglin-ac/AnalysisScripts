function [out,n] = mean_image(filepaths,varargin)
   ip = inputParser;
   ip.KeepUnmatched = true;
   ip.addParameter('start_ind',1);
   ip.addParameter('end_ind',[]);
   ip.addParameter('frame_skip',1);
   ip.parse(varargin{:});
   start_ind = ip.Results.start_ind;
   end_ind = ip.Results.end_ind;
   frame_skip = ip.Results.frame_skip;
   
   if ismember('start_ind','UsingDefaults')
        i=find(cellfun(@(x)isequal(x,'start_ind'),varargin));
        varargin = [varargin(1:i-1);varargin(i+1:end)];
   end
   if ismember('end_ind','UsingDefaults')
        i=find(cellfun(@(x)isequal(x,'end_ind'),varargin));
        varargin = [varargin(1:i-1);varargin(i+1:end)];
   end
   
   [dta,nframes] = load_tiffs_fast(filepaths,'end_ind',1);
   if isempty(end_ind), end_ind=sum(nframes); end
   
   width = size(dta,2);
   height = size(dta,1);
   
   maxbuff = memory;
   maxbuff = 2^(nextpow2(maxbuff.MaxPossibleArrayBytes/10/8/width/height*frame_skip)-1);
   out = zeros(size(dta));
   n=out;
   for i=1:ceil((end_ind-start_ind+1)/maxbuff)
      dta = double(load_tiffs_fast(filepaths,varargin{:},'start_ind',(i-1)*maxbuff+start_ind,'end_ind',min(i*maxbuff+start_ind-1,end_ind-mod(end_ind-start_ind,frame_skip))));
      out = out+sum(dta,3);
      n = n + sum(dta~=0,3);
      clear dta;
   end
   out = out./n;
   out(n==0) = 0;
end