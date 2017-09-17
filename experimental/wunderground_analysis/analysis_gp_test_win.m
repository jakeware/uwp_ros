%% Setup
% combine into single input vector
X = [day_data_win',min_data_win'];
Ys = speed_data_win';
Yd = dir_data_win';
Z = [df*ones(length(min_data_day),1),min_data_day'];

% covariance functions
cgi1 = {'covSEiso'}; 
cgi2 = {'covSEiso'}; 
covfunc = {'covSum',{cgi1,cgi2}};

% likelihood functions
likfunc = {'likGauss'};

%% Speed Regression
% hyperparameters
% day
ell1 = 2;
sf1 = 1;
hypgi1 = log([ell1;sf1]);

% minutes elapsed
ell2 = 30;
sf2 = 2;
hypgi2 = log([ell2;sf2]); 

% meta covariance
hyp.cov = [hypgi1; hypgi2];

% likelihood
sn = 0.7;
hyp.lik = log(sn);

% regression
%hyp = minimize(hyp, @gp, -100, @infExact, [], covfunc, likfunc, X, Ys);
[ms, s2s] = gp(hyp, @infExact, [], covfunc, likfunc, X, Ys, Z);

%% Heading Regression
% hyperparameters
% day 
ell1 = 5;
sf1 = 100;
hypgi1 = log([ell1;sf1]);

% minutes elapsed 
ell2 = 30;
sf2 = 100;
hypgi2 = log([ell2;sf2]); 

% meta covariance 
hyp.cov = [hypgi1; hypgi2];

% likelihood
sn = 20;
hyp.lik = log(sn);

% regression
%hyp = minimize(hyp, @gp, -100, @infExact, [], covfunc, likfunc, X, Yd);
[md, s2d] = gp(hyp, @infExact, [], covfunc, likfunc, X, Yd, Z);

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
scatter(min_data_day,ms)
c = [0 0.5 0];
fill([min_data_day,fliplr(min_data_day)],mss,c,'FaceAlpha', 0.2)
title('Speed Vs. Time')
ylabel('Speed [m/s]')
xlabel('Minutes Elapsed in Day')
hold off

%% Heading Time
figure
hold on
plot(min_data_day,dir_data_day)
scatter(min_data_day,md)
c = [0 0.5 0];
fill([min_data_day,fliplr(min_data_day)],mds,c,'FaceAlpha', 0.2)
title('Heading Vs. Time')
ylabel('Heading [deg]')
xlabel('Minutes Elapsed in Day')
hold off