clear;

gridFile = 'BARROW_2km.nc'

nc_varget(gridFile,'hraw');h = sq(ans(4,:,:));
lat = nc_varget(gridFile,'lat_rho');
lon = nc_varget(gridFile,'lon_rho');


vLimit=[0,4000];

ivec = [50:70];
jvec = [190:230];



fig(1);pcolor(h);shading flat;colorbar%;caxis([0 8000])


fig(10);clf;
pcolor(ivec,jvec,h(jvec,ivec));shading flat;colorbar;caxis(vLimit);

%%

% use a 4-degree window. This grid has 120 grid points per degree.

smoo = 2;
Dsmoo=lowpass2d(double(vswap(h,nan,0)),smoo,smoo);done

fig(2);pcolor(Dsmoo);shading flat;colorbar;%caxis([0 8000])

fig(20);clf;
pcolor(ivec,jvec,Dsmoo(jvec,ivec));shading flat;colorbar;caxis(vLimit);

aaa=5;


%%

% % make a mask
% 
% smoo2=round(.5*smoo);
% 
% mask = 0*h;
% 
% mask(:,[1:smoo2]      )=1;% W
% 
% mask(:,[end-smoo2:end])=1;% E
% 
% mask([1:smoo2]      ,:)=1;% S
% 
% mask([end-smoo2:end],:)=1;% S
% 
% mask = lowpass2d(mask,smoo2,smoo2);
% 
% Dmerge = (mask).*h+(1-mask).*Dsmoo;
% 
% fig(3);pcolor(Dmerge);shading flat;colorbar;caxis([0 8000])

%% write the smoothed bathymetry to hmax(5)

hraw = nc_varget(gridFile,'hraw');
size(hraw)
hraw(5,:,:) = Dsmoo;
nc_varput(gridFile,'hraw',hraw)


%% the new bathy is all submerged, so fix the land masks

% mask_dum = nc_varget(gridFile,'mask_rho');
% nc_varput(gridFile,'mask_rho',ones(size(mask_dum)) );
% 
% mask_dum = nc_varget(gridFile,'mask_u');
% nc_varput(gridFile,'mask_u',ones(size(mask_dum)) );
% 
% mask_dum = nc_varget(gridFile,'mask_v');
% nc_varput(gridFile,'mask_v',ones(size(mask_dum)) );
% 
% mask_dum = nc_varget(gridFile,'mask_psi');
% nc_varput(gridFile,'mask_psi',ones(size(mask_dum)) );







