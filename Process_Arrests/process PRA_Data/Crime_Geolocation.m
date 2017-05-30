%Coordinates
%Note that 'locations{2}' contains the location-names as inputted by user
APIkey2='AIzaSyDVZPQrCVHtayFWu2LIWid6126hujMG5kQ';
pre_url2 = 'https://maps.googleapis.com/maps/api/geocode/json?';
coordinates = cell(1,size(locNames,1));
for i = 1:length(locNames)
    address = ['address=',strrep(locNames{i},' ','+')];
    url2 = [pre_url2,address,'&key=',APIkey2];
    %url = 'https://maps.googleapis.com/maps/api/distancematrix/json?origins=nottingham&destinations=london|manchester|liverpool&key=AIzaSyDDKHV64CvECHE8wf_KXpLiWr2fM0XAnrU';
    webreturn = webread(url2);
    webreturn = webreturn.results.geometry;
    webreturn = webreturn.location;
    coordinates{i}= webreturn;
end
coordinates = cell2mat(cellfun(@(x) [x.lat;x.lng],coordinates,'UniformOutput',0)); %coordinates(1,k) is the latitude of the k'th location; coordinates(2,k) is the longitude.
