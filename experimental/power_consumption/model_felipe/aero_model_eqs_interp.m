% Aerodynamic model for simulator
%We need a model that will give us rotor thrust, power and drag as a function of RPM, and
%translational speed.
%We can use momentum theory applied to fwd flight and the empirical data
%for specific propellers measure in hover.

%first step is to define the mass flow through the rotor disks
% we are looking at the problem in the plane defined by the relative wind
% speed vector across each rotor

%resultant velocity perpendicular to disk.

%input parameters:
rho=1.225;%Kg/m^3
Vinf_vector=linspace(0, 20, 81); %m/s airflow speed
alpha_vector=linspace(-90, 90, 200).*pi/180;%5*pi/180; % radians. AoA of the rotor wrt to flow... be carefull this is not wrt to earth

%rotor:
R=8.5*0.0254;%17 in diameter in m
A=pi*R^2;
%parameter for vortex ring state empirical model
k=1.05;%induced power factor of rotor
k1=-1.125;
k2=-1.372;
k3=-1.718;
k4=-0.655;


w=3500;%Rotational speed in RPM

%These are empirical curves to model the thrust power and FM

T_w = 1.22185E-06*w^2 - 6.50161E-04*w + 3.16712E-01;%Hover thrust in N as a function of rotational speed w in RPM
P_w = 2.113880E-05*w^2 - 4.441241E-02*w + 2.621002E+01;%Hover power in N as a function of rotational speed w in RPM
FM_w =1.962953E-11*w^3 - 1.725853E-07*w^2 + 5.134860E-04*w + 4.070404E-02;%FM as function of RPM valid between 900 and 4300 RPM

Po_w=((T_w)^1.5/sqrt(2*rho*A))*(1/FM_w-k);
Vh=sqrt(T_w/(2*rho*A));

%Induced speed across rotor
% This is an implicit equation that we will solve using numerical methods.
%Vi=Vh^2/(sqrt((Vinf*cos(alpha))^2+(Vinf*sin(alpha)+Vi)^2)); eq 2.122 leishman




%columns Vinf
%lines AoA

alpha_bound=-70*pi/180;


for j=1:length(Vinf_vector)
    for i=1:length(alpha_vector)
        
        Vinf=Vinf_vector(j);
        alpha=alpha_vector(i);
        
        %To be able to have the bounds for interpolation I need to 
        %calculate the induced velocity at the angle that I defined if
        %there is a change I can end up in the region where I need to
        %interpolate
        
        if ((Vinf/Vh>0 && Vinf/Vh<2 && alpha<alpha_bound))
        
        fun_Vi_b_interp=@(Vid)Vid-Vh^2/(sqrt((Vinf*cos(alpha_bound))^2+(Vinf*sin(alpha_bound)+Vid)^2));
        guess=Vh;
        [Vi_bound,fval,exitflag]=fzero(fun_Vi_b_interp,guess); 
        
        %Empirical approximation during vortex ring state
        Vi_vrs_ratio=k+k1*(-Vinf/Vh)+k2*(-Vinf/Vh)^2+k3*(-Vinf/Vh)^3+k4*(-Vinf/Vh)^4;
        Vi_vrs=Vi_vrs_ratio*Vh;

        %Now we interpolate
        Vi(i,j)=interp1([-pi/2 alpha_bound],[Vi_vrs Vi_bound],alpha,'spline');
        
        
        else    
        %this is the general case
        fun_Vi=@(Vid)Vid-Vh^2/(sqrt((Vinf*cos(alpha))^2+(Vinf*sin(alpha)+Vid)^2));
        guess=Vh;
        [Vi(i,j),fval,exitflag]=fzero(fun_Vi,guess);
        end
        
        U(i,j)=sqrt(Vinf^2+2*Vinf*Vi(i,j)*sin(alpha)+Vi(i,j)^2);
        
        %Thrust produced by rotor
        T(i,j)=2*rho*A*U(i,j)*Vi(i);
        T_ratio(i,j)=T(i,j)./T_w;
        
        %induced power.
        P(i,j)=T(i,j)*Vinf*sin(alpha)+T(i,j)*Vi(i,j);
        %I could add profile power based on speed and experiments and have
        %a induced power factor too... it is a hack:
        %total power profile power + induced power+induced losses
        P_tot(i,j)=P(i,j)*k+Po_w;%
        
        
        %I need to calculate the power at any operating condition. I know
        %experimentally the power at hover, this is of great help. we have eq 2.140
        %leishman.
        
        %we can have the same type of approach as for thrust ratio
        
        P_ratio(i,j)=(Vinf*sin(alpha)+Vi(i,j))./Vh;%eq 2.140 leishman this is induced power ratio
        %P_ratio(i,j)=P_tot(i,j)./P_w;
        
        
    end
    
end


