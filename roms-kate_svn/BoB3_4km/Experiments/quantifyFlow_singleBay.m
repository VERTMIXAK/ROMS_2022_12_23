clear;

bayFile  = '../InputFiles/Runoff_mod/Bay_Bengal_runoff_2013.nc';
jraFile  = '../InputFiles/Runoff_mod/JRA_jgp_2013_constant.nc';
jraFileKate  = '../InputFiles/Runoff_originalGrid/JRA_BoB_rivers_2013.nc';
HISFile0 = 'scheduleForDeletion2/BoB3_4km_2013_305_mesoNoTides_noFreshwater/netcdfOutput/bob_his_00001.nc';
HISFile  = 'scheduleForDeletion2/BoB3_4km_2013_305_mesoNoTides_Freshwater/netcdfOutput/bob_his_00001.nc';
gridFile = 'scheduleForDeletion2/BoB3_4km_2013_305_mesoNoTides_Freshwater/BoB3_4km.nc';

grid = roms_get_grid(gridFile,HISFile,0,1);


x = nc_varget(jraFile,'river_Xposition');
y = nc_varget(jraFile,'river_Eposition');
flow = nc_varget(jraFile,'river_transport');
sign = nc_varget(jraFile,'river_sign');
direction = nc_varget(jraFile,'river_direction');
vshape = nc_varget(jraFile,'river_Vshape');

masku = grid.mask_u;
maskv = grid.mask_v;
maskrho = grid.mask_rho;

u0    = nc_varget(HISFile0,'u');
v0    = nc_varget(HISFile0,'v');
zeta0 = nc_varget(HISFile0,'zeta');

u     = nc_varget(HISFile ,'u');
v     = nc_varget(HISFile ,'v');
zeta  = nc_varget(HISFile ,'zeta');

[nt ny nx] = size(zeta);

fig(1);clf;
imagesc(262:270,173:178,maskrho(173:178,262:270));axis xy


day=305;
range=372:385;
% for rr=372:385
%     [rr,direction(rr),flow(day,rr)]
% end;

[range', x(range), y(range), direction(range), sq(flow(day,range))']


aaa=5;

flowKate = nc_varget(jraFileKate,'river_transport');
directionKate = nc_varget(jraFileKate,'river_direction');
xKate = nc_varget(jraFileKate,'river_Xposition');
yKate = nc_varget(jraFileKate,'river_Eposition');
day=305;

rangeKate=372:385;

[rangeKate', x(rangeKate), y(rangeKate), directionKate(rangeKate), sq(flowKate(day,rangeKate))']







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



fig(999);clf
imagesc(269-10:269+5,177-10:177+5,log(myMat305(177-10:177+5,269-10:269+5)));shading flat;colorbar;axis xy;%caxis([000 7000])
title('log(flow)')
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

