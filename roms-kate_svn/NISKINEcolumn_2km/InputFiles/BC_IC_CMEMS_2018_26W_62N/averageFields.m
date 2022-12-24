bcFileOld = 'CMEMS_2018_bdry_NISKINEcolumn_2km.nc_ORIG';
bcFile    = 'CMEMS_2018_bdry_NISKINEcolumn_2km.nc';

unix(['cp ',bcFileOld,' ',bcFile])


fields1 = {
    'ubar_east',
    'ubar_west',
    'ubar_north',
    'ubar_south',
    'vbar_east',
    'vbar_west',
    'vbar_north',
    'vbar_south',
    'zeta_east',
    'zeta_west',
    'zeta_north',
    'zeta_south',
    'u_east',
    'u_west',
    'u_north',
    'u_south',
    'v_east',
    'v_west',
    'v_north',
    'v_south',
    };



fields2 = {
    'salt_east',
    'salt_west',
    'salt_north',
    'salt_south',
    'temp_east',
    'temp_west',
    'temp_north',
    'temp_south'
    };

%% fields that are zeroed out

for nn=1:length(fields1)
    dum = nc_varget(bcFile,fields1{nn});
    nc_varput(bcFile,fields1{nn},0*dum);
end;


%% fields that are averaged


for nn=1:length(fields2)
    vName = fields2{nn};
    dum = nc_varget(bcFile,vName);
    
    [nt,nz,nx] = size(dum)
    for tt=1:nt;
        for kk=1:nz
            dum(tt,kk,:);
            dum(tt,kk,:) = nanmean(ans(:));
        end;end;
    nc_varput(bcFile,vName,dum);
    
end;

