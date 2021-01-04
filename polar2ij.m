function IJ = polar2ij(rho,theta,ic,jc)
%Pasa de coordenadas polares en un sistema
%de origen en el cenit (xc,yc), con y hacia arriba y x a la derecha, a pixel (i,j).

IJ(:,2) = jc+rho.*cosd(theta);
IJ(:,1) = ic-rho.*sind(theta);

end