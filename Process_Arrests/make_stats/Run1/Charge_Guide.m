%load('loaded_arrests.mat');
% PRE:
%arrests is a cell array whose 13th column is charges

%{
Columns 1 through 4

    'ARSTDATE'    'TIME'    'RPT_ID'    'AREA'

  Columns 5 through 8

    'AREA_DESC'    'RD'    'AGE'    'SEX_CD'

  Columns 9 through 11

    'DESCENT_CD'    'CHRG_GRP_CD'    'GRP_DESC'

  Columns 12 through 14

    'ARST_TYP_CD'    'CHARGE'    'CHRG_DESC'

  Columns 15 through 17

    'LOCATION'    'CRSST'    'Location1'

  Column 18

    'Var18'
%}
function uniqueInfo = Charge_Guide(arrests,colNames)

% [uniqueCharges,firstIndices,translator] = unique(arrests(:,13));
[uniqueCharges,firstIndices,translator] = unique(arrests(:,13));

arrests(find(cellfun(@isnan,arrests(:,10))),10)={[]}; %change {[NaN]} CHRG_GRP_CD to {[]};

total_GrpCd=cellfun(@(i) [unique([arrests{find(translator==i),10}])],num2cell((1:length(firstIndices))'),'UniformOutput',0);
total_GrpDesc = cellfun(@(i) unique(arrests(find(translator==i),11)),num2cell((1:length(firstIndices))'),'UniformOutput',0);
total_ArstTyp = cellfun(@(i) unique(arrests(find(translator==i),12)),num2cell((1:length(firstIndices))'),'UniformOutput',0);
total_ChgDesc = cellfun(@(i) unique(arrests(find(translator==i),14)),num2cell((1:length(firstIndices))'),'UniformOutput',0);

for i = 1:size(total_GrpDesc,1)
    if (length(total_GrpDesc{i})>1)
        total_GrpDesc{i}(find(strcmp('',total_GrpDesc{i})))=[];
    end
    if (length(total_ChgDesc{i})>1)
        total_ChgDesc{i}(find(strcmp('',total_ChgDesc{i})))=[];
    end
end


total_GrpDesc = cellfun(@(x) [sprintf('%s; ',x{1:end-1,1}),x{end}],total_GrpDesc,'UniformOutput',0);
maxNumberBlank_ArstTyp = max(cell2mat(cellfun(@(x) sum(cell2mat(cellfun(@(y) y=='',x,'UniformOutput',0))),total_ArstTyp,'UniformOutput',0))); %Should = 0
total_ArstTyp = cellfun(@(x) [sprintf('%s; ',x{1:end-1,1}),x{end}],total_ArstTyp,'UniformOutput',0);
total_ChgDesc = cellfun(@(x) [sprintf('%s; ',x{1:end-1,1}),x{end}],total_ChgDesc,'UniformOutput',0);
total_GrpCd = cellfun(@(x) arrayfun(@num2str,x,'UniformOutput',0),total_GrpCd,'UniformOutput',0);
total_GrpCd = cellfun(@(x) strjoin(x,'; '),total_GrpCd,'UniformOutput',0);

uniqueInfo = [uniqueCharges,total_GrpCd,total_GrpDesc,total_ArstTyp,total_ChgDesc];


hist = arrayfun(@(x) nnz(translator == x),(1:length(firstIndices))');
uniqueInfo = [uniqueInfo,cellfun(@num2str,num2cell(hist),'UniformOutput',0);];

[~,inds] = sort(hist);
uniqueInfo = uniqueInfo(inds(end:-1:1),:);

uniqueInfo = uniqueInfo';


formatspecHeader = '%s,%s,%s,%s,%s,%s\n';
formatspec = '%s,%s,%s,%s,%s,%s\n';
header = colNames([13,10,11,12,14]);
header = [header,'Number_Occurrences'];

filename = 'arrest_charge_guide.csv';
fid = fopen(filename,'w');
fprintf(fid,formatspecHeader,header{1,:});
fprintf(fid,formatspec,uniqueInfo{:,:});
fclose(fid);
uniqueInfo = uniqueInfo';

save('uniqueInfo.mat','uniqueInfo','colNames');



end