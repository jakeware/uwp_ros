%% Sample Number
if plot_check
    figure
    hold on

    % sample count
    plot(data_size(:))

    title('Wind Direction Vs. Minutes Elapsed')
    ylabel('Total Daily Samples')
    xlabel('Day')
    hold off
end

% calc mean speed
for i=1500:length(data)
    day_dir_mean(i) = mean(data(i,1:data_size(i),10));
    day_speed_mean(i) = mean(data(i,1:data_size(i),11));
end

if plot_day_speed_mean
    figure
    hold on

    % sample count
    plot(day_speed_mean(1500:end))

    title('Mean Values')
    ylabel('Speed [m/s]')
    xlabel('Day')
    hold off
end