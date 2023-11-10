function [e]=AST_pvecle(s,xmu)
%   E = AST_pvecle(S,XMU) returns the orbital elements 1x6 given the cartesian
%   state vector S(nx6) and the gravitational constant of the central body
%   XMU.
%
%   S must be a nx6 array whose first three components, colum-wise will be
%   the position X, Y and Z in km and the last three components will be the
%   velocity VX , VY and VZ in km/s. 
%
%   The orbital elements vector E will be returned as:
%        E(n,1)  a    Semimajor axis    [km ]   for e ~= 1*
%                p    Orbital parameter [km ]   for e == 1
%        E(n,2)  e    Eccentricity      [-- ]       >0      
%        E(n,3)  i    Inclination       [rad]   0 < i < pi  
%        E(n,4)  o    Ascending node    [rad]   0 < i < 2*pi
%        E(n,5)  w    Perigee Argument  [rad]   0 < i < 2*pi
%        E(n,6)  u    True Anomaly      [rad]   0 < u < 2*pi
%
%   XMU must be given in km^3/s^2.
%   


%**************************************************************************

      [n,m] = size( s );
      
      if m == 1
          s = s';
          n = 1;
      end

      e = zeros( n , 6 );
      u = zeros( n , 1 );
      % kinetic moment
      c1 = s(:,2).*s(:,6)-s(:,3).*s(:,5);
      c2 = s(:,3).*s(:,4)-s(:,1).*s(:,6);
      c3 = s(:,1).*s(:,5)-s(:,2).*s(:,4);
      
      % Modulus of kinetic moment
      cc12 = c1.*c1+c2.*c2;
      cc = cc12 + c3.*c3;
      c = sqrt(cc);
      
      % Quadratic modulus of the velocity
      v02 = s(:,4).^2+s(:,5).^2+s(:,6).^2;
      
      r0v0 = s(:,1).*s(:,4)+s(:,2).*s(:,5)+s(:,3).*s(:,6);
      
      % Modulus of position
      r02 = s(:,1).^2+s(:,2).^2+s(:,3).^2;      
      r0 = sqrt(r02);
      
      x = r0.*v02/xmu;
      cx = cc/xmu;
      ste = r0v0.*c./(r0*xmu);
      cte = cx./r0-1.d0;
      e(:,1) = r0./(2.d0-x);
      e(:,2) = sqrt(ste.*ste+cte.*cte);
      e(:,3) = atan2(sqrt(cc12),c3);
%     racg: vector 'if' condition   
%       if(cc12>cc*eps) 
%          u = atan2(c*s(3),s(2)*c1-s(1)*c2);
%          e(4)=atan2 (c1,-c2);
%       else
%          u = atan2(s(2),s(1))*sign(c3);
%          e(4)=0.d0;
%       end
      u(:) = atan2(s(:,2),s(:,1)).*sign(c3);
      i = find(cc12 > cc*eps);
      u(i) = atan2(c.*s(:,3),s(:,2).*c1-s(:,1).*c2);
      e(i,4) = atan2 (c1,-c2);  
%   scalar \/    
%       if(e(2) > eps) 
%          e(6)=atan2(ste,cte);
%          e(5)=u-e(6);
%       else
%          e(6) = u;
%          e(5)=0.d0;
%       end
%   scalar /\
      e(:,6)  = u;
      ii = find(e(:,2) > eps);
      e(ii,6) = atan2(ste,cte);
      e(ii,5) = u-e(ii,6);
%     racg: modulo  if(e(4) < 0.d0) 
%           e(4) = e(4) + 2*pi;
      e(:,4) = AST_modulo(e(:,4));
%       end
%    using modulo
%    if(e(5) < 0.d0) 
%           e(5) = e(5) + 2*pi;
      e(:,5) = AST_modulo(e(:,5));
%       end

      if m == 1
          e = e';
      end
      
return %-----------------------------------------------------------------[MAIN FUNCTION]%

