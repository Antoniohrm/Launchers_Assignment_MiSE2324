
clear

r = Rocket;

% r.cd(1)
% r.cd(5.25)
% 
% r.cd(0.2)
% r.cd(6.5)
% 
% r.cd(0.8)

for i = 1:size(r.cddata, 1)

    r.cd(r.cddata(i, 1)) / r.cddata(i, 2)
end