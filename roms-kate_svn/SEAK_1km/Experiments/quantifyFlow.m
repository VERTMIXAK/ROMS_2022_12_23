clear;

% bayFile  = '../InputFiles/Runoff_mod/Bay_Bengal_runoff_2013.nc';
jraFile  = '../InputFiles/Runoff/JRA-1.4_SEAK_rivers_2017.nc';
HISFile0 = 'SEAK_1km_2017_190_meso_8tides_addRivers/netcdfOutput/seak_his_00001.nc';
HISFile  = 'SEAK_1km_2017_190_meso_8tides_addRivers/netcdfOutput/seak_his_00001.nc';
gridFile = 'SEAK_1km_2017_190_meso_8tides_addRivers/SEAK_1km.nc';

grd = roms_get_grid(gridFile,HISFile,0,1);


aaa=5;


x = nc_varget(jraFile,'river_Xposition');
y = nc_varget(jraFile,'river_Eposition');
flow = nc_varget(jraFile,'river_transport');
sign = nc_varget(jraFile,'river_sign');
direction = nc_varget(jraFile,'river_direction');
vshape = nc_varget(jraFile,'river_Vshape');

u0 = nc_varget(HISFile0,'u');
v0 = nc_varget(HISFile0,'v');

u  = nc_varget(HISFile ,'u');
v  = nc_varget(HISFile ,'v');

[ny nx] = size(grd.mask_rho);
[nt nr] = size(flow);

lon0 = min(grd.lon_rho(:)) - 360;
lat0 = min(grd.lat_rho(:))
lon1 = max(grd.lon_rho(:)) - 360;
lat1 = max(grd.lat_rho(:))

bb = [ [lon0;lon1]  [lat0;lat1] ]

hls_get_wvs(bb);


aaa=5;


%% look at flow

load('coastCheck.mat');

flow2D = zeros(nt,ny,nx);
for nn = 1:length(x);
    flow2D(:,y(nn),x(nn)) = flow(:,nn);
end;

fig(50);clf
pcolor(grd.lon_rho,grd.lat_rho,sq(flow2D(190,:,:))  );shading flat;colorbar;
hold on;
plot(wvs.lon+360,wvs.lat)

fig(51);clf
pcolor(sq(flow2D(190,:,:))  );shading flat;colorbar;


ivec = [250:450];
jvec = [300:350];

fig(52);clf
pcolor(ivec,jvec,sq(flow2D(190,jvec,ivec))  );shading flat;colorbar;

fig(53);clf
pcolor(grd.lon_rho(jvec,ivec),grd.lat_rho(jvec,ivec),sq(flow2D(190,jvec,ivec)) );shading flat;colorbar;
hold on;
plot(wvs.lon+360,wvs.lat)



aaa=5;





%% Reference everything to 1 Nov 2013 12:00, which is day number 305

% "Matricise" the flow data so that you can plot it with imagesc
% Note that flow times sign is always positive.

day = 305;
myMat305 = zeros(ny,nx);
for nn=1:length(x)
    myMat305(y(nn),x(nn)) = flow(day,nn) * sign(nn);
%     myMat305(y(nn),x(nn)) = abs( flow(day,nn) );
end;

aaa=5;
fig(1);clf
imagesc(myMat305);shading flat;colorbar;caxis([000 7000]);axis xy
hold on
plot(x,y)

aaa=5;

%% Look closer at a particular section of the coast

% I've fiddled with these limiting values to capture all of a single delta,
% the first one west of the main Ganges delta
% The JRA file only has 2 significant coastal source pixels.

% !!!!!!! Bear in mind that the Xposition and Yposition start counting from
% zero as per netcdf files, and matlab starts counting from 1.


rmin=370;rmax=385;
% rmin=350;rmax=425;

