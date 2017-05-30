  load('create_stats_to_compare/Run2/processDump/Only_crimeType_andStatus_only2015.mat');
%% Count Predpol Driving Crimes in 2015 (and total 2015)
%{
% NOTE FROM MORGAN:
%     310 BURGLARY   56369
%     320 BURGLARY; ATTEMPTED   4838
%     330 BURGLARY FROM VEHICLE   57291
%     331 THEFT FROM MOTOR VEHICLE - GRAND ($400 AND OVER)   11067
%     410 BURGLARY FROM VEHICLE; ATTEMPTED   1117
%     420 THEFT FROM MOTOR VEHICLE - PETTY ($950.01 & OVER) THEFT FROM MOTOR VEHICLE - PETTY (UNDER $400) 31760
%     421 THEFT FROM MOTOR VEHICLE - ATTEMPT   468
%     510 VEHICLE - STOLEN 56687
%}


tot2015Reports_byDivision = arrayfun(@(l) size(reports_by_division{l},1),1:21);
drivers = [310,320,330,331,410,420,421,510];
tot2015PredpolReports_byDivision = arrayfun(@(l) nnz(ismember(cell2mat(reports_by_division{l}(:,2)),drivers)),1:21);
save('create_stats_to_compare/Run2/processDump/Crime_stats_by_Division.mat','tot2015Reports_byDivision','tot2015PredpolReports_byDivision');