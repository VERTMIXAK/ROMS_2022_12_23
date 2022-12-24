clear;

gridFile = 'BARROW_500m.nc'

nc_varget(gridFile,'hraw');h = sq(ans(4,:,:));
lat = nc_varget(gridFile,'lat_rho');
lon = nc_varget(gridFile,'lon_rho');
mask = nc_varget(gridFile,'mask_rho');


vLimit=[0,4000];

ivec = 2*[100:140];
jvec = 2*[380:460];



fig(1);pcolor(h);shading flat;colorbar%;caxis([0 8000])


fig(10);clf;
pcolor(ivec,jvec,h(jvec,ivec));shading flat;colorbar;caxis(vLimit);

%%


% smoo = 40;
% Dsmoo=lowpass2d(double(vswap(h,nan,0)),smoo,smoo);done

% fsmoo = 1/9;   filter_order = 9;Dsmoo  = hls_lowpassbutter2d(h,fsmoo,fsmoo,1,filter_order);
% fsmoo = 1/20;  filter_order = 9;Dsmoo = hls_lowpassbutter2d(h,fsmoo,fsmoo,1,filter_order);
fsmoo = 1/30;  filter_order = 9;Dsmoo = hls_lowpassbutter2d(h,fsmoo,fsmoo,1,filter_order);


%Get rid of depths less than 5


% Dsmoo(Dsmoo<5) = 5;




fig(2);pcolor(Dsmoo);shading flat;colorbar;%caxis([0 8000])

fig(20);clf;
pcolor(ivec,jvec,Dsmoo(jvec,ivec));shading flat;colorbar;caxis(vLimit);


fig(3);clf;
pcolor(Dsmoo-h);shading flat;colorbar;

fig(30);clf;
pcolor(ivec,jvec,Dsmoo(jvec,ivec)-h(jvec,ivec));shading flat;colorbar;

fig(300);clf;
pcolor(1:50,1:50,Dsmoo(1:50,1:50)-h(1:50,1:50));shading flat;colorbar;

aaa=5;



%% Feather the smoothed bathymetry into the original near the edges.

[ny, nx] = size(h);

width = .10* 1/fsmoo;
delta = 10*width;

% fig(90);clf;
% x=[1:100];
% plot(x,    1./(1+exp(-(x-delta)/width)) )
% 
% fig(91);clf;
% x=[nx-100:nx];
% plot(x,    1./(1+exp(-((nx-x)-delta)/width)) )
% 
% fig(92);clf;
% x=[1:nx];
% plot(x,  1./(1+exp(-(x-delta)/width)) +  1./(1+exp(-((nx-x)-delta)/width)) -1 )

sigmoidMask = 0*h;

for ii=1:nx; for jj=1:ny
    sigmoidMask(jj,ii) = (  1./(1+exp(-(ii-delta)/width)) +  1./(1+exp(-((nx-ii)-delta)/width)) - 1 ) * (  1./(1+exp(-(jj-delta)/width)) +  1./(1+exp(-((ny-jj)-delta)/width)) - 1 );
end;end;

fig(95);clf;
pcolor(sigmoidMask);shading flat;colorbar



newh = h + (Dsmoo - h) .* sigmoidMask;

fig(50);clf
pcolor(newh - h);shading flat;colorbar

fig(51);clf
pcolor(newh(1:50,1:50) - h(1:50,1:50));shading flat;colorbar



% fig(52);clf
% pcolor(newh);shading flat;colorbar;caxis([0 5])
% 
% 
% fig(53);clf
% pcolor(mask);shading flat;colorbar;caxis([0 5])

fig(54);clf
pcolor(mask.*newh);shading flat;colorbar;caxis([0 5])


aaa=5;


%% write the smoothed bathymetry to hmax(5)

hraw = nc_varget(gridFile,'hraw');
size(hraw)
hraw(7,:,:) = newh;
nc_varput(gridFile,'hraw',hraw)

%%

irange=[900:1100];
jrange=[200:250];


fig(98);clf;
pcolor(irange,jrange,sq(Dsmoo(jrange,irange)));shading flat;caxis([0,50]);colorbar

248,
%%

irange=[900:1100];
jrange=[200:250];


fig(99);clf;
pcolor(irange,jrange,sq(hraw(7,jrange,irange)));shading flat;caxis([0,100]);colorbar
