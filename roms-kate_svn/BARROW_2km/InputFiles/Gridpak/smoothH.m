gridFile = 'BARROW_2km.nc';

hraw = nc_varget(gridFile,'hraw');


%%

Hwork = 5;

vLimit=[0,4000];

fig(1);clf;
pcolor(sq(hraw(Hwork,:,:)));shading flat;colorbar;caxis(vLimit);

ivec = [50:70];
jvec = [190:230];

fig(2);clf;
pcolor(ivec,jvec,sq(hraw(Hwork,jvec,ivec)));shading flat;colorbar;caxis(vLimit);
