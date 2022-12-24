fname = './BoB3_4km_2013_305_mesoNoTides_addPvort/netcdfOutput/bob_his_00001.nc';
gname= './BoB3_4km_2013_305_mesoNoTides_addPvort/BoB3_4km.nc';

'use the density for lambda'

rho = nc_varget(fname,'rho');

grd = roms_get_grid(gname,fname,0,1);

[pv,pvi,pvj,pvk] = ertel(fname,gname,rho,3,grd.z_r);

fig(1);imagesc(sq(pv(end-1,:,:)));axis xy;colorbar;caxis(10^-6*[-1 1])
fig(2);imagesc(sq(pvk(end-1,:,:)));axis xy;colorbar;caxis(10^-6*[-1 1])