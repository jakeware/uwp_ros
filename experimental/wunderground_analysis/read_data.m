clear all
close all
clc

%% Load Data
listing = dir('KMACAMBR9*.txt');

for i=1:length(listing)
    fname = listing(i).name;
    
    fid = fopen(fname);
    data_cell_raw = textscan(fid,'%s','HeaderLines',1,'delimiter',',');
    fclose(fid);

    data_cell_col = data_cell_raw{1};
    % format
    %Time,TemperatureF,DewpointF,PressureIn,WindDirection,WindDirectionDegrees,WindSpeedMPH,WindSpeedGustMPH,Humidity,HourlyPrecipIn,Conditions,Clouds,dailyrainin,SoftwareType,DateUTC

    [m,n] = size(data_cell_col);
    data_cell = cell(m/15,15);
    for j=1:m/15
        for k=1:15
            data_cell{j,k} = data_cell_col{15*(j-1)+k};
        end
    end

    [m,n] = size(data_cell);
    data = zeros(m,15);
    % get date and time
    for j=1:m
        % year
        data(j,1) = str2double(data_cell{j,1}(1:4));

        % month
        data(j,2) = str2double(data_cell{j,1}(6:7));

        % day
        data(j,3) = str2double(data_cell{j,1}(9:10));

        % hours
        data(j,4) = str2double(data_cell{j,1}(12:13));

        % minutes
        data(j,5) = str2double(data_cell{j,1}(15:16));
        
        % total minutes into day
        data(j,6) = data(j,4)*60 + data(j,5);

        % temp [F]
        data(j,7) = str2double(data_cell(j,2));

        % dewpoint [F]
        data(j,8) = str2double(data_cell(j,3));

        % pressure [in]
        data(j,9) = str2double(data_cell(j,4));

        % wind direction [deg]
        data(j,10) = str2double(data_cell(j,6));

        % wind speed [MPH]
        data(j,11) = str2double(data_cell(j,7));

        % wind gust speed [MPH]
        data(j,12) = str2double(data_cell(j,8));

        % humidity
        data(j,13) = str2double(data_cell(j,9));

        % hourly precipitation [in]
        data(j,14) = str2double(data_cell(j,10));

        % daily rain [in]
        data(j,15) = str2double(data_cell(j,13));
    end
    
    [m,n] = size(data);
    bigdata(i,1:m,:) = data(:,:);
    bigdata_size(i) = m;
end

save('bigdata.mat','bigdata');
save('bigdata_size.mat','bigdata_size');
