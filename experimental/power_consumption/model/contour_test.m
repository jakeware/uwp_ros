clear all
close all
clc

x = linspace(0,1,10);
y = linspace(0,-1,10);
for i=1:length(x)
    for j=1:length(y)
        Z(j,i) = x(i)+y(j);
    end
end

Z

figure
hold on
contour(x,y,Z)
xlabel('x')
ylabel('y')
colorbar
hold off