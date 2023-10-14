clear
clc
close all

Rocket = Rocket;
Mission = Mission;

Rocket.r(1, :) = Rocket.r0(Mission);
Rocket.v(1, :) = Rocket.v0(Mission);
Rocket.cexh = Rocket.cexhcalc(Mission);

[Rocket, Mission] = Staging(Rocket, Mission)
[stateint, Rocket, Mission] = endoAtmPhase(Rocket, Mission);
