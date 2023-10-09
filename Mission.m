classdef Mission
    properties

        % Initialize constants

        g = 9.81                % m/s2
        mu = 3.886e14           % m3/s2
        re = 6371e3             % m
        latlaunch = 5.2         % deg (North)

        % Constraints

        horbit = 700e3          % m
        mpl = 300               % kg
        maxg = [6, 6, 4]        % g's
        deltav = 0           % m/s (To be calculated)

    end

    methods

        function r = orbitv(obj)
            r = sqrt(obj.mu / (obj.re + obj.horbit));
        end
        
    end
end