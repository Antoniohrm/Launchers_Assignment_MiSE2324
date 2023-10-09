clear all;close all;

Re = 6371000; % m
mu = 398600000; % m3/s2
wEarth = 7.2921159e-5; % rad/s
wEarthVec = [0 0 wEarth]; % ECI

% Kourou launch base in ECI. Inertial equatorial RF
kourou_lat = 5.2*pi/180; %degrees north, in rad
r0 = [Re*cos(kourou_lat) 0 Re*sin(kourou_lat)]; %m

r0_unit = r0/norm(r0); %Unitary vector at lift off in ECI
east_vec = cross([1 0 0], r0_unit);
east_unit = east_vec/norm(east_vec);
north_unit = cross(r0_unit,east_unit);

% Propagation Vertical Rising. T//r
options = [];
% if I want a more accurate solution, then
%options = odeset('RelTol',1e-8,'AbsTol',1e-7);
% options = odeset('Events',@hFinal,'RelTol',1e-4,'AbsTol',1e-6);

v0 = cross(wEarthVec,r0);
x0 = [];
[tVR SolVR] = ode45(@endoFlightDeriv,[0 tfinal], x0, options,?,?);






