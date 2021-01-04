function Date=jd2date(JD);
%--------------------------------------------------------------------
% jd2date function       convert Julian Day to date.
% input  : - vector of Julian Days.
% output : - matrix in which the first column is the Day in the month
%            the second column is the month, the third is the year
%            and the fourth column is fraction of day (U.T.)
%    By  Eran O. Ofek           September 1999
%--------------------------------------------------------------------
if nargin>1,
   error('1 arg only');
end

if (min(JD)<0),
   error('The method i valid only for poitive JDs');
end

Z = floor(JD+0.5);
F = (JD+0.5) - floor(JD+0.5);

A     = zeros(size(JD));
Day   = zeros(size(JD));
Month = zeros(size(JD));
Year  = zeros(size(JD));


IZ_s = find(Z<2299161);
IZ_l = find(Z>=2299161);
A(IZ_s) = Z(IZ_s);

Alpha = fix((Z(IZ_l) - 1867216.25)./36524.25);
A(IZ_l) = Z(IZ_l) + 1 + Alpha - fix(Alpha./4);

B = A + 1524;
C = fix((B - 122.1)./365.25);
D = fix(365.25.*C);
E = fix((B-D)./30.6001);

Day   = B - D - fix(30.6001.*E) + F;
IE_s  = find(E<14);
IE_l  = find(E>=14);
Month(IE_s) = E(IE_s) - 1;
Month(IE_l) = E(IE_l) - 13;

IM_l  = find(Month>2);
IM_s  = find(Month==1 | Month==2);
Year(IM_l) = C(IM_l) - 4716;
Year(IM_s) = C(IM_s) - 4715; 

Date = [floor(Day), Month, Year, F];
