file = 'Barrow_sea_bdry_2018.nc';
grid = '../Gridpak/BARROW_500m.nc';

dyeW = nc_varget(file,'dye_west_01');
fig(1);clf;pcolor(dyeW);shading flat;colorbar

% lat = nc_varget(grid,'lat_rho');

[nz,ny] = size(dyeW)

dyeW = 0*dyeW + 1;
aaa=5;

for jj=120:ny
    dyeW(:,jj) = 0;
end;

fig(2);clf;pcolor(dyeW);shading flat;colorbar


dum=zeros(1,nz,ny);
dum(1,:,:) = dyeW;


nc_varput(file,'dye_west_01',dum);
