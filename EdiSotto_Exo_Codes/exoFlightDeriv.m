% This function provides the derivatives to the matlab integrator
% for the  exo-atmospheric flight. 
% 
% The equations of the motion are propagated  and the adjoints equation are
% propogated in the nertial system whose X-axis is determined by the meridian
% passing through the launch pad at lift-off
% 
% The differential eqs. to be propagated are reported herebelow in a compact vectorial form: 
%
%                   rDot    =   v
%                   vDot    =   (mu/norm(r^3))*r + T/m*pv/norm(pv)
%                   prDot   =   -(mu/norm(r)^3)*(3*dot(pv,r)*r/(norm(r)^2) - pv);
%                   pvDot   = - pr
%
%   [deriv] = exoFlightDeriv(t, X)
%
% INPUT:
%
% OUTPUT
%
%
% INPUT:
%
% OUTPUT
%
%*********************************************************************
function[deriv] = exoFlightDeriv(t, X)
%
% Local Variable Initialisation
% ===================================================================
%  
g0 = 9.8065;         % g0 m/s^2
mu  = 398602*1e+9;   % m^3/s^2
%Rm  = 6378.137*1e+3; % m 
%
% Variables Initialisation for the MAV (EADS-ST Design)
% =======================================================
%
%m0 = 7106; % kg   Old Value 
%m0 = 10000 + 2952 + 427 + 1450 + 1300 ;   % kg  PROP + PL + DISP + VEB + EPS_DRY (corrected via https://www.spacelaunchreport.com/ariane5.html#config) 
m0 = 10000 + 2952 + 427 + 1400 + 1900;   % kg  PROP + PL + DISP + VEB + EPS_DRY (corrected via https://www.spacelaunchreport.com/ariane5.html#config) 
Th = 29570; % N
%
ISP   = 321; %sec;
c     = ISP*g0; 
%
mdotEf = Th/(c);
%
%
% Assign the state to local variables
% =====================================
%
r     = X(1:3); % Position Vector
v     = X(4:6); % Velocity Vector
%
pr    = X(7:9);   % Position adjoints
pv    = X(10:12); % PRIMER VECTOR (Velocity Adjoints) 
%
%
m = m0 - mdotEf*t;
%
%
% Compute the derivitives
% =====================================
%
rDot    =  v;
vDot    = -(mu/norm(r)^3)*r + (Th/m)*pv/norm(pv);
prDot   = -(mu/norm(r)^3)*(3*dot(pv,r)*r/(norm(r)^2) - pv);
pvDot   = - pr;
%
%
deriv   =   [rDot; vDot; prDot; pvDot];
%
%
return
