% lon1 = 230;
% lon0 = 220-360;
% lon1 = 230-360;
% lat0 = 54;
% lat1 = 59;
% 
% bb = [   [lon0;lon1]  [lat0;lat1 ]];
% 
% hls_get_wvs(bb);

%%

clear;


kateDir = '/import/AKWATERS/kshedstrom/hydroflow/new_2019/';
kateFile = 'goa_dischargex_09012013_08312014.nc';

file = [kateDir,kateFile]
    
lon = nc_varget(file,'lon')+360;
lat = nc_varget(file,'lat');

q = nc_varget(file,'q');
[nt,npoints] = size(q);

fig(10);clf;
plot(lon,lat)
fig(11);clf;


lon0 = min(lon)-360;
lon1 = max(lon)-360;
lat0 = min(lat);
lat1 = max(lat);

bb = [   [lon0;lon1]  [lat0;lat1 ]];

hls_get_wvs(bb);


%%
load('coastCheck.mat')


wvs.lon = wvs.lon + 360;

gridFile = '../InputFiles/Gridpak/SEAKp_1km.nc';

latSEAK = nc_varget(gridFile,'lat_rho');
lonSEAK = nc_varget(gridFile,'lon_rho');
maskSEAK= nc_varget(gridFile,'mask_rho');

% fig(1);clf;
% pcolor(lon,lat,mask);shading flat;hold on
% plot(wvs.lon,wvs.lat)

[ny,nx] = size(lonSEAK);

ivec = [1:nx];
jvec = [round(1/2 * ny):ny];
fig(11);clf;
pcolor(lonSEAK(jvec,ivec),latSEAK(jvec,ivec),maskSEAK(jvec,ivec));shading flat;hold on
plot(wvs.lon,wvs.lat)


ivec = [1:round(nx/5)];
jvec = [round(4/5 * ny):ny];

% fig(2);clf;
% pcolor(lon(jvec,ivec),lat(jvec,ivec),mask(jvec,ivec));shading flat;hold on
% plot(wvs.lon,wvs.lat)

%%

fig(10);clf;
plot(lon,lat);title(['lat/lon pairs in ',kateFile])
fig(11);clf;plot(wvs.lon,wvs.lat)

fig(20);clf;
plot(lon,lat);title(['lat/lon pairs in ',kateFile]);hold on
plot(wvs.lon,wvs.lat,'r')

