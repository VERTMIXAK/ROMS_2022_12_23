clear; close all

rstFile = 'netcdfOutput_days001_121/barrow_rst.nc';
newRSTFile = 'netcdfOutput_days001_121/barrow_rst2.nc';

gridFile = 'BARROWB_2km.nc';
HISFile = 'netcdfOutput_days001_121/barrow_his_00001.nc';

grd = roms_get_grid(gridFile,HISFile,0,1);

unix(['cp ',rstFile,' ',newRSTFile]);
% unix(['ncks -d ocean_time,0 ',rstFile,' ',newRSTFile]);


%% Target the problem

ru    = nc_varget(rstFile,   'ru');
rubar = nc_varget(rstFile,'rubar');

[ntU,nU,nzU,nyU,nxU] = size(ru);
[ntUbar,nUbar,nyUbar,nxUbar] = size(rubar);

rv    = nc_varget(rstFile,   'rv');
rvbar = nc_varget(rstFile,'rvbar');

[ntV,nV,nzV,nyV,nxV] = size(rv);
[ntVbar,nVbar,nyVbar,nxVbar] = size(rvbar);

% deltaY=5;
% 
% myY = 254;
% myX = 428;
% myZ = nzU;

ymin = 130; ymax=330;
xmin = nxU - 12;
myZ = 1;

% myY = 100;
% myX = 200;

% fig(1);clf;imagesc(1:nxU,1:nyU,sq(ru(3,1,30,:,:)));axis xy;xlim([myX-delta myX+delta]);ylim([myY-delta myY+delta]);colorbar;
% fig(2);clf;imagesc(1:nxU,1:nyU,sq(ru(2,1,30,:,:)));axis xy;xlim([myX-delta myX+delta]);ylim([myY-delta myY+delta]);colorbar;
% fig(3);clf;imagesc(1:nxU,1:nyU,sq(ru(3,1,myZ,myY-delta:myY+delta,myX-delta:min(myX+delta,nxU))));axis xy;colorbar;caxis([-500 500])
% fig(4);clf;imagesc(1:nxU,1:nyU,sq(ru(2,1,myZ,myY-delta:myY+delta,myX-delta:min(myX+delta,nxU))));axis xy;colorbar;caxis([-500 500])
fig(3);clf;imagesc(xmin:nxU,ymin:ymax,sq(ru(3,1,myZ,ymin:ymax,xmin:nxU)));axis xy;colorbar;caxis(10^7*[-1 1])
fig(4);clf;imagesc(xmin:nxU,ymin:ymax,sq(ru(2,1,myZ,ymin:ymax,xmin:nxU)));axis xy;colorbar;caxis(10^7*[-1 1])

fig(13);clf;imagesc(xmin:nxU,ymin:ymax,sq(rubar(3,1,ymin:ymax,xmin:nxU)));axis xy;colorbar;caxis(10^6*[-1 1])
fig(14);clf;imagesc(xmin:nxU,ymin:ymax,sq(rubar(2,1,ymin:ymax,xmin:nxU)));axis xy;colorbar;caxis(10^6*[-1 1])

aaa=5;

%% check defn of rubar

% myI=100; myJ = 150;
% dot(sq(u(1,1,:,myJ,myI)),diff(grd.z_uw(:,myJ,myI))) / sum(diff(grd.z_uw(:,myJ,myI)))
% ubar(1,1,myJ,myI)

%% U

Ulimit = 1*10^6;
myLimit = 7*10^6;
dum = sq(ru(3,1,myZ,:,:));
fig(10);clf;imagesc(1:nxU,1:nyU,dum);axis xy;colorbar;caxis(myLimit*[-1 1]);title('U');

dum(abs(dum)>Ulimit) = Ulimit* sign(dum(abs(dum)>Ulimit)) ;
fig(11);clf;imagesc(1:nxU,1:nyU,dum);axis xy;colorbar;caxis(myLimit*[-1 1]);title('U');

ru(abs(ru)>Ulimit) = Ulimit* sign(ru(abs(ru)>Ulimit));
nc_varput(newRSTFile,'ru',ru);

%% Ubar

Ubarlimit = 4*10^4;
myLimit = 3*10^5;
dum = sq(rubar(3,1,:,:));
fig(10);clf;imagesc(1:nxUbar,1:nyUbar,dum);axis xy;colorbar;caxis(myLimit*[-1 1]);title('Ubar');

dum(abs(dum)>Ubarlimit) = Ubarlimit* sign(dum(abs(dum)>Ubarlimit)) ;
fig(11);clf;imagesc(1:nxUbar,1:nyUbar,dum);axis xy;colorbar;caxis(myLimit*[-1 1]);title('Ubar');

rubar(abs(rubar)>Ubarlimit) = Ubarlimit* sign(rubar(abs(rubar)>Ubarlimit));
nc_varput(newRSTFile,'rubar',rubar);


%% V

Vlimit = 1*10^6;
myLimit = 7*10^6;
dum = sq(rv(3,1,myZ,:,:));
fig(10);clf;imagesc(1:nxV,1:nyV,dum);axis xy;colorbar;caxis(myLimit*[-1 1]);title('V');

dum(abs(dum)>Vlimit) = Vlimit* sign(dum(abs(dum)>Vlimit)) ;
fig(11);clf;imagesc(1:nxV,1:nyV,dum);axis xy;colorbar;caxis(myLimit*[-1 1]);title('V');

rv(abs(rv)>Vlimit) = Vlimit* sign(rv(abs(rv)>Vlimit));
nc_varput(newRSTFile,'rv',rv);

%% Vbar

Vbarlimit = 4*10^4;
myLimit = 3*10^5;
dum = sq(rvbar(3,1,:,:));
fig(10);clf;imagesc(1:nxVbar,1:nyVbar,dum);axis xy;colorbar;caxis(myLimit*[-1 1]);title('Vbar');

dum(abs(dum)>Vbarlimit) = Vbarlimit* sign(dum(abs(dum)>Vbarlimit)) ;
fig(11);clf;imagesc(1:nxVbar,1:nyVbar,dum);axis xy;colorbar;caxis(myLimit*[-1 1]);title('Vbar');


rvbar(abs(rvbar)>Vbarlimit) = Vbarlimit* sign(rvbar(abs(rvbar)>Vbarlimit));
nc_varput(newRSTFile,'rvbar',rvbar);



