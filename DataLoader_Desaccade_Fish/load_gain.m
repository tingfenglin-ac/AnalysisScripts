function [gain]=load_gain(gain_file);
% load the gain file and return the gain in a cell array made of three cell
% for right eye, left eye, head, leaving empty the cell that had no gain
% from the file

fid  = fopen(gain_file, 'r+');
    gain=cell(3,1);
    while 1
        tline = fgetl(fid);
        if ~ischar(tline), break, end
        if length(tline) <2, break, end

        g = tline;
        %  get the first word, which is the variable name.
        whitespaces = findstr(g, ' ');
        % the last character of the variable name indicates the eye or head.
        ch = g(whitespaces(1)-1);
        p1 = findstr(g, '[');
        p2 = findstr(g, ']');
        thegain = sscanf(g((p1+1):(p2-1)), '%f');

        if(strcmp(ch, 'r'))
            gain{1} = thegain';
        elseif(strcmp(ch, 'l'))
            gain{2} = thegain';
        elseif(strcmp(ch, 'h'))
            gain{3} = thegain';
        else
            error('oh my god, I am so confused!')
        end
    end
    fclose(fid);
