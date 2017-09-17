clear all
close all
clc

%% Setup
plot_figure = 1;
save_figure = 1;
figure_path = '~/ware_thesis_ms/figures/';

% curve fits come from power consumption wind tunnel test
p_pitch_angle = [0.001623818395810,0.023778344180720,-0.001041356196381];
p_pitch_command = [1.401162989770157e+02,2.078944176127368e+03];
p_thrust_command = [-0.044416376418423,1.493297708280197,-15.008580701279511,51.539918896590060,-56.978505187505300,2.239432998935630e+03];

% pitch fit
Va = linspace(0,15);
model_pitch = polyval(p_pitch_angle,Va);

% test speeds
speeds_hover = [2,4,6,8,12,16,20,25];
speeds_forward = [2,4,6,8,10,12,14.5];

%% Populate
for i=1:length(speeds_forward)
  pitch_angle_forward(i) = rad2deg(polyval(p_pitch_angle,speeds_forward(i)));
  pitch_command_forward(i) = (polyval(p_pitch_command,speeds_forward(i)) - 2047) / 2047;
  thrust_command_forward(i) =  polyval(p_thrust_command,speeds_forward(i)) / 4095;
end

fprintf('Hover Test\n');
fprintf('Speed [m/s], Pitch Angle [deg], Pitch Command [-2047,2047], Thrust Command [0,4095]\n');
for i=1:length(speeds_hover)
  fprintf('%2.2f, %2.2f, %2.2f, %2.2f\n', speeds_hover(i), 0, 0, 2239 / 4095);
end
fprintf('\n');

fprintf('Forward Test\n');
fprintf('Speed [m/s], Pitch Angle [deg], Pitch Command [-2047,2047], Thrust Command [0,4095]\n');
for i=1:length(speeds_forward)
  fprintf('%2.2f, %2.2f, %2.2f, %2.2f\n', speeds_forward(i), pitch_angle_forward(i), pitch_command_forward(i), thrust_command_forward(i));
end

%% Plot
if plot_figure
  figure
  hold on
  
  plot(speeds_forward(3:end),pitch_angle_forward(3:end),'r*','LineWidth',2)
  plot(Va,rad2deg(model_pitch),'k--','LineWidth',2);
  
  title('Vehicle Pitch Vs. Wind Speed')
  xlabel('Wind Speed [m/s]')
  ylabel('Vehicle Pitch [deg]')
  ax = gca;
  ax.XTick = [5,7.5,10,12.5,15];
  legend('sampled','actual','Location','NorthWest')
  axis([5,15,5,45])
  hold off
  
  if save_figure
%     set(gcf,'units','inches','paperposition',[0 0 1 1])
    saveas(gcf,strcat(figure_path,'wspi_wind_pitch.eps'),'epsc')
  end
end