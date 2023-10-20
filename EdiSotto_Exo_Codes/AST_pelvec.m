function [s]=AST_pelvec(e,xmu)
%AST_PELVEC Convert from orbital elements to cartesian state vector.
%   S = AST_pelvec(E,XMU) returns the state array nx6 given the classical
%   orbital elements E(nx6) and the gravitational constant of the central
%   body XMU.  
%
%   S will be a nx6 array whose first three components, colum-wise, will be
%   the position X, Y and Z in km and the last three components will be the
%   velocity VX , VY and VZ in km/s. 
%
%   The orbital state vector must be given as:
%        E(n,1)  a    Semimajor axis    [km ]   for e ~= 1*
%                p    Orbital parameter [km ]   for e == 1
%        E(n,2)  e    Eccentricity      [-- ]       >0      
%        E(n,3)  i    Inclination       [rad]   0 < i < pi  
%        E(n,4)  o    Ascending node    [rad]   0 < o < 2*pi
%        E(n,5)  w    Perigee Argument  [rad]   0 < w < 2*pi
%        E(n,6)  u    True Anomaly      [rad]   0 < u < 2*pi
%
%   XMU must be given in km^3/s^2.
%
%
%****************************************************************************************
  
      
      [n,m] = size( e );
      
      if m == 1
          e = e';
      end
      
      if any(abs(e(:,2)-1)) < eps
          p = e(:,1);
      else
          p = abs(e(:,1).*(1.d0 - e(:,2).^2));
      end
%     safety measure for the square root
      p = max(p,1.d-30);
      f =sqrt(abs(xmu./p));
      cv = cos(e(:,6));
      ecv = 1.d0 + e(:,2).*cv;
      
      % Distance from the focus
      r = p./ecv;
      
      u = e(:,5) + e(:,6);
      cu = cos(u);
      su = sin(u);
      co = cos(e(:,4));
      so = sin(e(:,4));
      ci = cos(e(:,3));
      si = sin(e(:,3));
      cocu = co.*cu;
      sosu = so.*su;
      socu = so.*cu;
      cosu = co.*su;
      fx = cocu - sosu.*ci;
      fy = socu + cosu.*ci;
      fz = su.*si;
      % Radial velocity
      vr = f.*e(:,2).*sin(e(:,6));
      % Tangencial velocity
      vu = f.*ecv;
      s  = [r.*fx, ...
            r.*fy, ...
            r.*fz,...
            vr.*fx-vu.*(cosu+socu.*ci),...
            vr.*fy-vu.*(sosu-cocu.*ci),...
            vr.*fz+vu.*cu.*si];

    if m == 1
        s = s';
    end

return %-----------------------------------------------------------------[MAIN FUNCTION]%
