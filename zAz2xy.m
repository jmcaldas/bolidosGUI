function [x,y] = zAz2xy(z,Az,xc,yc,R,FOV,alfa)
    
    k = FOV/(2*R);
    r = (z)./k;
    theta = Az+alfa;
    if theta>360
        theta = theta-360;
    end
    x = -r.*sind(theta)+xc;
    y = -r.*cosd(theta)+yc;
    
end