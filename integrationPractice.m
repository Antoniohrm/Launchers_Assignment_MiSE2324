clear all
close all
%
x0 = 0;
T = 1; % [s] Sin period
w = 2*pi/T;
%
options = [];%odeset('RelTol',1e-8,'AbsTol',1e-7);
% if I want a more accurate solution, then
% options = odeset('RelTol',1e-8,'AbsTol',1e-7);
%
[tSol xSol] = ode45(@der,[0 3*T], x0, options, w);

figure 
plot(tSol, xSol,'r*')
grid on 
set (gca,'FontSize',14)
xlabel('Time [s]','FontSize',14)
ylabel('function Value','FontSize',14)

% Analitycal solution 
yAna = 1/w*sin(w*tSol);
hold on 
plot(tSol, yAna,'b')
%
figure 
plot(tSol, abs(yAna - xSol),'b*')
grid on 
set (gca,'FontSize',14)
xlabel('Time [s]','FontSize',14)
ylabel('Absolute Error','FontSize',14)
%
figure 
semilogy(tSol, abs((yAna - xSol)./yAna),'b*')
grid on 
set (gca,'FontSize',14)
xlabel('Time [s]','FontSize',14)
ylabel('Relative Error','FontSize',14)






 