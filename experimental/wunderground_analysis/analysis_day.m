% get data
count = 0;
for j=tm:tn
    speed = data(df,j,11);
    dir = data(df,j,10);
    if speed > speed_min && dir ~= 0
        count = count + 1;
        min_data_day(count) = data(df,j,6);
        dir_data_day(count) = data(df,j,10);
        speed_data_day(count) = data(df,j,11);
        u_data_day(count) = data(df,j,16);
        v_data_day(count) = data(df,j,17);
    end
end

%% Speed PDF
% mean and std
speed_mean_day = mean(speed_data_day);
speed_var_day = var(speed_data_day);

% hist
[y_hist_speed_day,x_hist_speed_day] = hist(speed_data_day,speed_bins);
y_hist_speed_day = y_hist_speed_day/sum(y_hist_speed_day);

% weibull fit
parmhat_day = wblfit(speed_data_day);
x_fit_day = 0:0.1:30;
y_fit_day = wblpdf(x_fit_day,parmhat_day(1),parmhat_day(2));

% compute mean and variance from fitted curve
lambda_day = parmhat_day(1);
k_day = parmhat_day(2);
wbl_mean_day = lambda_day*gamma(1+1/k_day);
wbl_var_day = lambda_day^2*(gamma(1+2/k_day)-(gamma(1+1/k_day))^2);

%% Heading PDF
% mean and std
dir_mean_day = mean(dir_data_day);
dir_std_day = std(dir_data_day);

% compute hist
[y_hist_dir_day,x_hist_dir_day] = hist(dir_data_day,heading_bins);
y_hist_dir_day = y_hist_dir_day/sum(y_hist_dir_day);

% fit gaussian
x_gauss_dir_day = 0:10:360;
y_gauss_dir_day = normpdf(x_gauss_dir_day,dir_mean_day,dir_std_day);

%% X Velocity PDF
% compute hist
[y_hist_u_day,x_hist_u_day] = hist(u_data_day,uv_bins);
y_hist_u_day = y_hist_u_day/sum(y_hist_u_day);

% fit gaussian
x_gauss_u_day = linspace(-10,10);
u_mean_day = mean(u_data_day);
u_std_day = std(u_data_day);
y_gauss_u_day = normpdf(x_gauss_u_day,u_mean_day,u_std_day);

%% Y Velocity PDF
% compute hist
[y_hist_v_day,x_hist_v_day] = hist(v_data_day,uv_bins);
y_hist_v_day = y_hist_v_day/sum(y_hist_v_day);

% fit gaussian to window data
x_gauss_v_day = linspace(-10,10);
v_mean_day = mean(v_data_day);
v_std_day = std(v_data_day);
y_gauss_v_day = normpdf(x_gauss_v_day,v_mean_day,v_std_day);

%% XY Velocity PDF
uv_mean_day = [u_mean_day, v_mean_day]';
uv_cov_day = cov(u_data_day,v_data_day);

%% Window Filter Parameters
dir_min = dir_mean_day - 2*dir_std_day;
dir_max = dir_mean_day + 2*dir_std_day;


