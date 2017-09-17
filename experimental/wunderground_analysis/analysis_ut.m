%% Unscented Transform
if plot_ut_win && ~plot_ut_day
    u_mean_ut = u_mean_win;
    v_mean_ut = v_mean_win;
    u_std_ut = u_std_win;
    v_std_ut = v_std_win;
    uv_mean_ut = uv_mean_win;
    uv_cov_ut = uv_cov_win;
end

if plot_ut_day && ~plot_ut_win
    u_mean_ut = u_mean_day;
    v_mean_ut = v_mean_day;
    u_std_ut = u_std_day;
    v_std_ut = v_std_day;
    uv_mean_ut = uv_mean_day;
    uv_cov_ut = uv_cov_day;
end

% sigma points
s(:,1) = [0, 2^0.5]';
s(:,2) = [-(3/2)^0.5, -(1/2)^0.5]';
s(:,3) = [(3/2)^0.5, -(1/2)^0.5]';

for i=1:3
    m(i,:) = uv_cov_ut^0.5 * s(:,i) + uv_mean_ut;
    [mp(i,1),mp(i,2)] = cart2pol(m(i,1),m(i,2));
end

m;
mp;
mp_mean = mean(mp,1)

mp_cov = zeros(2);
for i=1:3
    vec = mp(i,:)-mp_mean;
    mp_cov = mp_cov + vec'*vec;
end
mp_cov = mp_cov/3