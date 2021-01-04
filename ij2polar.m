function [rho,theta] = ij2polar(i,j,ic,jc)
%Pasa de pixel (i,j) a coordenadas polares en un sistema
%de origen en el cenit (xc,yc), con y hacia arriba y x a la derecha.

rho = sqrt((j-jc).^2+(i-ic).^2);
theta = (180/pi())*atan2(ic-i,j-jc);

theta(theta<0)=theta(theta<0)+360;

end