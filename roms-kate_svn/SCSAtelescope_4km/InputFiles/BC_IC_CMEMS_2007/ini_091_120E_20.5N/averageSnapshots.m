file1 = 'CMEMS_2007_090.5_ic_SCSAtelescope_4km.nc';
file2 = 'CMEMS_2007_091.5_ic_SCSAtelescope_4km.nc';
outFile = 'CMEMS_2007_091_ic_SCSAtelescope_4km.nc';

unix(['cp ',file1,' ',outFile]);

var = 'ocean_time';
dum1 = nc_varget(file1,var);
dum2 = nc_varget(file2,var);
dum  = (dum1 + dum2)/2;
nc_varput(outFile,var,dum);


var = 'zeta';
dum1 = nc_varget(file1,var);
dum2 = nc_varget(file2,var);
dum  = (dum1 + dum2)/2;
[ny,nx]=size(dum);
tmp = zeros(1,ny,nx);
tmp(1,:,:) = dum;
nc_varput(outFile,var,tmp);


var = 'temp';
dum1 = nc_varget(file1,var);
dum2 = nc_varget(file2,var);
dum  = (dum1 + dum2)/2;
[nz,ny,nx]=size(dum);
tmp = zeros(1,nz,ny,nx);
tmp(1,:,:,:) = dum;
nc_varput(outFile,var,tmp);

var = 'salt';
dum1 = nc_varget(file1,var);
dum2 = nc_varget(file2,var);
dum  = (dum1 + dum2)/2;
[nz,ny,nx]=size(dum);
tmp = zeros(1,nz,ny,nx);
tmp(1,:,:,:) = dum;
nc_varput(outFile,var,tmp);


var = 'u';
dum1 = nc_varget(file1,var);
dum2 = nc_varget(file2,var);
dum  = (dum1 + dum2)/2;
[nz,ny,nx]=size(dum);
tmp = zeros(1,nz,ny,nx);
tmp(1,:,:,:) = dum;
nc_varput(outFile,var,tmp);



var = 'ubar';
dum1 = nc_varget(file1,var);
dum2 = nc_varget(file2,var);
dum  = (dum1 + dum2)/2;
[ny,nx]=size(dum);
tmp = zeros(1,ny,nx);
tmp(1,:,:) = dum;
nc_varput(outFile,var,tmp);


var = 'v';
dum1 = nc_varget(file1,var);
dum2 = nc_varget(file2,var);
dum  = (dum1 + dum2)/2;
[nz,ny,nx]=size(dum);
tmp = zeros(1,nz,ny,nx);
tmp(1,:,:,:) = dum;
nc_varput(outFile,var,tmp);



var = 'vbar';
dum1 = nc_varget(file1,var);
dum2 = nc_varget(file2,var);
dum  = (dum1 + dum2)/2;
[ny,nx]=size(dum);
tmp = zeros(1,ny,nx);
tmp(1,:,:) = dum;
nc_varput(outFile,var,tmp);

