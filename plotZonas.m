function plotZonas(im,RSOL,dAz,Rhorizonte,dR,xs,ys,xc,yc,Rmin)

figure(1)

[m,n] = size(im);
zonas=zeros(m,n,3);
a = (yc-ys)/(xc-xs);
b = yc - a*xc;
[rsol,AzSol] = ij2polar(ys,xs,yc,xc);

J=ones(n,1)*(1:n);
I=J';
J=J(1:m,1:n);
I=I(1:m,1:n);

[r,az] = ij2polar(I,J,yc,xc);
drecta = abs(a*J-I+b)./sqrt(a^2+1);

%SOL
sol=zeros(m,n);
sol((I-ys).^2+(J-xs).^2-RSOL^2<=0)=1;
sol(r>Rmin)=0;
[p,q]=find(sol>0);
zonas(sub2ind(size(zonas),p,q,3*ones(length(p),1)))=0;
zonas(sub2ind(size(zonas),p,q,1*ones(length(p),1)))=1;
zonas(sub2ind(size(zonas),p,q,2*ones(length(p),1)))=1;

%Sol 2
sol2=zeros(m,n);
sol2(r>=rsol-RSOL)=1;
sol2(r>Rmin)=0;
sol2((I-ys).^2+(J-xs).^2-RSOL^2<=0)=0;
sol2(abs(az-AzSol)>dAz)=0;
[p,q]=find(sol2>0);
zonas(sub2ind(size(zonas),p,q,3*ones(length(p),1)))=0;
zonas(sub2ind(size(zonas),p,q,1*ones(length(p),1)))=1;
zonas(sub2ind(size(zonas),p,q,2*ones(length(p),1)))=0.5;

%PLANO SOLAR
plano=zeros(m,n);
plano(drecta<=dR)=1;
plano((I-ys).^2+(J-xs).^2-RSOL^2<=0)=0;
plano(r>Rmin)=0;
plano(sol2==1)=0;
[p,q]=find(plano>0);
zonas(sub2ind(size(zonas),p,q,3*ones(length(p),1)))=1;
zonas(sub2ind(size(zonas),p,q,1*ones(length(p),1)))=0;
zonas(sub2ind(size(zonas),p,q,2*ones(length(p),1)))=0;

%HORIZONTE
h=zeros(m,n);
h(r>Rhorizonte)=1;
h(r>Rmin)=0;
h((I-ys).^2+(J-xs).^2-RSOL^2<=0)=0;
h(drecta<=dR)=0;
h(abs(az-AzSol)<=dAz)=0;
[p,q]=find(h>0);
zonas(sub2ind(size(zonas),p,q,3*ones(length(p),1)))=0.5;
zonas(sub2ind(size(zonas),p,q,1*ones(length(p),1)))=1;
zonas(sub2ind(size(zonas),p,q,2*ones(length(p),1)))=0;

%RESTO
resto=ones(m,n);
resto=resto-plano-sol-h-sol2;
resto(r>Rmin)=0;
[p,q]=find(resto>0);
zonas(sub2ind(size(zonas),p,q,3*ones(length(p),1)))=1;
zonas(sub2ind(size(zonas),p,q,1*ones(length(p),1)))=0;
zonas(sub2ind(size(zonas),p,q,2*ones(length(p),1)))=1;

imshow(zonas);

cr = edge(im,'canny',[0.15 0.25]);
figure(2)
imshow(cr);