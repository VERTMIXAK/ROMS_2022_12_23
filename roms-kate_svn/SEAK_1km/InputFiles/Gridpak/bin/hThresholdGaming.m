file = 'SEAK_1km.nc';

h = nc_varget(file,'h');
mask = nc_varget(file,'mask_rho');
mask(mask==0) = nan;

myI = 411;
myJ = 367;


fig(1);clf;pcolor(h(myJ-4:myJ+4,myI-4:myI+4).*mask(myJ-4:myJ+4,myI-4:myI+4));shading flat;colorbar;caxis([0 400])
round(h(myJ-4:myJ+4,myI-4:myI+4).*mask(myJ-4:myJ+4,myI-4:myI+4));flipud(ans)

temp = h;
temp(h>=5 & h<100 & ~isnan(mask)) = 50;

fig(2);clf;pcolor(temp(myJ-4:myJ+4,myI-4:myI+4).*mask(myJ-4:myJ+4,myI-4:myI+4));shading flat;colorbar;caxis([0 400])
round(temp(myJ-4:myJ+4,myI-4:myI+4).*mask(myJ-4:myJ+4,myI-4:myI+4));flipud(ans)

nc_varput(file,'h',temp);
