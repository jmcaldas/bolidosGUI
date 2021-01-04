function brillo =dameCielo(im,xc,yc,R)

[m,n]=size(im);
c=1;
for i=1:m
    for j=1:n
        [r,az] = ij2polar(i,j,yc,xc);
        if r<=R
            brillo(c)=im(i,j);
            c=c+1;
        end
    end
end

clear r az

