classdef Mission
    properties

        % Initialize constants

        g = 9.81                % m/s2
        mu = 3.886e14           % m3/s2
        re = 6371e3             % m
        wearth = 7.2921159e-5;  % rad
        latlaunch = 5.2         % deg (North)

        % Constraints

        horbit = 700e3          % m
        mpl = 300               % kg
        maxg = [6, 6, 4]        % g's
        maxq = 45000            % Pa

        % Assumptions

        excessdeltav = 2000;

    end

    methods

        function r = orbitv(obj)
            r = sqrt(obj.mu / (obj.re + obj.horbit));
        end

        function r = deltav(obj)
            r = obj.orbitv + obj.excessdeltav;
        end
        
    end
end