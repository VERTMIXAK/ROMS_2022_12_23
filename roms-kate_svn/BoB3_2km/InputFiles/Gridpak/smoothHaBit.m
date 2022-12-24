gFile = 'BoB3_2km.nc';

hraw = nc_varget(gFile,'hraw');

hold = sq(hraw(3,:,:));
hnew = lowpass(lowpass(hold',2)',3);

fig(1);pcolor(hold);shading flat;caxis([0 20])
fig(2);pcolor(hnew);shading flat;caxis([0 20])

hraw(3,:,:) = hnew;
nc_varput(gFile,'hraw',hraw);

