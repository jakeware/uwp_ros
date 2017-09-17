function plot_trajectory(h,traj,xBt,yBt,zBt,t,plot_frames)
  figure(h);

  view(30,20)
  grid on
  xlabel('X [m]')
  ylabel('Y [m]')
  zlabel('Z [m]')
  title('Simulated Minimum-Snap Trajectory Following')
  axis([-3 6 -3 6 -3 3])
  set(gcf,'defaultlinelinewidth',4)
  
  % plot frames along trajectory
  if plot_frames
    for i=1:floor(length(t)/4):length(t)
      plot3([traj(1,i) traj(1,i)+zBt(1,i)],...
          [traj(2,i) traj(2,i)+zBt(2,i)],...
          [traj(3,i) traj(3,i)+zBt(3,i)],'r')
      plot3([traj(1,i) traj(1,i)+xBt(1,i)],...
          [traj(2,i) traj(2,i)+xBt(2,i)],...
          [traj(3,i) traj(3,i)+xBt(3,i)],'g')
      plot3([traj(1,i) traj(1,i)+yBt(1,i)],...
          [traj(2,i) traj(2,i)+yBt(2,i)],...
          [traj(3,i) traj(3,i)+yBt(3,i)],'b')
    end
  end

  % plot trajectory
  plot3(traj(1,:),traj(2,:),traj(3,:),'b-')
end