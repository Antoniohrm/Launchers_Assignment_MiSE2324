clc
clear

Rocket = Rocket;
Mission = Mission;
Simulation = Simulation;

[Rocket, Mission] = inputGuidance(Rocket, Mission);

[Rocket, Mission, Simulation] = guidance_main(Rocket, Mission, Simulation);

plotGuidanceResults(Simulation);