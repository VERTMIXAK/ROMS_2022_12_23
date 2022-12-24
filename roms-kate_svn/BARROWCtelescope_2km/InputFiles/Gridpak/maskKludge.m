oldMaskFile = '../../../BARROWB_2km/InputFiles/Gridpak/BARROWB_2km.nc';
origGridFile = 'BARROWCtelescope_2km.nc_ORIG';
newGridFile = 'BARROWCtelescope_2km.nc';

unix(['cp ',origGridFile,' ','newGridFile']);

oldMask_rho = nc_varget(oldMaskFile,'mask_rho');
oldMask_psi = nc_varget(oldMaskFile,'mask_psi');
oldMask_u   = nc_varget(oldMaskFile,'mask_u');
oldMask_v   = nc_varget(oldMaskFile,'mask_v');

newMask_rho = nc_varget(newGridFile,'mask_rho');
newMask_psi = nc_varget(newGridFile,'mask_psi');
newMask_u   = nc_varget(newGridFile,'mask_u');
newMask_v   = nc_varget(newGridFile,'mask_v');

fig(1);clf;
pcolor(oldMask_rho);shading flat

fig(2);clf;
pcolor(newMask_rho);shading flat



aaa=5;

%%

xShift=1;
[myY, myX] = size(oldMask_rho);

dum = zeros(size(newMask_rho));
dum(1:myY,xShift:xShift+myX-1) = oldMask_rho;

fig(3);clf; pcolor(dum);shading flat
fig(4);clf; pcolor(dum-newMask_rho);shading flat



%%

[ny,nx] = size(oldMask_rho);
newMask_rho(1:ny,1:nx) = oldMask_rho;
nc_varput(newGridFile,'mask_rho',newMask_rho);

[ny,nx] = size(oldMask_psi);
newMask_psi(1:ny,1:nx) = oldMask_psi;
nc_varput(newGridFile,'mask_psi',newMask_psi);

[ny,nx] = size(oldMask_u);
newMask_u(1:ny,1:nx) = oldMask_u;
nc_varput(newGridFile,'mask_u',newMask_u);

[ny,nx] = size(oldMask_v);
newMask_v(1:ny,1:nx) = oldMask_v;
nc_varput(newGridFile,'mask_v',newMask_v);