fig(10);clf;
plot(sq(flow(305,rmin:rmax) .* sign(rmin:rmax)'))

% fig(21);clf;
% imagesc(flow(:,rmin:rmax));shading flat;colorbar

xmin = min( x(rmin:rmax) );xmax = max( x(rmin:rmax) )+1;
ymin = min( y(rmin:rmax) );ymax = max( y(rmin:rmax) )+1;

%%

fig(11);clf;
imagesc(xmin:xmax,ymin:ymax,myMat305(ymin:ymax,xmin:xmax));colorbar;axis xy
caxis([000 10])
hold on
plot(x(rmin:rmax),y(rmin:rmax))

%%

% Note that the indices in the JRA file begin with 1 even though they are
% embedded in a netcdf file which starts counting from 0.

% If you compare the rho mask to the nonzero elements in the flow data you
% see that there's some flow data which is actually under the rho mask.
fig(12);clf;
imagesc(xmin:xmax,ymin:ymax,maskrho(ymin:ymax,xmin:xmax));title('rho mask');axis xy
hold on
plot(x(rmin:rmax),y(rmin:rmax));title('rho mask')

aaa=5;

%% Look at a specific pair of 


% Notice 
% 1) these two pixels dominate the flow on this section of
% 2) they don't share a face; i.e. the corners touch


% The u grid and the vgrid are shifted wrt the rho grid, so the safest way
% to figure out where the river code is adding freshwater is to look at u
% and u0 in this area, as well as v and v0.

aaa=5;

r1=377;r2=378;

x(r1:r2)
y(r1:r2)

[flow(305,r1:r2)',sign(r1:r2),direction(r1:r2)  ]
% [flow(305,r2)',sign(r2),direction(r2)  ]

% Try to get oriented with the u and v grids.

% umask

fig(20);clf;
x1=min(x(rmin:rmax)) ;
x2=max(x(rmin:rmax)) ;
y1=min(y(rmin:rmax)) ;
y2=max(y(rmin:rmax)) ;
imagesc(x1:x2,y1:y2,masku(y1+1:y2+1,x1+1:x2+1));shading flat;title('u mask');axis xy
hold on
plot(x(rmin:rmax),y(rmin:rmax))



fig(21);clf;
subplot(1,2,1);
imagesc(sq(u0(end,end,y1+1-2:y2+1+2,x1+1-2:x2+1+2)));title('u0');colorbar;axis xy
subplot(1,2,2);
imagesc(sq(u(end,end,y1+1-2:y2+1+2,x1+1-2:x2+1+2)));title('u');colorbar;axis xy;caxis([-.03 .03])

sq(u(end,end,y1+1-2:y2+1+2,x1+1-2:x2+1+2));abs(ans);max(ans(:))
ans * 5 * 4000



% vmask



fig(22);clf;
x1=min(x(rmin:rmax)) ;
x2=max(x(rmin:rmax)) ;
y1=min(y(rmin:rmax)) ;
y2=max(y(rmin:rmax)) ;
imagesc(x1:x2,y1:y2,maskv(y1+1:y2+1,x1+1:x2+1));shading flat;title('v mask');axis xy
hold on
plot(x(rmin:rmax),y(rmin:rmax))

fig(23);clf;
subplot(1,2,1);
imagesc(sq(v0(end,end,y1+1-2:y2+1+2,x1+1-2:x2+1+2)));title('v0');colorbar;axis xy
subplot(1,2,2);
imagesc(sq(v(end,end,y1+1-2:y2+1+2,x1+1-2:x2+1+2)));title('v0');colorbar;axis xy




%% imagesc vs imagesc


% a=ones(4,4);a(:)=1:16
% x=1:4
% y=1:4
% fig(1);clf;colormap(jet(16))
% subplot(2,1,1);imagesc(x,y,a);shading flat;axis equal tight; caxis([1 16]);colorbar;axis xy
% subplot(2,1,2);imagesc(x,y,a);shading flat;axis equal tight; caxis([1 16]);colorbar;axis xy





