function [] = plotGuidanceResults(Simulation)

% Excess fuel vs position and velocity dispersion

figure

dispx = vecnorm(transpose(Simulation.rdisp));
dispv = vecnorm(transpose(Simulation.vdisp));

scatter3(dispx, dispv, Simulation.mexcess, 'LineWidth', 3)

title('Excess propellant mass vs dispersion in position and velocity', 'FontSize', 16)
fontsize(gca, 12, 'points')

figure

for i = 1:3
    plot(Simulation.mexcess, Simulation.rdisp(:, i), 'LineWidth', 3)
    hold on
end

xlabel('Excess propellant (kg)', 'FontSize', 14)
ylabel('Dispersion in position (m)', 'FontSize', 14)
title('Dispersion in position vs excess propellant mass', 'FontSize', 16)
legend('X component', 'Y component', 'Z component', 'FontSize', 12)
fontsize(gca, 12, 'points')

figure

for i = 1:3
    plot(Simulation.mexcess, Simulation.vdisp(:, i), 'LineWidth', 3)
    hold on
end

xlabel('Excess propellant (kg)', 'FontSize', 14)
ylabel('Dispersion in velocity (m/s)', 'FontSize', 14)
title('Dispersion in velocity vs excess propellant mass', 'FontSize', 16)
legend('X component', 'Y component', 'Z component', 'FontSize', 12)
fontsize(gca, 12, 'points')







end