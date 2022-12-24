gridFile = '../../Gridpak/SCSA_2km.nc';
ICFile   = 'CMEMS_2007_091_ic_SCSA_2km.nc';

grd = roms_get_grid(gridFile,ICFile,0,1);

imagesc(sq(grd.z_w(1,:,:)));axis xy;colorbar
