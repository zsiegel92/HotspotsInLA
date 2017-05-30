%  load('/Users/Zach/Drive/Stop LAPD Spying/Predpol Project/Code/Process_Reports/Mat_Files/Run2/division_breakdown.mat')

%% Grab 2015 dates only
dates = cell(size(reports_by_division));
for l = 1:21
    disp(l)
    dates{l} = reports_by_division{l}(:,1);
end
%  save('processDump/Only_crimeType_andStatus_only2015_justdates.mat', 'dates')

%%Turn dates into datenums
for l = 1:21
    disp(l)
    dates{l} = datenum(dates{l},'mm/dd/yyyy');
end
%  save('processDump/Only_crimeType_andStatus_only2015_justdateNums.mat', 'dates')


firstDay = datenum('01/01/2015');
lastDay = datenum('01/01/2016');
for l = 1:21
    disp(l)
    dates{l} = find((dates{l}>=firstDay).*(dates{l}<lastDay));
    reports_by_division{l} = reports_by_division{l}(dates{l},[1,8,9,10]);
end

save('create_stats_to_compare/Run2/processDump/Only_crimeType_andStatus_only2015.mat','reports_by_division');
