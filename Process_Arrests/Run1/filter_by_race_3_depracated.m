clear all
load('minDistFromTopK_rem_badgeocode.mat')
% or (depracate):
% load('minDistFromTopK.mat');


%% Filter Arrests by Descent
% specified_arrests_by_division{l}(:,9) contains the race ('DESCENT_CD') of
% each arrestee in division l

specified_arrests_by_division_race = cell(21,1);

% descent_codes = unique(cell2mat(arrayfun(@(l) cell2mat(unique(specified_arrests_by_division{l}(:,9))'),(1:21),'UniformOutput',0)));
% descent_codes = 'ABCFGHIJKOPSVWXZ';
relevantDescents = 'ABHOW'; %Arab, Black, Hispanic, Other, White


for l = 1:12
    arrestsWithRelevantDescents =  find(ismember(cell2mat(specified_arrests_by_division{l}(:,9)),relevantDescents));
    specified_arrests_by_division_race{l} =  specified_arrests_by_division{l}(arrestsWithRelevantDescents,:);
    
    coordsByDiv{l}= coordsByDiv{l}(arrestsWithRelevantDescents,:);
    
    closestRealDist{l}=closestRealDist{l}(arrestsWithRelevantDescents,:);
    closestToWhich{l}=closestToWhich{l}(arrestsWithRelevantDescents,:);
end
clear arrestsWithRelevantDescents;
clear specified_arrests_by_division;

save('minDistFromTopK_remBadgeocode_filterDescent.mat')
%% Compare distance to nearest "hotspot" by race

% descent_dists = cell(length(descent_codes),1);

