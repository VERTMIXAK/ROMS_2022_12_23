gridFile = 'grid.nc';
hisFile = 'IC.nc';

grd = roms_get_grid(gridFile,hisFile,0,1);

fig(1);clf;
plot(sq(grd.z_w(:,1,1)));title('z\_w')

fig(2);clf;
plot(diff(sq(grd.z_w(:,1,1))));title('diff( z\_w )')