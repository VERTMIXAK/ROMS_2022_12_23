[~,lat0]=unix(['grep lat latlon.txt | cut -d "=" -f2 | cut -d "_" -f1']); lat0=    str2num(lat0);
[~,lon0]=unix(['grep lon latlon.txt | cut -d "=" -f2 | cut -d "_" -f1']); lon0=360-str2num(lon0);

f0 = 7.292115 * 10^-5 * 2 * sin(lat0 *3.14159265/180)

latRho = nc_varget('grid.nc','lat_rho');
lonRho = nc_varget('grid.nc','lon_rho');

latPsi = nc_varget('grid.nc','lat_psi');
lonPsi = nc_varget('grid.nc','lon_psi');

latU = nc_varget('grid.nc','lat_u');
lonU = nc_varget('grid.nc','lon_u');

latV = nc_varget('grid.nc','lat_v');
lonV = nc_varget('grid.nc','lon_v');


f    = nc_varget('grid.nc','f');



newLonRho = lonRho + lon0 - lonRho(3,3);
newLatRho = latRho + lat0 - latRho(3,3);

newLonPsi = lonPsi + lon0 - lonRho(3,3);
newLatPsi = latPsi + lat0 - latRho(3,3);

newLonU   = lonU   + lon0 - lonRho(3,3);
newLatU   = latU   + lat0 - latRho(3,3);

newLonV   = lonV   + lon0 - lonRho(3,3);
newLatV   = latV   + lat0 - latRho(3,3);

newf      = f      + f0   - f(3,3);



nc_varput('grid.nc','lon_rho',newLonRho);
nc_varput('grid.nc','lat_rho',newLatRho);

nc_varput('grid.nc','lon_psi',newLonPsi);
nc_varput('grid.nc','lat_psi',newLatPsi);

nc_varput('grid.nc','lon_u',newLonU);
nc_varput('grid.nc','lat_u',newLatU);

nc_varput('grid.nc','lon_v',newLonV);
nc_varput('grid.nc','lat_v',newLatV);


nc_varput('grid.nc','f',newf);


