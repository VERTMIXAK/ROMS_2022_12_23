file = 'Barrow_sea_bdry_2018.nc';
grid = '../Gridpak/BARROWB_1km.nc';

dyeW = nc_varget(file,'dye_west_01');
% fig(1);clf;pcolor(dyeW);shading flat;colorbar

lat = nc_varget(grid,'lat_rho');
lon = nc_varget(grid,'lon_rho');

latCutoff = 71.5;
[a,b] = find(lat(:,1)>latCutoff);
indexCutoff = a(1)


%%

[nz,ny] = size(dyeW)

dyeW = 0*dyeW + 1;
aaa=5;

for jj=indexCutoff:ny
    dyeW(:,jj) = 0;
end;

% fig(2);clf;imagesc(sq(lon(:,1)),sq(lat(:,1)),dyeW);axis xy;colorbar
fig(2);clf;plot(sq(lat(:,1)),dyeW(1,:));ylim([-.1 1.1])

dum=zeros(1,nz,ny);
dum(1,:,:) = dyeW;


aaa=5;

nc_varput(file,'dye_west_01',dum);
