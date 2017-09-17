clear all
close all
clc

%% Notes
% wind speed is a fixed vector with varying ground speed.

%% Setup
plot_opt = 0;
plot_energy = 1;
plot_pow = 0;

dist = 1;
max_vg = 15;

%% Analysis
% find optimal ground speed
vel_f = linspace(0,15);
for i=1:max_vg
    vel_g(i) = i;
    vel_a(i,:) = vel_f + vel_g(i);
    pow(i,:) = 0.008171*vel_a(i,:).^4 + 0.1757*vel_a(i,:).^3 - 0.846*vel_a(i,:).^2 - 0.6665*vel_a(i,:) + 105.8;
    energy(i,:) = pow(i,:)*dist/vel_g(i);
    [e,ind] = min(energy(i,:));
    opt_ind(i) = ind;
    vel_a_opt(i) = vel_a(i,ind);
    energy_opt(i) = e;
end

%% Plot
if plot_opt
    figure
    hold on
    plot(vel_a_opt,vel_g)
    title('Minmum Energy Air Speed Vs. Ground Speed')
    xlabel('Ground Speed [m/s]')
    ylabel('Minmum Energy Air Speed [m/s]')
    hold off
end

if plot_energy    
    figure
    colors = colormap(lines(length(vel_g)+1));
    hold on
    for i=1:length(vel_g)
        plot(vel_f,energy(i,:),'color',colors(i,:))
        vg_labels{i} = num2str(vel_g(i));
    end
    hleg = legend(vg_labels, 'Location', 'EastOutside');
    htitle = get(hleg,'Title');
    set(htitle,'String','Ground Speed')
    
%     for i=1:length(vel_g)
%         scatter(vel_a(i,opt_ind(i)),energy_opt(i),'r*')
%     end
    title('Energy Consumed Per Unit Distance Vs. Air Speed for Given Ground Speeds')
    xlabel('Wind Speed [m/s]')
    ylabel('Energy Consumed Per Unit Distance [m]')
    axis([0,15,0,200])
    
    hold off
end

if plot_pow
    figure
    hold on
    for i=1:length(vel_g)
        plot(vel_a(i,:),pow(i,:))
    end
    title('Power Vs Air Speed')
    xlabel('Air Speed [m/s]')
    ylabel('Energy Consumed [J]')
    hold off
end