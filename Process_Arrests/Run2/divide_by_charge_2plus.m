function specified_arrests = divide_by_charge(arrests,specCharges)

crimeCodes = arrests(:,13); %colNames{13} = 'CHARGE'

crimeCodes = ismember(crimeCodes,specCharges);

specified_arrests = arrests(crimeCodes,:);


clear crimeCodes;

save('specified_arrests.mat');

end