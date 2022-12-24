oldFile = 'NISKINEC_2km_tides.nc';
newFile = 'NISKINEC_2km_O1.nc';

unix(['cp ',oldFile,' ',newFile]);

dum = nc_varget(newFile,'tide_name')
[nNames,~] = size(dum)

keepN = 2;
dum(2,:)


dum = nc_varget(newFile,'tide_Eamp');
for nn=1:nNames
    if nn ~= keepN
        dum(nn,:,:) = 0;
end;end
nc_varput(newFile,'tide_Eamp',dum);

dum = nc_varget(newFile,'tide_Cmax');
for nn=1:nNames
    if nn ~= keepN
        dum(nn,:,:) = 0;
end;end
nc_varput(newFile,'tide_Cmax',dum);

dum = nc_varget(newFile,'tide_Cmin');
for nn=1:nNames
    if nn ~= keepN
        dum(nn,:,:) = 0;
end;end
nc_varput(newFile,'tide_Cmin',dum);
