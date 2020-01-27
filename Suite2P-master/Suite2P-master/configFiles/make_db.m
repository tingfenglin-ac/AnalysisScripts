i = 0;

% example for datasets without folder structure
i = i+1;
db(i).mouse_name    = 'GCaMP 20190820';
db(i).date          = '820';
db(i).expts         = []; % leave empty, or specify subolders as numbers
db(i).diameter      = 12;
db(i).RootDir       = 'D:\2pdata\Ting\GCaMP 20190820\820\820_000_004_OUT'; % specify full path to tiffs here

% i = i+1;
% db(i).mouse_name    = 'GCaMP 20190820';
% db(i).date          = '820';
% db(i).expts         = [1];
% db(i).nchannels     = 1;
% db(i).gchannel      = 1; 
% db(i).nplanes       = 1; 
% db(i).expred        = [4];
% db(i).nchannels_red = 2;
% db(i).comments      = 'multi p file: block 0,5,6';

% i = i+1;
% db(i).mouse_name    = 'M150329_MP009';
% db(i).date          = '2015-04-29';
% db(i).expts         = [4 5 6];
% db(i).nchannels     = 1;
% db(i).gchannel      = 1; 
% db(i).nplanes       = 1; 
% db(i).expred        = [3];
% db(i).nchannels_red = 2;
% db(i).comments      = 'multi p file: block 4,5,6';
% 
% i = i+1;
% db(i).mouse_name    = 'M150331_MP011';
% db(i).date          = '2015-04-29';
% db(i).expts         = [3 4 6];
% db(i).nchannels     = 1;
% db(i).gchannel      = 1; 
% db(i).nplanes       = 1; 
% db(i).expred        = [2];
% db(i).nchannels_red = 2;
% db(i).comments      = 'multi p file: block 4,3,6';
% 
% i = i+1;
% db(i).mouse_name    = 'M150422_MP012';
% db(i).date          = '2015-04-28';
% db(i).expts         = [3 4 5];
% db(i).nchannels     = 1;
% db(i).gchannel      = 1; 
% db(i).nplanes       = 1; 
% db(i).expred        = [2];
% db(i).nchannels_red = 2;
% db(i).comments      = 'multi p file: block 3,4,5';
% 
% i = i+1;
% db(i).mouse_name    = 'M150422_MP012';
% db(i).date          = '2015-05-04';
% db(i).expts         = [2 8];
% db(i).nchannels     = 1;
% db(i).gchannel      = 1; 
% db(i).nplanes       = 1; 
% db(i).comments      = 'single p file: block 2';
% 
% i = i+1;
% db(i).mouse_name    = 'M150422_MP012';
% db(i).date          = '2015-05-20';
% db(i).expts         = [4];
% db(i).nchannels     = 1;
% db(i).gchannel      = 1; 
% db(i).nplanes       = 1; 
% db(i).expred        = [2];
% db(i).nchannels_red = 2;
% db(i).comments      = 'single p file: block 4';
% 
% i = i+1;
% db(i).mouse_name    = 'M150422_MP015';
% db(i).date          = '2015-05-09';
% db(i).expts         = [2 3];
% db(i).nchannels     = 1;
% db(i).gchannel      = 1; 
% db(i).nplanes       = 1;
% db(i).expred        = [1];
% db(i).nchannels_red = 2;
% db(i).comments      = 'single p file, block 3';
% 
% % i = i+1;
% % db(i).mouse_name    = 'M150808_MP016';
% % db(i).date          = '2015-08-24';
% % db(i).expts         = [4];
% % db(i).nchannels     = 1;
% % db(i).gchannel      = 1; 
% % db(i).nplanes       = 1; 
% % db(i).expred        = [3];
% % db(i).nchannels_red = 2;
% % db(i).comments      = 'single p file, block 4, zoom 20';
% 
% i = i+1;
% db(i).mouse_name    = 'M150423_MP014';
% db(i).date          = '2015-06-16';
% db(i).expts         = [8];
% db(i).nchannels     = 1;
% db(i).gchannel      = 1; 
% db(i).nplanes       = 1; 
% db(i).expred        = [4];
% db(i).nchannels_red = 2;
% db(i).comments      = 'single p file, block 8 + .3Hz stimulus';
% 
% i = i+1;
% db(i).mouse_name    = 'M150422_MP015';
% db(i).date          = '2015-05-01';
% db(i).expts         = [5 6];
% db(i).nchannels     = 1;
% db(i).gchannel      = 1; 
% db(i).nplanes       = 1;
% db(i).expred        = [];
% db(i).nchannels_red = 2;
% db(i).comments      = 'only 1Hz vs 10Hz';
% 
% i = i+1;
% db(i).mouse_name    = 'M150331_MP011';
% db(i).date          = '2015-05-02';
% db(i).expts         = [4 7 8 10 11 12];
% db(i).nchannels     = 1;
% db(i).gchannel      = 1; 
% db(i).nplanes       = 1;
% db(i).expred        = [3];
% db(i).nchannels_red = 2;
% db(i).comments      = 'first three running, last three not running';
% 
% i = i+1;
% db(i).mouse_name    = 'M150422_MP015';
% db(i).date          = '2015-04-28';
% db(i).expts         = [3 4 5];
% db(i).nchannels     = 1;
% db(i).gchannel      = 1; 
% db(i).nplanes       = 1;
% db(i).expred        = [];
% db(i).nchannels_red = 2;
% db(i).comments      = 'might not be enough signal in this one!';
% 
% i = i+1;
% db(i).mouse_name    = 'M150808_MP016';
% db(i).date          = '2015-08-24';
% db(i).expts         = [4];
% db(i).nchannels     = 1;
% db(i).gchannel      = 1; 
% db(i).nplanes       = 1;
% db(i).expred        = 3;
% db(i).nchannels_red = 2;
% db(i).comments      = 'zoom 20x recording';
