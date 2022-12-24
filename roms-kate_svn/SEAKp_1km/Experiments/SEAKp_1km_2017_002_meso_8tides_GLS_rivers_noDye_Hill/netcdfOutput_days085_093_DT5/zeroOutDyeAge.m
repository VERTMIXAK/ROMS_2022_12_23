oldRst = 'seak_rst.nc';
newRst = 'myRst.nc';

oldAge = nc_varget(oldRst,'dye_01_age');

[a,b,c,d] = size(dum)


newAge = zeros(1,a,b,c,d);
size(newAge)



fig(1);clf;
pcolor(sq(dum(1,end,:,:)));shading flat;colorbar
nc_varput(newRst,'dye_01_age',newAge);