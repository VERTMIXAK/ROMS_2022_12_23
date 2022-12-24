origFile = 'CMEMS_2007_090.5.nc_ORIG';
newFile  = 'CMEMS_2007_090.5.nc';

unix(['cp ',origFile,' ',newFile]);

% zero out motion

dum = nc_varget(newFile,'ssh');
nc_varput(newFile,'ssh',0*dum);

dum = nc_varget(newFile,'u');
nc_varput(newFile,'u',0*dum);

dum = nc_varget(newFile,'v');
nc_varput(newFile,'v',0*dum);

% Find grid point closest to 120E, 20.5N

myLat = 20.5;
myLon = 120;

lat = nc_varget(newFile,'lat1d');
lon = nc_varget(newFile,'lon1d');

[myJ] = find(min( abs(lat - myLat)   ) == lat - myLat)
[myI] = find(min( abs(lon - myLon)   ) == lon - myLon)


% Now make the stratification uniform

dum = nc_varget(newFile,'salt');
[nt,nz,ny,nx] = size(dum);
for kk=1:nz
%     dum(:,kk,myJ,myI)
    dum(:,kk,:,:) = dum(:,kk,myJ,myI);
%     fig(1);clf;imagesc(sq(dum(1,kk,:,:)));colorbar
end;
nc_varput(newFile,'salt',dum);

dum = nc_varget(newFile,'temp');
[nt,nz,ny,nx] = size(dum);
for kk=1:nz
    dum(:,kk,:,:) = dum(:,kk,myJ,myI);
end;
nc_varput(newFile,'temp',dum);
