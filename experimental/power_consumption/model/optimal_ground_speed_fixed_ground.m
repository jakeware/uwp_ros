clear all
close all
clc

%% Notes
% ground speed is a fixed vector with varying wind speed.

%% Setup
plot_energy_ground = 1;
plot_energy_air = 0;
plot_pow = 0;
plot_surf = 0;

% wind speed window [m/s]
win_f = 8;

%% Analysis
% find optimal ground speed
vel_g = linspace(0,15);
for i=1:2*win_f+1
    vel_f(i) = i-win_f-1;
    vel_a(i,:) = abs(vel_g - vel_f(i));
    pow(i,:) = 0.008171*vel_a(i,:).^4 + 0.1757*vel_a(i,:).^3 - 0.846*vel_a(i,:).^2 - 0.6665*vel_a(i,:) + 105.8;
    dist = 1;
    energy(i,:) = pow(i,:)*dist./vel_g;
    [e,ind] = min(energy(i,:));
    opt_ind(i) = ind;
    vel_a_opt(i) = vel_a(i,ind);
    energy_opt(i) = e;
end


%% Plot
if plot_energy_ground  
    figure
    colors = colormap(jet(length(vel_f)+1));  
    hold on
    for i=1:length(vel_f)
        plot(vel_g,energy(i,:),'color',colors(length(colors)-i,:),'LineWidth',2)
        vf_labels{i} = num2str(vel_f(i));
    end
    hleg = legend(vf_labels, 'Location', 'EastOutside');
    htitle = get(hleg,'Title');
    set(htitle,'String','Wind Speed [m/s]')
    
    for i=1:length(vel_f)
        scatter(vel_g(opt_ind(i)),energy_opt(i),'k*')
    end
    xlabel('Ground Speed [m/s]')
    ylabel('Energy Consumed Per Unit Distance [m]')
    axis([0,15,0,500])
    hold off
end

if plot_energy_air
    figure
    colors = colormap(lines(length(vel_f)+1));  
    hold on
    for i=1:length(vel_f)
        plot(vel_a(i,:),energy(i,:),'color',colors(i,:))
        vf_labels{i} = num2str(vel_f(i));
    end
    hleg = legend(vf_labels, 'Location', 'EastOutside')
    htitle = get(hleg,'Title');
    set(htitle,'String','Wind Speed')
    
    for i=1:length(vel_f)
        scatter(vel_a(i,opt_ind(i)),energy_opt(i),'k*')
    end
    title('Energy Consumed Per Unit Distance Vs. Air Speed for Given Wind Speeds')
    xlabel('Air Speed [m/s]')
    ylabel('Energy Consumed Per Unit Distance [m]')
    axis([0,25,0,500])
    hold off
end

if plot_pow
    figure
    hold on
    for i=1:length(vel_f)
        plot(vel_a(i,:),pow(i,:))
    end
    title('Power Vs Air Speed')
    xlabel('Air Speed [m/s]')
    ylabel('Energy Consumed [J]')
    hold off
end

if plot_surf
    figure
    hold on
    surf(vel_g,vel_f,energy)
    for i=1:length(vel_f)
        scatter3(vel_g(opt_ind(i)), vel_f(i),energy_opt(i),'k*')
    end
    title('Energy Consumed Per Unit Distance Vs Ground and Wind Speed')
    xlabel('Ground Speed [m/s]')
    ylabel('Wind Speed [m/s]')
    zlabel('Energy Consumed [J]')
    axis([2,15,0,15,0,200])
    hold off
end
