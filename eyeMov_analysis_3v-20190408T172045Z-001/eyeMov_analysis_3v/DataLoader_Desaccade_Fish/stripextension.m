% strip extension from filename, including the '.'.
function [stripped extension] = stripextension(str)

dotlocs = findstr(str, '.');
extension = '';
if(isempty(dotlocs))
    stripped = str;
else
    stripped = str(1:(dotlocs(end)-1));
    e = (dotlocs(end));
    extension = str(e:end);
end

