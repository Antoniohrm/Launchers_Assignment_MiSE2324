function [check, stops, direction] = eventsfun(t, state, Rocket, Mission)

h = norm(state(1:3)) - Mission.re;

check(1) = h-100;
stops(1) = 1; %
direction(1) = 1;

% mf1 = Rocket.m0(1) - Rocket.mprop(1);
% check(2) = state(7) - mf1;
% stops(2) = 1;
% direction(2) = -1;


% h = norm(state(1:3)) - Mission.re;
% 
% if (norm(state(1:3)) - Mission.re) < Mission.vrlim
%     %VR
%     check(1) = h-100;
%     stops(1) = 1; %
%     direction(1) = 1;
% else
%     check(1) = h;
%     stops(1) = 1;
%     direction(1) = -1;
% end
% % mf1 = Rocket.m0(1) - Rocket.mprop(1);
% % check(2) = state(7) - mf1;
% % stops(2) = 1;
% % direction(2) = -1;
end