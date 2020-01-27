function [choice]=L_R_analysis()
answer = questdlg('Which eye would you like to analyze?', ...
    'Choice of analysis', ...
    'Left','Right','Both','Both');
% Handle response
switch answer
    case 'Left'
        choice = 1;
    case 'Right'
        choice = 2;
    case 'Both'
        choice = 1:2;
end