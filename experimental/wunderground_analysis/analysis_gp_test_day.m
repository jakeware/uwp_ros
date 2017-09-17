%% Setup
% combine into single input vector
X = min_data_day';
Ys = speed_data_day';
Yd = dir_data_day';
Z = [min(X):5:max(X)]';

% covariance functions
covfunc = {'covSEiso'}; 

% likelihood functions
likfunc = {'likGauss'};

%% Speed Regression
% hyperparameters
% minutes elapsed
ell2 = 30;
sf2 = 2;
hyp.cov = log([ell2;sf2]); 

% likelihood
sn = 0.7;
hyp.lik = log(sn);

% regression
%hyp = minimize(hyp, @gp, -100, @infExact, [], covfunc, likfunc, X, Ys);
[ms, s2s] = gp(hyp, @infExact, [], covfunc, likfunc, X, Ys, Z);

hyp.cov
hyp.lik

%% Heading Regression
% hyperparameters
% minutes elapsed 
ell2 = 30;
sf2 = 100;
hyp.cov = log([ell2;sf2]); 

% likelihood
sn = 20;
hyp.lik = log(sn);

% regression
%hyp = minimize(hyp, @gp, -100, @infExact, [], covfunc, likfunc, X, Yd);
[md, s2d] = gp(hyp, @infExact, [], covfunc, likfunc, X, Yd, Z);

hyp.cov
hyp.lik

% calculate sigma regions
msp = ms + s2s.^0.5;
msm = ms - s2s.^0.5;
mss = [msm',fliplr(msp')];

mdp = md + s2d.^0.5;
mdm = md - s2d.^0.5;
mds = [mdm',fliplr(mdp')];

%% Speed Time
figure
hold on
plot(min_data_day,speed_data_day)
scatter(Z,ms)
c = [0 0.5 0];
fill([Z',fliplr(Z')],mss,c,'FaceAlpha', 0.2)
title('Speed Vs. Time')
ylabel('Speed [m/s]')
xlabel('Minutes Elapsed in Day')
hold off

%% Heading Time
figure
hold on
plot(min_data_day,dir_data_day)
scatter(Z,md)
c = [0 0.5 0];
fill([Z',fliplr(Z')],mds,c,'FaceAlpha', 0.2)
title('Heading Vs. Time')
ylabel('Heading [deg]')
xlabel('Minutes Elapsed in Day')
hold off