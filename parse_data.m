function [data, varargin] = parse_data(loadme,varargin)

if exist('loadme','var')&&~(isequal(loadme,0)||isequal(loadme,1))
          varargin = [{loadme} varargin(:)'];
          loadme = 1;          
end

% Handle data
if numel(varargin)>0&&(~ischar(varargin{1})||exist(varargin{1},'file'))
    data = varargin{1};
    varargin = varargin(2:end);
else
    data = [];
end

% Handle data
if isempty(data)
    data = {};
    [data{2},data{1}] = uigetfile('*.tif', 'Pick your data file');
    data = cat(2,data{:});
end

if loadme&&ischar(data)
    data=load_tiffs_fast(data);
end
end