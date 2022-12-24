gridNoRivers = 'BoB3_4km_noRivers.nc';
gridRivers   = 'BoB3_4km_Rivers.nc';

maskSource   = '../Gridpak_2PixelRivers/BoB3_4km_rivers.nc';

unix(['cp ',gridNoRivers,' ',gridRivers]);

dum = nc_varget(maskSource,'mask_rho');
nc_varput(gridRivers,'mask_rho',dum);

dum = nc_varget(maskSource,'mask_psi');
nc_varput(gridRivers,'mask_psi',dum);

dum = nc_varget(maskSource,'mask_u');
nc_varput(gridRivers,'mask_u',dum);

dum = nc_varget(maskSource,'mask_v');
nc_varput(gridRivers,'mask_v',dum);