figure
[c,h]=contourf(Vinf_vector./Vh,alpha_vector.*180/pi,T_ratio,100);clabel(c, h)
xlabel('V_{infinity}/Vh')
ylabel('Rotor AoA (deg)')
str = sprintf('Thrust ratio T/Th at Vh= %f m/s',Vh);
title(str);

% plot(T_ratio,alpha_vector.*180/pi);figure(gcf);
% ylabel('T/Thover')
% xlabel('Rotor AoA')

%Alpha is positive when rotor is pitching down with respect to incoming
%flow Vinf
figure
[c,h]=contourf(Vinf_vector./Vh,alpha_vector.*180/pi,T_ratio,50);%clabel(c, h)
xlabel('V_{infinity}/Vh')
ylabel('Rotor AoA')
str = sprintf('Thrust ratio T/Th at Vh= %f m/s',Vh);
title(str);

figure
[c,h]=contourf(Vinf_vector./Vh,alpha_vector.*180/pi,Vi./Vh,50);%clabel(c, h)
xlabel('V_{infinity}/Vh')
ylabel('Rotor AoA')
str = sprintf('Vi/Vh at Vh= %f m/s',Vh);
title(str);


%Let's try to reproduce figure 2.18 p 84 leishman  axial flight
%when the range reaches + - 90 deg

figure
hold
%This loop is useful to find the a good spot to start the interpolation.
%a linear interpolation should work well enough, do this next to you work on this

for a=0:22
    
    plot(-Vinf_vector./Vh,Vi(1+a,:)./Vh,'+-b')
    plot(Vinf_vector./Vh,Vi(end-a,:)./Vh,'+-b')
    xlabel('Climb velocity ratio(Vc/Vh)')
    ylabel('Induced vel ratio Vi/Vh')
    
    %let's compare this with the exact analytical solutions.
    
    %for climb
    Vi_vh_climb=-(Vinf_vector./(2*Vh))+sqrt((Vinf_vector./(2*Vh)).^2+1);
    
    %for descent
    Vi_vh_desc=-(-Vinf_vector./(2*Vh))-sqrt((-Vinf_vector./(2*Vh)).^2-1);
    
    plot(Vinf_vector./Vh,Vi_vh_climb,'ro')
    plot(-Vinf_vector./Vh,Vi_vh_desc,'ro')
    % so this is working..I had to add minus sign to fix the inputs to the eqs.
    
    
    %vortex ring state empirical aproximation
    %this eq is only valid in the range of -2<=Vinf_vector./Vh<=0;
    Vi_vrs_ratio=k+k1*(-Vinf_vector./Vh)+k2*(-Vinf_vector./Vh).^2+k3*(-Vinf_vector./Vh).^3+k4*(-Vinf_vector./Vh).^4;
    
    plot(-Vinf_vector./Vh,Vi_vrs_ratio,'g')
    
end
%so I need to interpolate between the vrs empirical solution and the momentum equs using along the rotor angle of attack




%Let's try to reproduce figure 2.20 p 88 leishman  axial flight
%when the range reaches + - 90 deg
figure
hold

for a=0:22
    
    plot(-Vinf_vector./Vh,P_ratio(1+a,:),'+-b')
    plot(Vinf_vector./Vh,P_ratio(end-a,:),'+-b')
    xlabel('Climb velocity ratio(Vc/Vh)')
    ylabel('Induced vel ratio Vi/Vh')
    
    %let's compare this with the exact analytical solutions.
    
    %for climb
    P_Ph_climb=(Vinf_vector./(2*Vh))+sqrt((Vinf_vector./(2*Vh)).^2+1);
    
    %for descent
    P_Ph_desc=-(Vinf_vector./(2*Vh))-sqrt((Vinf_vector./(2*Vh)).^2-1);%notice how I had to add the negative sign because of the way I am defioning the flow that is always positive
    
    plot(Vinf_vector./Vh,P_Ph_climb,'ro')
    plot(-Vinf_vector./Vh,P_Ph_desc,'ro')
    % so this is working.

end


%Power calcs works where momentum theory is valid.
figure
hold

for a=1:length(Vinf_vector);
plot(Vinf_vector./Vh,P(a,:),'-+k',Vinf_vector./Vh,P_tot(a,:),'-og')
end

figure
[c,h]=contourf(Vinf_vector./Vh,alpha_vector.*180/pi,P_ratio,100);clabel(c, h)
xlabel('V_{infinity}/Vh')
ylabel('Rotor AoA')
str = sprintf('Power ratio P/Ph at Vh= %f m/s',Vh);
title(str);

%I need to keep either power or thrust constant. think about it.

%Let's generate figure 2.26 of leishman's book. inflow ratio vs. fwd speed ratio for different rotor AoA.

%we need advance ratio mu

%mu=Vinf*sin(alpha)+vi/omega*R






