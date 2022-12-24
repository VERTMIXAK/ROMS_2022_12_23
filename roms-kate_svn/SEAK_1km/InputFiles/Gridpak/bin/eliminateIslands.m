gridFile = 'SEAK_1km.nc';

% unix(['cp ./safeDir/',gridFile,' .'])

mask = nc_varget(gridFile,'mask_rho');

fig(1);clf;
pcolor(mask);shading flat;colorbar


mask(200:300,120:end) = 1;
mask(300:370,150:end) = 1;
mask(370:390,320:460) = 1;
mask(370:390,170:250) = 1;
mask(370:390,530:end) = 1;
mask(300:320,110:170) = 1;

fig(2);clf;
pcolor(mask);shading flat;colorbar

nc_varput(gridFile,'mask_rho',mask)

