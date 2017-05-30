% load('minDistFromTopK_remBadgeocode_descentCompress.mat')
% load('minDistFromTopK_remBadgeocode_descentCompress_withArab.mat')


%% Count Number of Arrests with Each Descent Code
%Count number of arrests with each descent code

descent_codes = unique(cell2mat(arrayfun(@(l) cell2mat(unique(specified_arrests_by_division_race{l}(:,9))'),(1:21),'UniformOutput',0)));
descent_codes_counter = zeros(1,length(descent_codes));

for l = 1:21
    descs = cell2mat(specified_arrests_by_division_race{l}(:,9));
    descent_codes_counter = descent_codes_counter + arrayfun(@(j) nnz(descs == descent_codes(j)),(1:length(descent_codes)));
end
clear descs;

disp(['Descent Codes: ', descent_codes]);
for j = 1:length(descent_codes)
    disp([num2str(descent_codes_counter(j)), ' instances of ', descent_codes(j)]);
end

%% Create Pie Chart
%So bad: fuck Matlab. See:
%https://www.mathworks.com/help/matlab/creating_plots/customize-pie-chart-labels.html

descent_code_translations = struct();
descent_code_translations.O = 'Other';
descent_code_translations.B = 'Black';
descent_code_translations.W = 'White';
descent_code_translations.H = 'Hispanic';


descent_codes = arrayfun(@(x) {x},descent_codes,'UniformOutput',0);
descent_codes = [descent_codes{1,:}];

descent_names = cellfun(@(x) getfield(descent_code_translations,x),descent_codes,'UniformOutput',0);

f = figure
%Arrest Pie Chart
axesArrests = subplot(1,2,1);
h= pie(axesArrests, descent_codes_counter);
hText = findobj(h,'Type','text'); % text object handles
percentValues = get(hText,'String'); % percent values
combinedtxt = strcat(cellfun(@(x) [x, ': '],descent_names,'UniformOutput',0)',percentValues); % strings and percent values
for l = 1:length(combinedtxt)
    hText(l).String = combinedtxt(l);
end
title(axesArrests,'Arrests in LA 2015 (126,854 total)')

%Population Pie Chart
populations = struct();
populations.B = 9.8;
populations.W = 29.4;
populations.H = 47.5;
populations.O = 100 - (populations.B + populations.W + populations.H);

axesCensus = subplot(1,2,2);
h= pie(axesCensus, cellfun(@(x) getfield(populations,x),descent_codes));
hText = findobj(h,'Type','text'); % text object handles
percentValues = get(hText,'String'); % percent values
combinedtxt = strcat(cellfun(@(x) [x, ': '],descent_names,'UniformOutput',0)',percentValues); % strings and percent values
for l = 1:length(combinedtxt)
    hText(l).String = combinedtxt(l);
end
title(axesCensus,'Population of LA Previous (2010) Census (3,884,307 total)')

save2pdf('Arrests_Vs_Population_pretty',f,600)

set(f,'Units','Inches');
pos = get(f,'Position');
set(f,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(f,'Arrests_Vs_Population','-dpdf','-r0')
print(f,'Arrests_Vs_Population','-dbmp','-r0')

