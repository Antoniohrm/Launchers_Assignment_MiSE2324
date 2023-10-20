function y = AST_modulo(x)
%AST_MODULO Modulus of an angle in radians between 0 and 2*pi.
%   Y = AST_modulo(X) returns the angle Y in radians in the interval
%   [0,2*pi) for the angle X in given in radians. 
%
%   X can be a matrix of any dimension. Y will have the same dimensions.
%


% Two pi value
pi2= 2 * pi;

y = mod(x,pi2);

return;
