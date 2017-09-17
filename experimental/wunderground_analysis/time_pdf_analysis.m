clear all
close all
clc

%% Setup
plot_speed = 0;
plot_gustspeed = 0;
plot_speed_day = 0;
plot_dir_day = 0;
plot_speed_day_pdf = 1;
plot_dir_day_pdf = 0;
plot_all_pdf = 0;
day = 707;

%% Load Data
load('data.mat');
load('data_size.mat');

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

%% All Time PDF
if (plot_all_pdf)
    % speed
    % create single data vector
    count = 0;
    for i=1:length(data)
        for j=1:data_size(i)
            if data(i,j,11) ~= 0
                count = count + 1;
                speed_data_all(count) = data(i,j,11)*0.44704;
            end
        end
    end

    % histogram
    figure
    hold on
    [y_hist,x_hist] = hist(speed_data_all(:),50);
    bar(x_hist,y_hist/sum(y_hist));

    % weibull fit
    parmhat = wblfit(speed_data_all);

    % weibull pdf
    x_fit = 0:0.1:30;
    y_fit = wblpdf(x_fit,parmhat(1),parmhat(2));
    plot(x_fit,y_fit,'r')
    title('Wind Speed PDF for All Time')
    ylabel('Probability')
    xlabel('Wind Speed [m/s]')
    hold off

    % heading
    % create single data vector
    count = 0;
    for i=1:length(data)
        for j=1:data_size(i)
            if data(i,j,11) ~= 0
                count = count + 1;
                dir_data_all(count) = data(i,j,10)*0.44704;
            end
        end
    end

    % histogram
    figure
    hold on
    [y_hist,x_hist] = hist(dir_data_all(:),50);
    bar(x_hist,y_hist/sum(y_hist));

    title('Wind Heading PDF for All Time')
    ylabel('Probability')
    xlabel('Wind Heading [deg]')
    hold off
end

%% Single Day PDF
if (plot_speed_day_pdf)
    % speed
    % create single data vector
    count = 0;
    for j=1:data_size(day)
        if data(day,j,11) ~= 0
            count = count + 1;
            speed_data_day(count) = data(day,j,11)*0.44704;
        end
    end

    % histogram
    figure
    hold on
    [y_hist,x_hist] = hist(speed_data_day(:),10);
    bar(x_hist,y_hist/sum(y_hist));

    % weibull fit
    parmhat = wblfit(speed_data_day);

    % weibull pdf
    x_fit = 0:0.1:30;
    y_fit = wblpdf(x_fit,parmhat(1),parmhat(2));
    plot(x_fit,y_fit,'r')
    title('Wind Speed PDF for Single Day')
    ylabel('Probability')
    xlabel('Wind Speed [m/s]')
    hold off
end

if (plot_dir_day_pdf)
    % heading
    % create single data vector
    count = 0;
    for j=1:data_size(day)
        if data(day,j,11) ~= 0
            count = count + 1;
            dir_data_day(count) = data(day,j,10)*0.44704;
        end
    end

    % histogram
    figure
    hold on
    [y_hist,x_hist] = hist(dir_data_day(:),10);
    bar(x_hist,y_hist/sum(y_hist));

    title('Wind Heading PDF for Single Day')
    ylabel('Probability')
    xlabel('Wind Heading [deg]')
    hold off
end

%% Single Day Time
if plot_speed_day
    % speed for one day
    figure
    hold on
    title('Wind Speed Vs. Minutes Elapsed')
    ylabel('Wind Speed [m/s]')
    xlabel('Minutes Elapsed in Day')
    plot(data(day,1:data_size(day),6),data(day,1:data_size(day),11)*0.44704)
    hold off
end

if plot_dir_day
    % speed for one day
    figure
    hold on
    title('Wind Direction Vs. Minutes Elapsed')
    ylabel('Wind Direction [deg]')
    xlabel('Minutes Elapsed in Day')
    plot(data(day,1:data_size(day),6),data(day,1:data_size(day),10))
    hold off
end