fig(10);clf
plot(rmin:rmax,sq(flow(305,rmin:rmax) .* sign(rmin:rmax)'))
title('flow vs river index')

% fig(21);clf;
% imagesc(flow(:,rmin:rmax));shading flat;colorbar

xmin = min( x(rmin:rmax) );xmax = max( x(rmin:rmax) )+1;
ymin = min( y(rmin:rmax) );ymax = max( y(rmin:rmax) )+1;

%%

fig(11);clf;
imagesc(xmin:xmax,ymin:ymax,log(myMat305(ymin:ymax,xmin:xmax) ) );colorbar;axis xy
title('log(flow)')
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

%% Look at a specific pair of river source points


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


x1=min(x(rmin:rmax))-2 ;
x2=max(x(rmin:rmax))+2 ;
y1=min(y(rmin:rmax))-2 ;
y2=max(y(rmin:rmax))+2 ;

% Try to get oriented with the u and v grids.

% umask

fig(20);clf;

imagesc(x1:x2,y1:y2,masku(y1:y2,x1:x2));shading flat;title('u mask');axis xy
hold on
plot(x(rmin:rmax),y(rmin:rmax))


fig(21);clf;
subplot(1,2,1);
imagesc(x1:x2,y1:y2, sq(u0(2,end,y1:y2,x1:x2)));title('u0');axis xy;colorbar;
subplot(1,2,2);
imagesc(x1:x2,y1:y2, sq (u(2,end,y1:y2,x1:x2)));title( 'u');axis xy;colorbar;caxis([-.5 0])


sq(u(end,end,y1:y2,x1:x2));abs(ans);max(ans(:))
ans * 5 * 4000



% vmask



fig(22);clf;
imagesc(x1:x2,y1:y2,maskv(y1:y2,x1:x2));shading flat;title('v mask');axis xy
hold on
plot(x(rmin:rmax),y(rmin:rmax))


fig(23);clf;
subplot(1,2,1);
imagesc(x1:x2,y1:y2,sq(v0(2,end,y1:y2,x1:x2)));title('v0');axis xy;colorbar;
subplot(1,2,2);
imagesc(x1:x2,y1:y2,sq( v(2,end,y1:y2,x1:x2)));title('v' );axis xy;colorbar;caxis([-.5 0])

%% largest 'v' cell

myVj = 177;
myVi = 269;

% The v flow represented by these i,j indices comes from 
%   flow(305,377)

v(:,end,myVj,myVi);


% largest 'u' cell

myUj = 177;
myUi = 269;

% The u flow represented by these i,j indices comes from 
%   flow(305,378)

u(:,end,myUj,myUi);


% fig(99);
% plot(v(:,end,myVj,myVi));
% hold on;
% plot(u(:,end,myUj,myUi))


% What I want to do here is compare the integrated flow number from the JRA
% file to the integrated flow coming from the extra u and v cells.

% dt=40;

snapshot=8;

% The flow into the system should be
%
%   vel(m/s) * height(m) * width(m) = m^3/s
%
% There is some ambiguity here because of zeta. I recall an email
% conversation with Kate to the effect that all of the z values get
% stretched when zeta > 0. 

% !!!!!!!!!!!!!!!!!!!!
% I don't know why the second one works (divide zeta by 2. Huh?)
% myStretch=( grid.h(myUj,myUi)+ zeta(snapshot,myUj,myUi) ) / grid.h(myUj,myUi);

% myStretch=( grid.h(myUj,myUi)+ zeta(snapshot,myUj,myUi) ) / grid.h(myUj,myUi);

% myStretch=( -grid.z_uw(1,myUj,myUi)+ zeta(snapshot,myUj,myUi) ) / -grid.z_uw(1,myUj,myUi)
myStretchU=( -grid.z_uw(1,myUj,myUi)+ zeta(snapshot,myUj,myUi)/2 ) / -grid.z_uw(1,myUj,myUi);
myStretchV=( -grid.z_vw(1,myUj,myUi)+ zeta(snapshot,myUj,myUi)/2 ) / -grid.z_vw(1,myUj,myUi);
% myStretch=1

u(snapshot,:,myUj,myUi) .* diff(grid.z_uw(:,myUj,myUi))' * myStretchU;
massu = sum(ans)/grid.pn(myUj,myUi) ;
fprintf('mass flow u is\n\n %10.2f \n\n',massu);

v(snapshot,:,myVj,myVi) .* diff(grid.z_vw(:,myVj,myVi))' * myStretchV;
massv = sum(ans)/grid.pm(myVj,myVi);
fprintf('mass flow v is\n\n %10.2f \n\n',massv);


% Now I need to turn the river.transport parameter and the river.vshape
% parameter into volume flow. It looks to me like river.transport is the
% integrated quantity, which is what I've calculated above. 

fprintf('mass flow from JRA file is\n\n %10.2f  %10.2f \n\n',flow(305,377:378));


%% Do the whole set of timestamps.

massUvec=0*[2:nt];
massVvec=0*[2:nt];

for tt=2:nt
    stretchU=( -grid.z_uw(1,myUj,myUi)+ zeta(tt,myUj,myUi)/2 ) / -grid.z_uw(1,myUj,myUi);
    stretchV=( -grid.z_vw(1,myUj,myUi)+ zeta(tt,myUj,myUi)/2 ) / -grid.z_vw(1,myUj,myUi);
%     stretch = ( grid.h(myUj,myUi)+ zeta(tt,myUj,myUi)/2 ) / grid.h(myUj,myUi)
%     stretch = 1;
    massUvec(tt) =sum( u(tt,:,myUj,myUi) .* diff(grid.z_uw(:,myUj,myUi))' ) / grid.pn(myUj,myUi) * stretchU;
    massVvec(tt) =sum( v(tt,:,myVj,myVi) .* diff(grid.z_vw(:,myVj,myVi))' ) / grid.pm(myVj,myVi) * stretchV;
end;


% How does zeta correlate with u and v at the source tile?

fig(30);clf
subplot(2,1,1);plot(sq(zeta(2:end,myUj,myUi)));title('zeta')
subplot(2,1,2);plot(sq(u(2:end,end,myUj,myUi)));title('u and v')
hold on;
plot(sq(v(2:end,end,myVj,myVi)),'r')

% Ha! u and v do correlate with zeta. Specifically, the velocity drops when 
% zeta increases, which is what you'd expect for constant volume flow.
% Now I have to figure out how.


fig(31);clf
plot(massUvec(2:nt));title('volumeU and volumeV')
hold on;
plot(massVvec(2:nt),'k');
plot(flow(2:nt,r1),'r')


%% 

xlim=myUi-4:myUi+1;
ylim=myUj-4:myUj+1;
fig(40);clf;

subplot(2,1,1)
sq( u0(8,end,ylim,xlim) );
imagesc(xlim,ylim,ans);axis xy;caxis(.5*[-1 1]);colorbar
title('u0')

subplot(2,1,2)
sq( u(8,end,ylim,xlim) );
imagesc(xlim,ylim,ans);axis xy;caxis(.5*[-1 1]);colorbar
title('u')
 
xlim=myVi-4:myVi+1;
ylim=myVj-4:myVj+1;
fig(41);clf;

subplot(2,1,1)
sq( v0(8,end,ylim,xlim) );
imagesc(xlim,ylim,ans);axis xy;caxis(.5*[-1 1]);colorbar
title('v0')

subplot(2,1,2)
sq( v(8,end,ylim,xlim) );
imagesc(xlim,ylim,ans);axis xy;caxis(.5*[-1 1]);colorbar
title('v')

