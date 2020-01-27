function [segments, F, Fc, Fc_smoothed, Fc3, Fc3_smoothed] = by_hand_ROIs(varargin)
%BY_HAND_ROIS Extract calcium imaging data using by-hand ROIs
%
% OPTIONAL INPUTS
%   data - Can either by an mXnXp matrix or a string. If a matrix, the
%       columns and rows correspond with the columns and rows of the movie
%       (m = height, n = width) and p is the length of the movie in frames.
%       If a string, it is the filepath of a .tif file containing the data.
%       If not provided, a .tif file is opened from a GUI.
%
% PARAMETERS
%   noise_offset (0) - The offset to shift the matrix by before applying
%       the filters. 37 corresponds with the measured electrical noise on
%       the Dombeck Lab resonance scanner, measured by Dr. Mark Sheffield.
%
% OUTPUTS
%   segments - The spatial segments selected
%   F - The raw F trace, normalized such that if the image within the
%       regions of the segment that are non-zero have a mean intensity of
%       1, F is 1
%   Fc - The normalized dF/F-trace, using the 8th percentile method
%   Fc3 - The significant transients, using the duration method
%
% Jason R. Climer, PhD (jason.r.climer@gmail.com), updated 11 April 2017

% Handle data
noise_offset = [];F = [];Fc = [];Fc3 = [];scale_window = [];
Fc_smoothed = []; Fc3_smoothed = []; 

[data,varargin] = parse_data(0,varargin{:});

ip = inputParser;
ip.addParameter('noise_offset',0);
ip.addParameter('scale_window',250);% when the baseline is not flat, change the scale window to smalller value, the scale window MUST be bigger than the longest transient
ip.parse(varargin{:});
for j=fields(ip.Results)'
    eval([j{1} '=ip.Results.' j{1} ';']);
end

mi = mean_image(data);

fig = figure;
imagesc(mi);%colormap gray;
axis off equal;
caxis(caxis);
apply_button = uicontrol('Style', 'pushbutton', 'String', 'Apply',...
    'Position', [20 20 50 20],'UserData',0 ...
    ,'Callback',...
    @(varargin)complete_ROIs...
    );

delete_roi_button = uicontrol('Style', 'pushbutton', 'String', 'Delete ROI',...
    'Position', [80 20 100 20],'UserData',1 ...
    );

delete_roi_callback = @(varargin)set(delete_roi_button,'UserData',0);
set(delete_roi_button,'Callback',@(a,b)delete_roi_callback(a,b,handles));

nout = 0;
segments = zeros(size(mi));
colors = lines(size(segments,3));
hold on;

while apply_button.isvalid
    temp = roipoly;
    nout = nout+1;
    if apply_button.isvalid
        segments(:,:,nout) = temp;
        
        if get(delete_roi_button,'UserData')
            if nout>size(colors,1)
                segments = cat(3,segments,zeros(size(segments)));
                colors = lines(size(segments,3));
            end
            contour(segments(:,:,nout),'Color',colors(nout,:),'LineWidth',2);
            pos = regionprops(segments(:,:,nout),'Centroid');
            text(pos.Centroid(1),pos.Centroid(2),num2str(nout),'Color',[0 0 0],'FontWeight','bold');
            text(pos.Centroid(1),pos.Centroid(2),num2str(nout),'Color',colors(nout,:));
        else
            set(handles.delete_roi_button,'UserData',1);
        end
    end
end

    function [] = complete_ROIs(varargin)
        segments = segments(:,:,1:nout);
        if ischar(data)
            data = parse_data(1,data);
        end
        data = reshape(data,[size(data,1)*size(data,2) size(data,3)]);
        
        F = zeros(size(data,2),nout);
        
        for h = 1:nout
            F(:,h) = apply_filter(data(segments(:,:,h)==1,:)-noise_offset,ones(sum(sum(segments(:,:,h))),1));
        end
        
        Fc = FtoFc(F,scale_window);
        Fc3=FctoFc3(Fc,upperbase(Fc,true));
               
        for i=1:size(Fc,2)
            Fc_smoothed(:,i) = smooth(Fc(:,i),5);
            %Fc3_smoothed(:,i)=FctoFc3(Fc_smoothed(:,i),upperbase(Fc_smoothed(:,i),true)); % try this
        end
        Fc3_smoothed=FctoFc3(Fc_smoothed,upperbase(Fc_smoothed,true)); 
        close(fig);
    end
end
