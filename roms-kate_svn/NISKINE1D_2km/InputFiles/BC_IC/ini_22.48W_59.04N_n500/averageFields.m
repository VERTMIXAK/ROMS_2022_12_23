icFile    = 'IC.nc';

dum = nc_varget(icFile,'temp');
[nz,ny,nx] = size(dum)
dum2=zeros(1,nz,ny,nx);
for kk=1:nz
    dum(kk,:,:);
    dum2(1,kk,:,:) = nanmean(ans(:));
end;
nc_varput(icFile,'temp',dum2);

dum = nc_varget(icFile,'salt');
[nz,ny,nx] = size(dum)
dum2=zeros(1,nz,ny,nx);
for kk=1:nz
    dum(kk,:,:);
    dum2(1,kk,:,:) = nanmean(ans(:));
end;
nc_varput(icFile,'salt',dum2);

dum = nc_varget(icFile,'u');
[nz,ny,nx] = size(dum)
dum2=zeros(1,nz,ny,nx);
nc_varput(icFile,'u',0*dum2);

dum = nc_varget(icFile,'v');
[nz,ny,nx] = size(dum)
dum2=zeros(1,nz,ny,nx);
nc_varput(icFile,'v',0*dum2);

dum = nc_varget(icFile,'ubar');
[ny,nx] = size(dum)
dum2=zeros(1,ny,nx);
nc_varput(icFile,'ubar',0*dum2);

dum = nc_varget(icFile,'vbar');
[ny,nx] = size(dum)
dum2=zeros(1,ny,nx);
nc_varput(icFile,'vbar',0*dum2);

dum = nc_varget(icFile,'zeta');
[ny,nx] = size(dum)
dum2=zeros(1,ny,nx);
nc_varput(icFile,'zeta',0*dum2);


