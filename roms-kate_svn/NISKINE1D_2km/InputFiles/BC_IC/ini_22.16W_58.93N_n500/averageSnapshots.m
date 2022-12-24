file1 = 'IC_1.nc';
file2 = 'IC_2.nc';
outFile = 'IC.nc';

unix(['cp ',file1,' ',outFile]);

var = 'ocean_time';
dum1 = nc_varget(file1,var);
dum2 = nc_varget(file2,var);
dum  = (dum1 + dum2)/2;
nc_varput(outFile,var,dum);


var = 'zeta';
dum1 = nc_varget(file1,var);
dum2 = nc_varget(file2,var);
[ny nx] = size(dum2);
dum = zeros(1,ny,nx);
dum(1,:,:)  = (dum1 + dum2)/2;
nc_varput(outFile,var,dum);


var = 'temp';
dum1 = nc_varget(file1,var);
dum2 = nc_varget(file2,var);
[nz ny nx] = size(dum2);
dum = zeros(1,nz,ny,nx);
dum(1,:,:,:)  = (dum1 + dum2)/2;
nc_varput(outFile,var,dum);


var = 'salt';
dum1 = nc_varget(file1,var);
dum2 = nc_varget(file2,var);
[nz ny nx] = size(dum2);
dum = zeros(1,nz,ny,nx);
dum(1,:,:,:)  = (dum1 + dum2)/2;
nc_varput(outFile,var,dum);


var = 'u';
dum1 = nc_varget(file1,var);
dum2 = nc_varget(file2,var);
[nz ny nx] = size(dum2);
dum = zeros(1,nz,ny,nx);
dum(1,:,:,:)  = (dum1 + dum2)/2;
nc_varput(outFile,var,dum);


var = 'ubar';
dum1 = nc_varget(file1,var);
dum2 = nc_varget(file2,var);
[ny nx] = size(dum2);
dum = zeros(1,ny,nx);
dum(1,:,:)  = (dum1 + dum2)/2;
nc_varput(outFile,var,dum);


var = 'v';
dum1 = nc_varget(file1,var);
dum2 = nc_varget(file2,var);
[nz ny nx] = size(dum2);
dum = zeros(1,nz,ny,nx);
dum(1,:,:,:)  = (dum1 + dum2)/2;
nc_varput(outFile,var,dum);


var = 'vbar';
dum1 = nc_varget(file1,var);
dum2 = nc_varget(file2,var);
[ny nx] = size(dum2);
dum = zeros(1,ny,nx);
dum(1,:,:)  = (dum1 + dum2)/2;
nc_varput(outFile,var,dum);

