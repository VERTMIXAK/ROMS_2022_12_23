icFile = '../BC_IC_CMEMS_template/ini/NISKINE_IC_template.nc';

unix(['cp ',icFile,' ic.nc']);

[~,lat0]   = unix(['grep lat latlon.txt | cut -d "=" -f2 | cut -d "_" -f1']); lat0 =     str2num(lat0);
[~,lon0]   = unix(['grep lon latlon.txt | cut -d "=" -f2 | cut -d "_" -f1']); lon0 = 360-str2num(lon0);
[~,year] = unix(['grep year latlon.txt | cut -d "=" -f2 ']);                  year =     str2num(year);
[~,day] = unix(['grep day latlon.txt | cut -d "=" -f2 ']);                    day  =      str2num(day);


%% update lat/lon

latRho = nc_varget('ic.nc','lat_rho');
lonRho = nc_varget('ic.nc','lon_rho');

latPsi = nc_varget('ic.nc','lat_psi');
lonPsi = nc_varget('ic.nc','lon_psi');

latU = nc_varget('ic.nc','lat_u');
lonU = nc_varget('ic.nc','lon_u');

latV = nc_varget('ic.nc','lat_v');
lonV = nc_varget('ic.nc','lon_v');

newLonRho = lonRho + lon0 - lonRho(3,3);
newLatRho = latRho + lat0 - latRho(3,3);

newLonPsi = lonPsi + lon0 - lonRho(3,3);
newLatPsi = latPsi + lat0 - latRho(3,3);

newLonU   = lonU   + lon0 - lonRho(3,3);
newLatU   = latU   + lat0 - latRho(3,3);

newLonV   = lonV   + lon0 - lonRho(3,3);
newLatV   = latV   + lat0 - latRho(3,3);

nc_varput('ic.nc','lon_rho',newLonRho);
nc_varput('ic.nc','lat_rho',newLatRho);

nc_varput('ic.nc','lon_psi',newLonPsi);
nc_varput('ic.nc','lat_psi',newLatPsi);

nc_varput('ic.nc','lon_u',newLonU);
nc_varput('ic.nc','lat_u',newLatU);

nc_varput('ic.nc','lon_v',newLonV);
nc_varput('ic.nc','lat_v',newLatV);

%% update T and S

sourceName = ['CMEMS_PHY_',num2str(day),'.nc'];
['/import/c1/VERTMIX/jgpender/ROMS/CMEMS/NISKINE_',num2str(year),'/data_PHY/',sourceName];
unix(['cp ',ans,' .']);

grd = roms_get_grid('grid.nc','ic.nc',0,1);




% Note that the CMEMS files count from 2000, not 1900
day2000 = nc_varget(sourceName,'ocean_time');
day1900 = day2000 + 36524;

lon   = nc_varget(sourceName,'lon'); %lon=mod(lon,360);
lat   = nc_varget(sourceName,'lat');
lon1D = nc_varget(sourceName,'lon1d'); %lon1D=mod(lon1D,360);
lat1D = nc_varget(sourceName,'lat1d');
temp  = sq(nc_varget(sourceName,'temp'));
salt  = sq(nc_varget(sourceName,'salt'));
z     = -nc_varget(sourceName,'z');

%%

[i,~] = find(lon1D - (lon0-360) == min(abs(lon1D - (lon0-360)))  );
[j,~] = find(lat1D - (lat0    ) == min(abs(lat1D - (lat0    )))  );




k=25;
lon1D(i);
lat1D(j);
z(k);
temp(k-1:k+1,j-1:j+1,i-1:i+1);


%%

myZ = sq(grd.z_r(:,3,3));
myTemp = nc_varget('ic.nc','temp');
mySalt = nc_varget('ic.nc','salt');

for kk=1:length(myZ)
    kk
%     myTemp(1,kk,:,:) = interp3(lat1D,z,lon1D,temp,lat0,myZ(kk),lon0-360);
%     mySalt(1,kk,:,:) = interp3(lat1D,z,lon1D,salt,lat0,myZ(kk),lon0-360);
    myTemp(kk,:,:) = interp3(lat1D,z,lon1D,temp,lat0,myZ(kk),lon0-360);
    mySalt(kk,:,:) = interp3(lat1D,z,lon1D,salt,lat0,myZ(kk),lon0-360);
end;

nc_varput('ic.nc','temp',myTemp);
nc_varput('ic.nc','salt',mySalt);
nc_varput('ic.nc','ocean_time',day1900);

% interp3(lat1D,z,lon1D,temp,lat0,-150,lon0-360)

