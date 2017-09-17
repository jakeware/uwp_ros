% get data
count = 0;
for i=di:df
    for j=tm:tp
        speed = data(i,j,11);
        dir = data(i,j,10);
        if speed > speed_min && dir ~= 0 && ~any(d_filt==i) %%&& dir > dir_min && dir < dir_max
            count = count + 1;
            day_data_win(count) = i;
            min_data_win(count) = data(i,j,6);
            dir_data_win(count) = data(i,j,10);
            speed_data_win(count) = data(i,j,11);
            u_data_win(count) = data(i,j,16);
            v_data_win(count) = data(i,j,17);
        end
    end
end

%% Speed PDF
% mean and std
speed_mean_win = mean(speed_data_win);
speed_var_win = var(speed_data_win);

% hist
[y_hist_speed,x_hist_speed] = hist(speed_data_win,speed_bins);
y_hist_speed = y_hist_speed/sum(y_hist_speed);

% weibull fit
parmhat = wblfit(speed_data_win);
x_fit = 0:0.1:30;
y_fit = wblpdf(x_fit,parmhat(1),parmhat(2));

% compute mean and variance from fitted curve
lambda = parmhat(1);
k = parmhat(2);
wbl_mean = lambda*gamma(1+1/k);
wbl_var = lambda^2*(gamma(1+2/k)-(gamma(1+1/k))^2);

%% Heading PDF
% mean and std
dir_mean = mean(dir_data_win);
dir_std = std(dir_data_win);

% compute hist
[y_hist_dir,x_hist_dir] = hist(dir_data_win,heading_bins);
y_hist_dir = y_hist_dir/sum(y_hist_dir);

% fit gaussian
x_gauss_dir = 0:10:360;
y_gauss_dir = normpdf(x_gauss_dir,dir_mean,dir_std);

%% X Velocity PDF
% compute hist
[y_hist_u,x_hist_u] = hist(u_data_win,uv_bins);
y_hist_u = y_hist_u/sum(y_hist_u);

% fit gaussian
x_gauss_u = linspace(-10,10);
u_mean_win = mean(u_data_win);
u_std_win = std(u_data_win);
y_gauss_u = normpdf(x_gauss_u,u_mean_win,u_std_win);

%% Y Velocity PDF
% compute hist
[y_hist_v,x_hist_v] = hist(v_data_win,uv_bins);
y_hist_v = y_hist_v/sum(y_hist_v);

% fit gaussian to window data
x_gauss_v = linspace(-10,10);
v_mean_win = mean(v_data_win);
v_std_win = std(v_data_win);
y_gauss_v = normpdf(x_gauss_v,v_mean_win,v_std_win);

%% XY Velocity PDF
% compute histogram
[x_hist_uv1,x_hist_uv2] = meshgrid(x_hist_u,x_hist_v);
y_hist_uv = y_hist_u'*y_hist_v;
y_hist_uv = y_hist_uv./sum(y_hist_uv(:));
x_hist_uv1 = reshape(x_hist_uv1,length(x_hist_uv1)*length(x_hist_uv1),1);
x_hist_uv2 = reshape(x_hist_uv2,length(x_hist_uv2)*length(x_hist_uv2),1);
y_hist_uv = reshape(y_hist_uv,length(y_hist_uv)*length(y_hist_uv),1);

% fit gaussian
x1 = -5:0.2:5;
x2 = -5:0.2:5;
[X1,X2] = meshgrid(x1,x2);
uv_mean_win = [u_mean_win, v_mean_win]';
uv_cov_win = cov(u_data_win,v_data_win);
F = mvnpdf([X1(:) X2(:)],uv_mean_win',uv_cov_win);
F = reshape(F,length(x2),length(x1));
