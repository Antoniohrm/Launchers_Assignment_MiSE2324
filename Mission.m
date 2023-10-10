classdef Mission
    properties

        % Initialize constants

        g = 9.81                % m/s2
        mu = 3.886e14           % m3/s2
        re = 6371e3             % m
        wEarth = 7.2921159e-5;  % rad
        latlaunch = 5.2         % deg (North)

        % Constraints

        horbit = 700e3          % m
        mpl = 300               % kg
        maxg = [6, 6, 4]        % g's
        deltav = 0              % m/s (To be calculated)
        maxq = 45000            % Pa


    end

    methods

        function r = orbitv(obj)
            r = sqrt(obj.mu / (obj.re + obj.horbit));
        end
        
    end
end