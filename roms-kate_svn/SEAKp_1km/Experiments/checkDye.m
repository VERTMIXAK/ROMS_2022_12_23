file = 'SEAKp_1km_2017_002_meso_8tides_LMD_addRivers/netcdfOutput/seak_his_00001.nc';

dye = nc_varget(file,'dye_01');

fig(1);clf;
pcolor(sq(dye(end,end,:,:)));shading flat

dum = sq(dye(end,end,:,50:end));
fig(2);clf
pcolor(dum);shading flat;colorbar


