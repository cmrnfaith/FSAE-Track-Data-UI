
clc
clear

raw_data = readmatrix('test_log_2.csv'); %open the file and store those two columns in data
long_raw = nonzeros(rmmissing(raw_data(:, 39)));
lat_raw = nonzeros(rmmissing(raw_data (:, 38)));

%code to create scatter plot and auto generate axis limits
scatter(lat_raw, long_raw)
longlim1 = min(long_raw) - 0.0005;
longlim2 = max(long_raw(long_raw<0)) + 0.0005;
latlim1 = min(lat_raw(lat_raw>0)) - 0.0005;
latlim2 = max(lat_raw) + 0.0005;
xlim([latlim1 latlim2]);
ylim([longlim1 longlim2]);
%Labels for axis
xlabel('Latitude');
ylabel('Longitude');
%Manually input limits for lap boundry, in future user needds to be able to
%easily enter this depending on lap


% lat1 = 40.84471;
% lat2 = 40.844890;
% long1 = -96.767865;
% long2 = -96.76786;

%Different start/finish spot

lat1 = 40.84650;
lat2 = 40.84655;
long2 = -96.7692;
long1 = -96.769355;

w = abs(long2 - long1);
l = abs(lat2 - lat1);
%draw a rectangle to make it easy for user to see where lap boundry has
%been set. Like drawing the "Finish line"
rectangle('Position', [lat1 long1 (lat2-lat1) (long2-long1)]);


lapnumber = 1;
j=1;
counter = 0
for i = 1:length(long_raw)
    if( (counter == 0) && (long_raw(i)<= long2) && (long_raw(i)>= long1) && (lat_raw(i)<= lat2) && (lat_raw(i) >= lat1))
        lapnumber = lapnumber + 1; %increase lapnumber counter
        j=1;
        counter = 20;
    end
    
    if (counter ~= 0)
        counter = counter - 1;
    end
    long_filtered(j, lapnumber) = long_raw(i);
    lat_filtered(j, lapnumber) = lat_raw(i);   
    j = j+1;
   
    
end

scatter(lat_filtered(:,2), long_filtered(:,2));
longlim1 = min(long_filtered(:,1)) - 0.0010;
longlim2 = max(long_filtered(long_filtered<0)) + 0.0005;
latlim1 = min(lat_filtered(lat_filtered>0)) - 0.0005;
latlim2 = max(lat_filtered(:,1)) + 0.0005;
xlim([latlim1 latlim2]);
ylim([longlim1 longlim2]);
%Labels for axis
xlabel('Latitude');
ylabel('Longitude');
