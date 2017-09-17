clear all
close all
clc

%% Setup
z_h = 10;  % mean structure height [m] 
z_0 = 1;  % surface roughness for category 7 environment [m]
z_d = 0.7*z_h;  % displacement distance for category 7 environment [m]
z_ref = 20;  % reference height [ft -> m]
u_ref = 1:10;  % speed at reference height [m/s]
k = 0.4;  % von Karman's constant
lam_f = 0.3;  % ratio of frontal area to total area
% z_w = 2*z_h;  % roughness/blending/wake-diffusion height approximation
syms Zw
a = 9.6*lam_f;  % empirical constant

% altitude vectors
z_tot = linspace(0,50,200); 

% friction velocity
u_star = @(i) u_ref(i)*k/log((z_ref-z_d)/z_0);

% urban canopy layer profile from Macdonald 2000
u_h = @(i) u_star(i)/k*log((z_h-z_d)/z_0);  % wind speed at roof level

% turbulent mixing length
l_c = @(i) z_h*a^-1*u_star(i)/u_h(i);

% constants in blended profile
A = @(i,z_var) l_c(i) - (z_h/(z_var - z_h))*(k*(z_var - z_d) - l_c(i));
B = @(i,z_var) (1/(z_var - z_h))*(k*(z_var - z_d) - l_c(i));

%% Blended Profile
for i=1:length(u_ref)
  S = vpasolve(u_star(i)/B(i,Zw)*log((A(i,Zw)+B(i,Zw)*Zw)/(A(i,Zw)+B(i,Zw)*z_h)) + u_h(i) == u_star(i)/k*log((Zw-z_d)/z_0));
  z_w(i) = S;
  
  for j=1:length(z_tot)
    % canopy layer
%     if z_tot(j) < z_h
    if z_tot(j) < z_w(i)
      u_canopy(i,j) = u_h(i)*exp(a*((z_tot(j)/z_h) - 1));
    else
      u_canopy(i,j) = nan;
    end

    % roughness sublayer
    if z_tot(j) >= z_w(i)
      u_rsl(i,j) = u_star(i)/k*log((z_tot(j)-z_d)/z_0);
    else
      u_rsl(i,j) = nan;
    end
  end
  
  % concatonate profiles
%   u_tot(i,:) = [u_canopy(i,~isnan(u_canopy)),u_blend(i,~isnan(u_blend)),u_rsl(i,~isnan(u_rsl))];
  u_tot(i,:) = [u_canopy(i,~isnan(u_canopy(i,:))),u_rsl(i,~isnan(u_rsl(i,:)))];
  
  % test continuity in canopy profile
  v1 = u_h(i)*exp(a*((z_h/z_h) - 1));
  v2 = u_star(i)/B(i,z_w(i))*log((A(i,z_w(i))+B(i,z_w(i))*z_h)/(A(i,z_w(i))+B(i,z_w(i))*z_h)) + u_h(i);
  if (abs(v1 - v2) > 0.01)
    display('Mismatch with canopy profile')
  end
  
  % test continuity in rsl profile
  v1 = u_star(i)/B(i,z_w(i))*log((A(i,z_w(i))+B(i,z_w(i))*z_w(i))/(A(i,z_w(i))+B(i,z_w(i))*z_h)) + u_h(i);
  v2 = u_star(i)/k*log((z_w(i)-z_d)/z_0);
  if (abs(v1 - v2) > 0.01)
    display('Mismatch with roughness sublayer profile.')
  end
end

%% Plot
figure
colors = lines(length(u_ref));
hold on

% profiles
for i=1:length(u_ref)
    plot(u_tot(i,:),z_tot,'color',colors(i,:),'LineWidth',2)
%   plot(u_canopy(i,:),z_tot,'g','LineWidth',2)
%   plot(u_rsl(i,:),z_tot,'b','LineWidth',2)
end

% Z_ref line
y_zref = z_ref*ones(2);
x_zref = [0,u_ref(end)];
%plot(x_zref,y_zref,'k--')
plot(get(gca,'xlim'),y_zref,'k--','LineWidth',2);
text(11,z_ref-2,'Z_{Ref}','FontWeight','bold')

lambda_str = '\lambda';
head_str = 'Altitude Vs. Mean Horizontal Wind Speed';
var_str = sprintf('Z_h=%0.1f, Z_0=%0.1f, Z_d=%0.1f, Z_{ref}=%0.1f, lam_f=%0.2f',z_h,z_0,z_d,z_ref,lam_f);
title({head_str,var_str})
xlabel('Speed [m/s]')
ylabel('Altitude [m]')

leg_str = textscan(num2str(u_ref),'%s');
h = legend(leg_str{1},'Location','SouthEast');
v = get(h,'title');
set(v,'string','U_{ref} [m/s]');
hold off
