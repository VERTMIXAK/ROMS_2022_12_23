icFileOrig = 'CMEMS_2007_091_ic_SCSA_2km.nc_ORIG';
icFile     = 'CMEMS_2007_091_ic_SCSA_2km.nc';


unix(['cp ',icFileOrig,' ',icFile]);


%% do temperature

dum = nc_varget(icFile,'temp');
[~,nz,ny,nx] = size(dum);

dumNS = zeros(nt,nz,nx);
dumEW = zeros(nt,nz,ny);

for tt=1:nt
    dumNS(tt,:,:) = sq(dum(1,:,1  ,:  ));
end;
nc_varput(nullBCFile,'temp_south',dumNS);

for tt=1:nt
    dumNS(tt,:,:) = sq(dum(1,:,end,:  ));
end;
nc_varput(nullBCFile,'temp_north',dumNS);

for tt=1:nt
    dumEW(tt,:,:) = sq(dum(1,:,:  ,1  ));
end;
nc_varput(nullBCFile,'temp_west' ,dumEW);

for tt=1:nt
    dumEW(tt,:,:) = sq(dum(1,:,:  ,end));
end;
nc_varput(nullBCFile,'temp_east' ,dumEW);


%% do salt

dum = nc_varget(icFile,'salt');
[~,nz,ny,nx] = size(dum);

dumNS = zeros(nt,nz,nx);
dumEW = zeros(nt,nz,ny);

for tt=1:nt
    dumNS(tt,:,:) = sq(dum(1,:,1  ,:  ));
end;
nc_varput(nullBCFile,'salt_south',dumNS);

for tt=1:nt
    dumNS(tt,:,:) = sq(dum(1,:,end,:  ));
end;
nc_varput(nullBCFile,'salt_north',dumNS);

for tt=1:nt
    dumEW(tt,:,:) = sq(dum(1,:,:  ,1  ));
end;
nc_varput(nullBCFile,'salt_west' ,dumEW);

for tt=1:nt
    dumEW(tt,:,:) = sq(dum(1,:,:  ,end));
end;
nc_varput(nullBCFile,'salt_east' ,dumEW);


%% do zeta

[nt,nx] = size( nc_varget(nullBCFile,'zeta_south') );
nc_varput(nullBCFile,'zeta_south' ,zeros(nt,nx) );
nc_varput(nullBCFile,'zeta_north' ,zeros(nt,nx) );

[nt,ny] = size( nc_varget(nullBCFile,'zeta_west') );
nc_varput(nullBCFile,'zeta_west' ,zeros(nt,ny) );
nc_varput(nullBCFile,'zeta_east' ,zeros(nt,ny) );

%% do u,ubar

[~,nz,ny,nx] = size( nc_varget(icFile,'u') ); 


nc_varput(nullBCFile,'ubar_south' ,zeros(nt,nx) );
nc_varput(nullBCFile,'ubar_north' ,zeros(nt,nx) );

nc_varput(nullBCFile,'ubar_west' ,zeros(nt,ny) );
nc_varput(nullBCFile,'ubar_east' ,zeros(nt,ny) );



nc_varput(nullBCFile,'u_south' ,zeros(nt,nz,nx) );
nc_varput(nullBCFile,'u_north' ,zeros(nt,nz,nx) );

nc_varput(nullBCFile,'u_west' ,zeros(nt,nz,ny) );
nc_varput(nullBCFile,'u_east' ,zeros(nt,nz,ny) );

%% do u,ubar

[~,nz,ny,nx] = size( nc_varget(icFile,'v') ); 


nc_varput(nullBCFile,'vbar_south' ,zeros(nt,nx) );
nc_varput(nullBCFile,'vbar_north' ,zeros(nt,nx) );

nc_varput(nullBCFile,'vbar_west' ,zeros(nt,ny) );
nc_varput(nullBCFile,'vbar_east' ,zeros(nt,ny) );



nc_varput(nullBCFile,'v_south' ,zeros(nt,nz,nx) );
nc_varput(nullBCFile,'v_north' ,zeros(nt,nz,nx) );

nc_varput(nullBCFile,'v_west' ,zeros(nt,nz,ny) );
nc_varput(nullBCFile,'v_east' ,zeros(nt,nz,ny) );