function [spExtremeIdx]=SPextremesfinder(saccExtremeIdx,indexSlowPhases)

spExtremeIdx=indexSlowPhases([find(indexSlowPhases<saccExtremeIdx(1,1),1,'first'),find(indexSlowPhases<saccExtremeIdx(1,1),1,'last')])'; %first SP
%spExtremeIdx=[spExtremeIdx;[saccExtremeIdx(1:end-1,2)+1,saccExtremeIdx(2:end,1)-1]];
spExtremeIdx=[spExtremeIdx;[saccExtremeIdx(1:end-1,2),saccExtremeIdx(2:end,1)]];
spExtremeIdx=[spExtremeIdx;indexSlowPhases([find(indexSlowPhases>saccExtremeIdx(end,2),1,'first'),find(indexSlowPhases>saccExtremeIdx(end,2),1,'last')])']; %last SP 

end
