clear all
close all
clc

%% Setup
% total time
T = 1.0;

% variables
syms t p0 p1 p2 p3 p4 p5 p6 p7 p8 p9;
p = {'p0','p1','p2','p3','p4','p5','p6','p7','p8','p9'};

% derivative costs
N = 10;
der_costs = [0,0,0,0,1,0,0,0,0,0];

fun = p0 + p1*t + p2*t^2 + p3*t^3 + p4*t^4 + p5*t^5 + p6*t^6 + p7*t^7 + p8*t^8 + p9*t^9;
for i=1:N
  dfun(i) = diff(fun,i-1,'t');
  cost_fun(i) = der_costs(i)*dfun(i)^2;
end
cost_fun_tot = sum(cost_fun);

% optimization
for i=1:length(p)
  for j=1:length(p)
    H(i,j) = diff(diff(cost_fun_tot,p{i}),p{j});
  end
end
f = zeros(10,1);

% assign t=T
H = double(subs(H,t,T));

% values at time 0 and 1 (x,xp,xpp,xppp,xpppp)
X0 = [0,0,0,0,0]';  % time 0
X1 = [1,1,0,0,0]';  % time 1

% derivative matrix
Aeq = [
    1,0,0,0,0,0,0,0,0,0;  % x,t=0
    0,1,0,0,0,0,0,0,0,0;  % xp,t=0
    0,0,2,0,0,0,0,0,0,0;  % xpp,t=0
    0,0,0,6,0,0,0,0,0,0;  % xppp, t=0
    0,0,0,0,24,0,0,0,0,0;  % xpppp, t=0
    1,T,T^2,T^3,T^4,T^5,T^6,T^7,T^8,T^9;  % x,t=T 
    0,1,2*T,3*T^2,4*T^3,5*T^4,6*T^5,7*T^6,8*T^7,9*T^8;  % xp,t=T
    0,0,2,6*T,12*T^2,20*T^3,30*T^4,42*T^5,56*T^6,72*T^7;  % xpp,t=T
    0,0,0,6,24*T,60*T^2,120*T^3,210*T^4,336*T^5,504*T^6;  % xppp, t=T
    0,0,0,0,24,120*T,360*T^2,840*T^3,1680*T^4,3024*T^5];  % xpppp, t=T
    
% constraints
beq=[X0;X1];

%% Execution
% solve
% c=A\b;
% solve(A*p == b)
% opts = optimoptions('quadprog','Algorithm','interior-point-convex','MaxIter',2000);
c = quadprog(H,f,[],[],Aeq,beq,[],[])

% get plot values
c = flip(c);
xp = linspace(0,T);
yp = polyval(c,xp);

% %% Plot
figure
hold on
plot(xp,yp)
xlabel('Time')
ylabel('Position')
hold off