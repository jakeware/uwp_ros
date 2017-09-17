clear all
close all
clc

%% Load Data
load('bigdata.mat');
load('bigdata_size.mat');

%% Structure
% 1: year
% 2: month
% 3: day
% 4: hours
% 5: minutes
% 6: total minutes
% 7: temp [F]
% 8: dewpoint [F]
% 9: pressure [in]
% 10: wind direction [deg]
% 11: wind speed [MPH]
% 12: wind gust speed [MPH]
% 13: humidity
% 14: hourly precipitation [in]
% 15: daily rain [in]

%% Filter
% remove empty datasets
count = 0;
for i=1:length(bigdata)
    if bigdata_size(i) ~= 0
        count = count + 1;
        data(count,1:bigdata_size(i),:) = bigdata(i,1:bigdata_size(i),:);
        data_size(count) = bigdata_size(i);
    end
end

%% Save
save('data.mat','data');
save('data_size.mat','data_size');