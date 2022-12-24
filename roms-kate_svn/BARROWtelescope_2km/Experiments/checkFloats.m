clear;


myDir='BARROWtelescope_2km_2018_182_meso_allTides';

% myDir='BARROW_2km_2018_243_meso_NISKINEC_Floats';

gfile = [myDir '/BARROWtelescope_2km.nc'];exist(gfile)
grd=roms_get_grid(gfile);lonr=grd.lon_rho(1,:);latr=grd.lat_rho(:,1);grd

% ffile = [myDir '/netcdfOutput_closeToBdry/barrow_flt.nc'];
ffile = [myDir '/netcdfOutput/barrow_flt.nc'];

lon = nc_varget(ffile,'lon');
lat = nc_varget(ffile,'lat');
depth = nc_varget(ffile,'depth');
time = roms_get_date(ffile);


% ROMS starts writing zeros for position when a float hits a boundary. Turn
% these into NaNs to take them off the table.

lat(lat == 0) = nan;
lon(lon == 0) = nan;


%% get launch points from floats file

[a,dumLon] = unix(['grep d0 ../InputFiles/External/floats_barrow.in | tr -s " " | tr " " "," | cut -d "," -f6'])
[a,dumLat] = unix(['grep d0 ../InputFiles/External/floats_barrow.in | tr -s " " | tr " " "," | cut -d "," -f7'])

latLaunch = [80.000,
90.000,
100.000,
110.000,
120.000,
130.000,
140.000,
150.000,
160.000];

lonLaunch = 0*latLaunch + 90;

% Well, the code in this section leaves a lot to be desired. Perhaps a
% little discussion might help. Given a set of release sites

nSites = 18;

% and a total number of releases per site (which is not tied to the run
% time of the experiment)

nReleases = 60;

% you have nSites x nReleases distinct floats. Many different floats may be
% released from a given site, but the release times are unique.

% Here is the position of floats 1, 2, and 3 plotted for all write times:

fig(1);clf;
 pcolor(grd.lon_rho,grd.lat_rho,grd.mask_rho);shading flat;hold on
 plot(lon(:,1),lat(:,1),'k')
 plot(lon(:,2),lat(:,2),'k')
 plot(lon(:,3),lat(:,3),'k')
 
% They all come from the same launch point, don't they? This means that all
% the date for site #1 lives here
%   lat(:,1:nRelease)
%   lon(:,1:nRelease)

% and all the date for site #2 lives here
%   lat(:,nRelease+1:2*nRelease)
%   lon(:,nRelease+1:2*nRelease)

% and all the date for site #s lives here
%   lat(:,(s-1)*nRelease+1:s*nRelease)
%   lon(:,(s-1)*nRelease+1:s*nRelease)
    


%%
% fig(1);clf
% subplot(2,1,1);
%  pcolor(grd.lon_rho,grd.lat_rho,grd.mask_rho);shading flat;hold on
%  tdx = find(time<time(1)+1);
%  tmplon=lon(tdx,:);tmplat=lat(tdx,:);good = find(tmplon>0);tmplon=tmplon(good);tmplat=tmplat(good); 
%  plot(tmplon,tmplat,'k.' )
%  plot(tmplon(1),tmplat(1),'ro')
% subplot(2,1,2);
%  pcolor(grd.lon_rho,grd.lat_rho,grd.h);shading flat;hold on
%  tdx = find(time<time(1)+30);
%  tmplon=lon(tdx,:);tmplat=lat(tdx,:);good = find(tmplon>0);tmplon=tmplon(good);tmplat=tmplat(good); 
%  plot(tmplon,tmplat,'k.')
%  plot(tmplon(1),tmplat(1),'ro')

 9
%% Plot first day's worth of float data
 


 fig(2);clf
 pcolor(grd.lon_rho(:,:),grd.lat_rho(:,:),grd.mask_rho(:,:));shading flat;hold on
%  pcolor(grd.mask_rho(:,1:100));shading flat;hold on
 tdx = find(time<time(1)+1);
 tmplon=lon(tdx,:);tmplat=lat(tdx,:);good = find(tmplon>0);tmplon=tmplon(good);tmplat=tmplat(good); 
 plot(tmplon,tmplat,'k.' )
 
 aaa=5;


 %% Plot the type 1 float trajectories for each release
 
 midpoint = nSites * nReleases / 2;
 
 fig(5);
 nDays = 1;
 for dd=1:nDays
     clf
     pcolor(grd.lon_rho,grd.lat_rho,grd.mask_rho);shading flat;hold on
     plot(lon(:,dd:60:midpoint),lat(:,dd:60:midpoint),'k')
     title(['Type I release number ',num2str(dd)])
     pause(.5);
 end;
     

 
 %% Plot the type 3 float trajectories for each release
 
 midpoint = nSites * nReleases / 2;
 
 fig(6);
 nDays = 1;
 for dd=1:nDays
     clf
     pcolor(grd.lon_rho,grd.lat_rho,grd.mask_rho);shading flat;hold on
     plot(lon(:,midpoint+dd:60:end),lat(:,midpoint+dd:60:end),'k')
     title(['Release number ',num2str(dd)])
     pause(.5);
 end;
     
 
%% single shots
 
% jMin=50;iMin=75;
% jMax=200;iMax=125;

jMin=1;iMin=1;
jMax=300;iMax=300;

fig(99);clf;
dd=1;
pcolor(grd.lon_rho(jMin:jMax,iMin:iMax),grd.lat_rho(jMin:jMax,iMin:iMax),grd.mask_rho(jMin:jMax,iMin:iMax));shading flat;hold on
plot(lon(:,dd:60:midpoint),lat(:,dd:60:midpoint),'k.')
 
 
 