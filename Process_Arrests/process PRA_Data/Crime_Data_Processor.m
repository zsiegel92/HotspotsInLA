 %charge codes Caution: charges are not uniformly recorded.
 %Burglary: (CA PC 459)
 %Car Theft (CA PC 487(d)(1))
 %In-Car Theft (CA PC 459 second-degree burglary)

%Create .mat data files
%[num,txt,raw]=xlsread('HERNANDEZ 2010 ARRESTS.SLAPDS.xlsx');
%save('2010_data.mat')
% clear all
% [num,txt,raw]=xlsread('HERNANDEZ 2011 ARRESTS.SLAPDS.xlsx');
% save('2011_data.mat')
% clear all
% [num,txt,raw]=xlsread('HERNANDEZ 2012 ARRESTS.SLAPDS.xlsx');
% save('2012_data.mat')
% clear all
% [num,txt,raw]=xlsread('HERNANDEZ 2013 ARRESTS.SLAPDS.xlsx');
% save('2013_data.mat')
% clear all
% [num,txt,raw]=xlsread('HERNANDEZ 2014 ARRESTS.SLAPDS.xlsx');
% save('2014_data.mat')
% clear all
% [num,txt,raw]=xlsread('HERNANDEZ 2015 ARRESTS.SLAPDS.xlsx');
% save('2015_data.mat')
% clear all
%


% load('2010_data.mat')
% load('2011_data.mat')
% load('2012_data.mat')
% load('2013_data.mat')
% load('2014_data.mat')
 load('2015_data.mat')
chargesNames = raw(:,7);
chargesNames = chargesNames(6:end);
chargesNamesIsNans =cellfun(@(V) any(isnan(V)), chargesNames);


charges = raw(:,5);
charges = charges(6:end);
chargesIsNans =cellfun(@(V) any(isnan(V)), charges);

uniqueCount = 0;
unknownChargeCount = 0;
uniqueCounts =[];
uniqueEl = {};
uniqueEl(1,1) = charges(1);
uniqueEl(2,1) = chargesNames(1);
uniqueCount =1;
uniqueCounts = [1];
for i = 2:size(charges,1)
    if (chargesIsNans(i)==0)
        [Lia,LocB]=ismember(charges(i),uniqueEl(1,:));
        if(Lia==1)
            uniqueCounts(LocB) = uniqueCounts(LocB)+1;
        else
            uniqueCount = uniqueCount +1;
            uniqueEl(1,uniqueCount) = charges(i);
            if(chargesNamesIsNans(i) ==0)
                uniqueEl(2,uniqueCount)= chargesNames(i);
            else
                uniqueEl(2,uniqueCount)={['Unknown',num2str(unknownChargeCount)]};
                unknownChargeCount = unknownChargeCount +1;
            end
            uniqueCounts = [uniqueCounts,1];
        end
    end
end
clear uniqueCount;
clear i;
clear Lia;
clear LocB;
clear chargesIsNans;
clear chargesNamesIsNans;
[uniqueCounts,inds] = sort(uniqueCounts);
uniqueEl = uniqueEl(:,inds);

uniqueEl = uniqueEl(:,end:-1:1);
uniqueCounts = uniqueCounts(end:-1:1);

for i = 1:length(uniqueCounts)
    uniqueEl(3,i) = {uniqueCounts(i)};
end

uniqueEl = uniqueEl';

filename = '2015_info.csv';
firstrow = {'Crime Code', 'Crime Name', 'Number of Instances'};
fid = fopen(filename,'w');
fprintf(fid,'%s; %s; %s\n',firstrow{1,:});
for i = 1:size(uniqueEl,1)
    fprintf(fid,'%s;%s;%f\n',uniqueEl{i,:});
end
fclose(fid);