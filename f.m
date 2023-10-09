function y = f(p_bien,c1,c2,Str_Eff1,Str_Eff2,deltaV)
y = (c1*log((1+p_bien*c1)/(p_bien*c1*Str_Eff1)))+(c2*log((1+p_bien*c2)/(p_bien*c2*Str_Eff2))) - deltaV;
end
