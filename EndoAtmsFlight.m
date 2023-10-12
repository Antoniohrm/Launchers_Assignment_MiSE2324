clear all;close all;clc;
rocket = Rocket;
mission = Mission;

re = mission.re;                % m
mu = mission.mu;                % m3/s2
wEarth = mission.wEarth;        % rad/s
wEarthVec = [0 0 wEarth];       % ECI

% Kourou launch base in ECI. Inertial equatorial RF
latlaunch = mission.latlaunch*pi/180; % degrees north, in rad
r0 = [re*cos(latlaunch) 0 re*sin(latlaunch)]; %m

r0_unit = r0/norm(r0); %Unitary vector at lift off in ECI
north_unit = cross(r0_unit, [0 1 0]);
east_unit = cross(north_unit, r0_unit); % Good check

% Propagation Vertical Rising. T//r
options = [];
% if I want a more accurate solution, then
% options = odeset('RelTol',1e-8,'AbsTol',1e-7);
% options = odeset('Events',@hFinal,'RelTol',1e-4,'AbsTol',1e-6);

v0 = cross(wEarthVec,r0); % Inertial velocity, ECI
x0 = [r0 v0]; %Initial conditions
% [tVR SolVR] = ode45(@endoFlightDeriv,[0 tfinal], x0, options,mission,rocket);






