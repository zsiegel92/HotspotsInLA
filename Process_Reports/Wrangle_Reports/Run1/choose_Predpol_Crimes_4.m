% load('division_breakdown.mat')

% NOTE FROM MORGAN:
%     310 BURGLARY   56369
%     320 BURGLARY; ATTEMPTED   4838
%     330 BURGLARY FROM VEHICLE   57291
%     331 THEFT FROM MOTOR VEHICLE - GRAND ($400 AND OVER)   11067
%     410 BURGLARY FROM VEHICLE; ATTEMPTED   1117
%     420 THEFT FROM MOTOR VEHICLE - PETTY ($950.01 & OVER) THEFT FROM MOTOR VEHICLE - PETTY (UNDER $400) 31760
%     421 THEFT FROM MOTOR VEHICLE - ATTEMPT   468
%     510 VEHICLE - STOLEN 56687
%     




drivers = [310,320,330,331]; %First run
%BURGLARY
%BURGLARY; ATTEMPTED
%BURGLARY FROM VEHICLE
%THEFT FROM MOTOR VEHICLE - GRAND ($400 AND OVER)

driving_crimes_by_division = cell(size(reports_by_division));

for i = 1:size(reports_by_division,1) %21, for all divisions
    crimeCodes = reports_by_division{i}(:,8);
    crimeCodes=cell2mat(crimeCodes);
    
    crimeCodes = ismember(crimeCodes,drivers);
    
    driving_crimes_by_division{i} = reports_by_division{i}(crimeCodes,:);
end

clear a
clear crimeCodes
clear ans
clear i
clear reports_by_division

save('driving_crimes_by_division.mat');


