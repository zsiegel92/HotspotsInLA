 %charge codes Caution: charges are not uniformly recorded.
 %Burglary: (CA PC 459)
 %Car Theft (CA PC 487(d)(1))
 %In-Car Theft (CA PC 459 second-degree burglary)

filename = 'ARR_2015.csv';
Arrests_Table = readtable(filename);
arrests = table2cell(Arrests_Table);
colNames = Arrests_Table.Properties.VariableNames;
clear Arrests_Table;

coordstrings = arrests(:,17);

coords = zeros(size(arrests,1),2);
badcoords = [];

coords(1,:) = cellfun(@str2num,strsplit(coordstrings{1}(2:end-1),{ ';',' '}));

minlat = coords(1,1);
maxlat = coords(1,1);
minlon = coords(1,2);
maxlon = coords(1,2);

for i = 2:size(arrests,1)
    coordi=    cellfun(@str2num,strsplit(coordstrings{i}(2:end-1),{ ';',' '}),'UniformOutput',0);
    
    if (length(coordi)<2)
        coordi = [0,0]';
        badcoords = [badcoords,i];
    elseif ((length(coordi{1})<1) || (length(coordi{2})<1))
        coordi = [0,0]';
        badcoords = [badcoords,i];
    else
        coordi = [coordi{1},coordi{2}];
        if (all(coordi)==0)
            badcoords = [badcoords,i];
        else
            if (coordi(1)<minlat)
                minlat = coordi(1);
            elseif (coordi(1) > maxlat)
                maxlat = coordi(1);
            end
            
            if (coordi(2)<minlon)
                minlon = coordi(2);
            elseif (coordi(2)>maxlon)
                maxlon = coordi(2);
            end
        end
    end
    coords(i,:) = coordi;
end


clear coordi;
clear coordstrings;
clear filename;
clear i;



save('loaded_arrests.mat');

% load('2015_arrests_geocoded.mat')
% 
% chargesNames = raw(:,7);
% chargesNames = chargesNames(6:end);
% chargesNamesIsNans =cellfun(@(V) any(isnan(V)), chargesNames);
% 
% 
% charges = raw(:,5);
% charges = charges(6:end);
% chargesIsNans =cellfun(@(V) any(isnan(V)), charges);
% 
% uniqueCount = 0;
% unknownChargeCount = 0;
% uniqueCounts =[];
% uniqueEl = {};
% uniqueEl(1,1) = charges(1);
% uniqueEl(2,1) = chargesNames(1);
% uniqueCount =1;
% uniqueCounts = [1];
% for i = 2:size(charges,1)
%     if (chargesIsNans(i)==0)
%         [Lia,LocB]=ismember(charges(i),uniqueEl(1,:));
%         if(Lia==1)
%             uniqueCounts(LocB) = uniqueCounts(LocB)+1;
%         else
%             uniqueCount = uniqueCount +1;
%             uniqueEl(1,uniqueCount) = charges(i);
%             if(chargesNamesIsNans(i) ==0)
%                 uniqueEl(2,uniqueCount)= chargesNames(i);
%             else
%                 uniqueEl(2,uniqueCount)={['Unknown',num2str(unknownChargeCount)]};
%                 unknownChargeCount = unknownChargeCount +1;
%             end
%             uniqueCounts = [uniqueCounts,1];
%         end
%     end
% end
% clear uniqueCount;
% clear i;
% clear Lia;
% clear LocB;
% clear chargesIsNans;
% clear chargesNamesIsNans;
% [uniqueCounts,inds] = sort(uniqueCounts);
% uniqueEl = uniqueEl(:,inds);
% 
% uniqueEl = uniqueEl(:,end:-1:1);
% uniqueCounts = uniqueCounts(end:-1:1);
% 
% for i = 1:length(uniqueCounts)
%     uniqueEl(3,i) = {uniqueCounts(i)};
% end
% 
% uniqueEl = uniqueEl';
% 
% filename = '2015_info.csv';
% firstrow = {'Crime Code', 'Crime Name', 'Number of Instances'};
% fid = fopen(filename,'w');
% fprintf(fid,'%s; %s; %s\n',firstrow{1,:});
% for i = 1:size(uniqueEl,1)
%     fprintf(fid,'%s;%s;%f\n',uniqueEl{i,:});
% end
% fclose(fid);