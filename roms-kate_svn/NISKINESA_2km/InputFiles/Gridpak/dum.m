fileReg = 'NISKINE_SA_2km.nc';
fileTel = '../../../NISKINESAtelescpe_2km/InputFiles/Gridpak/NISKINE_SA_2km_TELESCOPE.nc';

lonReg = nc_varget(fileReg,'lon_psi');
lonTel = nc_varget(fileTel,'lon_psi');

latReg = nc_varget(fileReg,'lat_psi');

lonTelRed = lonTel(1+4:end-4,1+4:end-4);
size(lonReg);
size(lonTelRed);

fig(1);clf;
imagesc(lonReg - lonTelRed);axis xy;colorbar





hReg = nc_varget(fileReg,'h');
hTel = nc_varget(fileTel,'h');

hTelRed = hTel(1+4:end-4,1+4:end-4);
size(hReg);
size(hTelRed);


fig(2);clf;
imagesc(hReg);axis xy;colorbar
fig(3);clf;
imagesc(hTelRed);axis xy;colorbar

%%  Original source

sourceFile = '/import/c1/VERTMIX/jgpender/ROMS/BathyData/topo30.Gridpak_NISKINE.nc';

sourceLat = nc_varget(sourceFile,'topo_lat');
sourceLon = nc_varget(sourceFile,'topo_lon');
sourceTopo = nc_varget(sourceFile,'topo');

sourceLon = sourceLon-100+360; %get rid of longitude offset

%%



lonMin = min(lonReg(:));
lonMax = max(lonReg(:));
latMin = min(latReg(:));
latMax = max(latReg(:));

[imin b] = find( abs(sourceLon - lonMin) == min(abs(sourceLon-lonMin)));
[imax b] = find( abs(sourceLon - lonMax) == min(abs(sourceLon-lonMax)));

[jmin b] = find( abs(sourceLat - latMin) == min(abs(sourceLat-latMin)));
[jmax b] = find( abs(sourceLat - latMax) == min(abs(sourceLat-latMax)));

fig(4);clf
imagesc(-sourceTopo(jmin:jmax,imin:imax));axis xy;colorbar;caxis([1600 3200])

fig(5);clf;
imagesc(hReg);axis xy;colorbar

