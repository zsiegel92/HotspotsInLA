% clear all
% load('minDistFromTopK_rem_badgeocode.mat')


%% Filter Arrests by Descent
% specified_arrests_by_division{l}(:,9) contains the race ('DESCENT_CD') of
% each arrestee in division l

% descent_codes = unique(cell2mat(arrayfun(@(l) cell2mat(unique(specified_arrests_by_division{l}(:,9))'),(1:21),'UniformOutput',0))); %yields 'ABCFGHIJKOPSVWXZ';



%With 'A' (Asian? Arab?) as a separate category
% specified_arrests_by_division_race = specified_arrests_by_division;
% relevantDescents = 'ABHOW'; %Arab, Black, Hispanic, Other, White
% for l = 1:21
%     arrestsWithIrrelevantDescents =  find(~ismember(cell2mat(specified_arrests_by_division{l}(:,9)),relevantDescents));
%     specified_arrests_by_division_race{l}(arrestsWithIrrelevantDescents,9) =  {'O'};
% end
% clear arrestsWithIrrelevantDescents;
% save('minDistFromTopK_remBadgeocode_descentCompress_withA.mat')
% 


%Without Arab as a separate category (included in 'Other')
specified_arrests_by_division_race = specified_arrests_by_division;
relevantDescents = 'BHOW'; %Arab, Black, Hispanic, Other, White


for l = 1:21
    arrestsWithIrrelevantDescents =  find(~ismember(cell2mat(specified_arrests_by_division{l}(:,9)),relevantDescents));
    specified_arrests_by_division_race{l}(arrestsWithIrrelevantDescents,9) =  {'O'};
end
clear arrestsWithIrrelevantDescents;
clear specified_arrests_by_division;

save('Process_Arrests/Mat_Files/Run2/minDistFromTopK_remBadgeocode_descentCompress.mat')

