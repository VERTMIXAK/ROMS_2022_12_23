icFileOld = 'CMEMS_2018_124_ic_NISKINEcolumn_2km.nc_ORIG';
icFile    = 'CMEMS_2018_124_ic_NISKINEcolumn_2km.nc';

unix(['cp ',icFileOld,' ',icFile])

% fields1 = {
%     'ubar_east',
%     'ubar_west',
%     'ubar_north',
%     'ubar_south'
%         }
%     
%     
%    for ii=1:length(fields1)
%        fields1(ii)
%    end
    

dum = nc_varget(icFile,'temp');
[nt,nz,ny,nx] = size(dum)
for kk=1:nz
    dum(1,kk,:,:);
    dum(1,kk,:,:) = nanmean(ans(:));
end;
nc_varput(icFile,'temp',dum);

dum = nc_varget(icFile,'salt');
[nt,nz,ny,nx] = size(dum)
for kk=1:nz
    dum(1,kk,:,:);
    dum(1,kk,:,:) = nanmean(ans(:));
end;
nc_varput(icFile,'salt',dum);

dum = nc_varget(icFile,'u');
nc_varput(icFile,'u',0*dum);

dum = nc_varget(icFile,'v');
nc_varput(icFile,'v',0*dum);

dum = nc_varget(icFile,'ubar');
nc_varput(icFile,'ubar',0*dum);

dum = nc_varget(icFile,'vbar');
nc_varput(icFile,'vbar',0*dum);

dum = nc_varget(icFile,'zeta');
nc_varput(icFile,'zeta',0*dum);


