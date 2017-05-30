%Failed attempt:
% coords2 = cellfun(@(x)strsplit(x(2:end-1),{';',' '}), coordstrings(1:100),'UniformOutput',0);
% coords2 = str2num(coords2);
%
% coords2 = cellfun(@(x)str2num(strsplit(x(2:end-1),{';',' '})), coordstrings);

year = 2015;
filename = 'Reported_Crimes_2012-2015.csv';
Reports_Table = readtable(filename);
reps = table2cell(Reports_Table);
coordstrings = reps(:,14);

coords = zeros(size(reps,1),2);
badcoords = [];

coords(1,:) = cellfun(@str2num,strsplit(coordstrings{1}(2:end-1),{ ';',' '}));
minlat = coords(1,1);
maxlat = coords(1,1);
minlon = coords(1,2);
maxlon = coords(1,2);

for i = 2:size(reps,1)
    coordi=    cellfun(@str2num,strsplit(coordstrings{i}(2:end-1),{ ';',' '}),'UniformOutput',0);
    
    if (length(coordi)<2)
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

save('reported_load.mat');