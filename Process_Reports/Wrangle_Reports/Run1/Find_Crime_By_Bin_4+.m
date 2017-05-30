load('driving_crimes_by_division.mat')
division =1; %Central
binnumber=29475;

a = driving_crimes_by_division{division};
possibilities = cell(1,15);
count = 1;
for i = 1:size(a,1)
    if (a{i,15}==binnumber)
        possibilities(1,:)=a(i,:);
    end
end
disp(possibilities);
