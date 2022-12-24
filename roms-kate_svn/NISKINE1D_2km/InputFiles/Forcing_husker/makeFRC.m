clear all;

gridFile = '../Gridpak/Grid.nc';

load('husker2018.mat');

grd = roms_get_grid(gridFile);

% The surface forcing data comes with timestamps, which are on 20-minute
% intervals. This data is in days

times = husker2018.fluxes.derived.dnum
datestr(times(1))
datestr(times(2))
timesROMS = times - times(1) + 43237;

aaa=5;

%% lat/lon

% Create a lat/lon grid that more than straddles the NISKINE area.

lon = 360 - fliplr([22:.5:25]);
lat =              [57:.5:60] ;


nt = length(timesROMS);
ny = length(lat);
nx = length(lon);


%% Pair

outFile = 'Pair.nc'
unix(['\rm ',outFile]);

nc_create_empty(outFile,nc_64bit_offset_mode);

% Dimension section
nc_add_dimension(outFile,'lon',length(lon));
nc_add_dimension(outFile,'lat',length(lat));
nc_add_dimension(outFile,'pair_time',0);

% Variables section

dum.Name = 'lon';
dum.Nctype = 'float';
dum.Dimension = {'lon'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'longitude','degrees_east','time, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'lat';
dum.Nctype = 'float';
dum.Dimension = {'lat'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'latitude','degrees_north','time, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'pair_time';
dum.Nctype = 'double';
dum.Dimension = {'pair_time'};
dum.Attribute = struct('Name',{'long_name','units','calendar','field'},'Value',{'time since initialization','days since 1900-01-01 00:00:00','gregorian','time, scalar, series'});
nc_addvar(outFile,dum)

dum.Name = 'Pair';
dum.Nctype = 'float';
dum.Dimension = {'pair_time','lat','lon'};
dum.Attribute = struct('Name',{'long_name','units','time','coordinates','field'},'Value',{'sea_level_pressure','Pa','pair_time','lon lat pair_time','sea-level pressure, scalar, series'});
nc_addvar(outFile,dum);



% Global attributes section

nc_attput(outFile,nc_global,'title', 'NISKINE1D' );
nc_attput(outFile,nc_global,'type', 'ROMS/TOMS history file' );
nc_attput(outFile,nc_global,'format', 'netCDF-3 64bit offset file' );

% Fill in grid data

nc_varput(outFile,'lat',lat);
nc_varput(outFile,'lon',lon);
nc_varput(outFile,'pair_time',timesROMS);

% convert millibar to Pa with a factor of 100
husker = husker2018.fluxes.inputs.P;
husker(1) = husker(2);

pairVec = husker;  % Qsat needs Pair in mB

husker = 100 * husker;



pair = zeros(nt,ny,nx);
for tt=1:nt
    pair(tt,:,:) = husker(tt);
end;
nc_varput(outFile,'Pair',pair);


%% Tair

outFile = 'Tair.nc'
unix(['\rm ',outFile]);

nc_create_empty(outFile,nc_64bit_offset_mode);

% Dimension section
nc_add_dimension(outFile,'lon',length(lon));
nc_add_dimension(outFile,'lat',length(lat));
nc_add_dimension(outFile,'tair_time',0);

% Variables section

dum.Name = 'lon';
dum.Nctype = 'float';
dum.Dimension = {'lon'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'longitude','degrees_east','time, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'lat';
dum.Nctype = 'float';
dum.Dimension = {'lat'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'latitude','degrees_north','time, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'tair_time';
dum.Nctype = 'double';
dum.Dimension = {'tair_time'};
dum.Attribute = struct('Name',{'long_name','units','calendar','field'},'Value',{'time since initialization','days since 1900-01-01 00:00:00','gregorian','time, scalar, series'});
nc_addvar(outFile,dum)

dum.Name = 'Tair';
dum.Nctype = 'float';
dum.Dimension = {'tair_time','lat','lon'};
dum.Attribute = struct('Name',{'long_name','units','time','coordinates','field'},'Value',{'air_temperature','Celsius','tair_time','lon lat tair_time','air_temperature, scalar, series'});
nc_addvar(outFile,dum);



% Global attributes section

nc_attput(outFile,nc_global,'title', 'NISKINE1D' );
nc_attput(outFile,nc_global,'type', 'ROMS/TOMS history file' );
nc_attput(outFile,nc_global,'format', 'netCDF-3 64bit offset file' );

% Fill in grid data

nc_varput(outFile,'lat',lat);
nc_varput(outFile,'lon',lon);
nc_varput(outFile,'tair_time',timesROMS);


husker = husker2018.fluxes.inputs.t;
husker(1) = husker(2);

tairVec = husker;    % Qsat need Tair in deg C


tair = zeros(nt,ny,nx);
for tt=1:nt
    tair(tt,:,:) = husker(tt);
end;
nc_varput(outFile,'Tair',tair);

%% Qair - meant to be specific humidity
% magnitude should about .01 kg/kg

% the husker data has relative humidity, so I need to convert to specific
% humidity as per

% https://www.myroms.org/forum/viewtopic.php?t=2333

% It's all very ambiguous because everything's basically dimensionless.

outFile = 'Qair.nc'
unix(['\rm ',outFile]);

nc_create_empty(outFile,nc_64bit_offset_mode);

% Dimension section
nc_add_dimension(outFile,'lon',length(lon));
nc_add_dimension(outFile,'lat',length(lat));
nc_add_dimension(outFile,'qair_time',0);

% Variables section

dum.Name = 'lon';
dum.Nctype = 'float';
dum.Dimension = {'lon'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'longitude','degrees_east','time, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'lat';
dum.Nctype = 'float';
dum.Dimension = {'lat'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'latitude','degrees_north','time, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'qair_time';
dum.Nctype = 'double';
dum.Dimension = {'qair_time'};
dum.Attribute = struct('Name',{'long_name','units','calendar','field'},'Value',{'time since initialization','days since 1900-01-01 00:00:00','gregorian','time, scalar, series'});
nc_addvar(outFile,dum)

dum.Name = 'Qair';
dum.Nctype = 'float';
dum.Dimension = {'qair_time','lat','lon'};
dum.Attribute = struct('Name',{'long_name','units','time','coordinates','field'},'Value',{'specific_humidity','kg kg-1','tair_time','lon lat qair_time','specific_humidity, scalar, series'});
nc_addvar(outFile,dum);



% Global attributes section

nc_attput(outFile,nc_global,'title', 'NISKINE1D' );
nc_attput(outFile,nc_global,'type', 'ROMS/TOMS history file' );
nc_attput(outFile,nc_global,'format', 'netCDF-3 64bit offset file' );

% Fill in grid data

nc_varput(outFile,'lat',lat);
nc_varput(outFile,'lon',lon);
nc_varput(outFile,'qair_time',timesROMS);

% !!!!!!! convert relative humidity to specific humidity
husker = husker2018.fluxes.inputs.rh;
husker(1) = husker(2);
qRel = husker;

% If you plot the current version of husker, presumed to be the relative
% humidity, you see a buncha numbers between about 55 and 95. So far so
% good.
fig(1);clf; plot(qRel/10000) ;title('relative humidity / 10^4');

qsat = qsat(tairVec, pairVec);

fig(2);clf;plot(qsat); title('qsat');

qSpecif = .01 * qRel .* qsat;

fig(3);clf;plot(qSpecif); title('qSpecif');


qair = zeros(nt,ny,nx);
for tt=1:nt
    qair(tt,:,:) = qSpecif(tt);
end;
nc_varput(outFile,'Qair',qair);


%% rain

outFile = 'rain.nc'
unix(['\rm ',outFile]);

nc_create_empty(outFile,nc_64bit_offset_mode);

% Dimension section
nc_add_dimension(outFile,'lon',length(lon));
nc_add_dimension(outFile,'lat',length(lat));
nc_add_dimension(outFile,'rain_time',0);

% Variables section

dum.Name = 'lon';
dum.Nctype = 'float';
dum.Dimension = {'lon'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'longitude','degrees_east','time, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'lat';
dum.Nctype = 'float';
dum.Dimension = {'lat'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'latitude','degrees_north','time, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'rain_time';
dum.Nctype = 'double';
dum.Dimension = {'rain_time'};
dum.Attribute = struct('Name',{'long_name','units','calendar','field'},'Value',{'time since initialization','days since 1900-01-01 00:00:00','gregorian','time, scalar, series'});
nc_addvar(outFile,dum)

dum.Name = 'rain';
dum.Nctype = 'float';
dum.Dimension = {'rain_time','lat','lon'};
dum.Attribute = struct('Name',{'long_name','units','time','coordinates','field'},'Value',{'convective_rainfall','kg m-2 s-1','rain_time','lon lat rain_time','convective_rainfall, scalar, series'});
nc_addvar(outFile,dum);



% Global attributes section

nc_attput(outFile,nc_global,'title', 'NISKINE1D' );
nc_attput(outFile,nc_global,'type', 'ROMS/TOMS history file' );
nc_attput(outFile,nc_global,'format', 'netCDF-3 64bit offset file' );

% Fill in grid data

nc_varput(outFile,'lat',lat);
nc_varput(outFile,'lon',lon);
nc_varput(outFile,'rain_time',timesROMS);

% Convert m/s to kg m-2 s-1
husker = husker2018.fluxes.inputs.rain;
husker(1) = husker(2);
husker = husker *1000;

rain = zeros(nt,ny,nx);
for tt=1:nt
    rain(tt,:,:) = husker(tt);
end;
nc_varput(outFile,'rain',rain);


%% swrad

outFile = 'swrad.nc'
unix(['\rm ',outFile]);

nc_create_empty(outFile,nc_64bit_offset_mode);

% Dimension section
nc_add_dimension(outFile,'lon',length(lon));
nc_add_dimension(outFile,'lat',length(lat));
nc_add_dimension(outFile,'srf_time',0);

% Variables section

dum.Name = 'lon';
dum.Nctype = 'float';
dum.Dimension = {'lon'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'longitude','degrees_east','time, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'lat';
dum.Nctype = 'float';
dum.Dimension = {'lat'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'latitude','degrees_north','time, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'srf_time';
dum.Nctype = 'double';
dum.Dimension = {'srf_time'};
dum.Attribute = struct('Name',{'long_name','units','calendar','field'},'Value',{'time since initialization','days since 1900-01-01 00:00:00','gregorian','time, scalar, series'});
nc_addvar(outFile,dum)

dum.Name = 'swrad';
dum.Nctype = 'float';
dum.Dimension = {'srf_time','lat','lon'};
dum.Attribute = struct('Name',{'long_name','units','time','coordinates','field'},'Value',{'surface_incoming_shortwave_flux','W m-2','srf_time','lon lat srf_time','surface_incoming_shortwave_flux, scalar, series'});
nc_addvar(outFile,dum);



% Global attributes section

nc_attput(outFile,nc_global,'title', 'NISKINE1D' );
nc_attput(outFile,nc_global,'type', 'ROMS/TOMS history file' );
nc_attput(outFile,nc_global,'format', 'netCDF-3 64bit offset file' );

% Fill in grid data

nc_varput(outFile,'lat',lat);
nc_varput(outFile,'lon',lon);
nc_varput(outFile,'srf_time',timesROMS);

% 
husker = husker2018.fluxes.inputs.Rs;
husker(1) = husker(2);

swrad = zeros(nt,ny,nx);
for tt=1:nt
    swrad(tt,:,:) = husker(tt);
end;
nc_varput(outFile,'swrad',swrad);


%% lwrad_down

outFile = 'lwrad_down.nc'
unix(['\rm ',outFile]);

nc_create_empty(outFile,nc_64bit_offset_mode);

% Dimension section
nc_add_dimension(outFile,'lon',length(lon));
nc_add_dimension(outFile,'lat',length(lat));
nc_add_dimension(outFile,'lrf_time',0);

% Variables section

dum.Name = 'lon';
dum.Nctype = 'float';
dum.Dimension = {'lon'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'longitude','degrees_east','time, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'lat';
dum.Nctype = 'float';
dum.Dimension = {'lat'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'latitude','degrees_north','time, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'lrf_time';
dum.Nctype = 'double';
dum.Dimension = {'lrf_time'};
dum.Attribute = struct('Name',{'long_name','units','calendar','field'},'Value',{'time since initialization','days since 1900-01-01 00:00:00','gregorian','time, scalar, series'});
nc_addvar(outFile,dum)

dum.Name = 'lwrad_down';
dum.Nctype = 'float';
dum.Dimension = {'lrf_time','lat','lon'};
dum.Attribute = struct('Name',{'long_name','units','time','coordinates','field'},'Value',{'surface_absorbed_longwave_radiation','W m-2','lrf_time','lon lat lrf_time','surface_absorbed_longwave_radiation, scalar, series'});
nc_addvar(outFile,dum);



% Global attributes section

nc_attput(outFile,nc_global,'title', 'NISKINE1D' );
nc_attput(outFile,nc_global,'type', 'ROMS/TOMS history file' );
nc_attput(outFile,nc_global,'format', 'netCDF-3 64bit offset file' );

% Fill in grid data

nc_varput(outFile,'lat',lat);
nc_varput(outFile,'lon',lon);
nc_varput(outFile,'lrf_time',timesROMS);

% 
husker = husker2018.fluxes.inputs.Rl;
husker(1) = husker(2);

lwrad = zeros(nt,ny,nx);
for tt=1:nt
    lwrad(tt,:,:) = husker(tt);
end;
nc_varput(outFile,'lwrad_down',lwrad);

%% u and v

% The wind is archived as speed and direction

% The number in this data set associated with the wind direction is
% meteorological convention. 
%       0 deg means coming from the north
%       90 deg means coming from the east
%       180 deg means coming from the south
%       270 deg means coming from the west

% The angle in Cartesian coordinates, th_cart is way more useful because
%       x component = Umagnitude * cos (th_cart)
%       y component = Umagnitude * sin (th_cart)
% so what I need to do is convert the meteorological angle to the Cartesian
% angle with this
%
%   th_cart = mod(-90-thetameteo,360)

huskerWind = husker2018.fluxes.inputs.u;
huskerDir  = husker2018.fluxes.inputs.wdir;
huskerWind(2) = huskerWind(3);
huskerDir(2)  = huskerDir(3);
huskerWind(1) = huskerWind(2);
huskerDir(1)  = huskerDir(2);

theta_cartesian = mod(-90 - huskerDir, 360);

u = huskerWind .* cos(theta_cartesian * 3.14159/180);
v = huskerWind .* sin(theta_cartesian * 3.14159/180);

sqrt(u.^2 + v.^2) - huskerWind;

aaa=5;

%% Uwind

outFile = 'Uwind.nc'
unix(['\rm ',outFile]);

nc_create_empty(outFile,nc_64bit_offset_mode);

% Dimension section
nc_add_dimension(outFile,'lon',length(lon));
nc_add_dimension(outFile,'lat',length(lat));
nc_add_dimension(outFile,'wind_time',0);

% Variables section

dum.Name = 'lon';
dum.Nctype = 'float';
dum.Dimension = {'lon'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'longitude','degrees_east','time, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'lat';
dum.Nctype = 'float';
dum.Dimension = {'lat'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'latitude','degrees_north','time, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'wind_time';
dum.Nctype = 'double';
dum.Dimension = {'wind_time'};
dum.Attribute = struct('Name',{'long_name','units','calendar','field'},'Value',{'time since initialization','days since 1900-01-01 00:00:00','gregorian','time, scalar, series'});
nc_addvar(outFile,dum)

dum.Name = 'Uwind';
dum.Nctype = 'float';
dum.Dimension = {'wind_time','lat','lon'};
dum.Attribute = struct('Name',{'long_name','units','time','coordinates','field'},'Value',{'eastward_wind','m/s','wind_time','lon lat wind_time','eastward_wind, scalar, series'});
nc_addvar(outFile,dum);



% Global attributes section

nc_attput(outFile,nc_global,'title', 'NISKINE1D' );
nc_attput(outFile,nc_global,'type', 'ROMS/TOMS history file' );
nc_attput(outFile,nc_global,'format', 'netCDF-3 64bit offset file' );

% Fill in grid data

nc_varput(outFile,'lat',lat);
nc_varput(outFile,'lon',lon);
nc_varput(outFile,'wind_time',timesROMS);



Uwind = zeros(nt,ny,nx);
for tt=1:nt
    Uwind(tt,:,:) = u(tt);
end;
nc_varput(outFile,'Uwind',Uwind);

%% Vwind

outFile = 'Vwind.nc'
unix(['\rm ',outFile]);

nc_create_empty(outFile,nc_64bit_offset_mode);

% Dimension section
nc_add_dimension(outFile,'lon',length(lon));
nc_add_dimension(outFile,'lat',length(lat));
nc_add_dimension(outFile,'wind_time',0);

% Variables section

dum.Name = 'lon';
dum.Nctype = 'float';
dum.Dimension = {'lon'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'longitude','degrees_east','time, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'lat';
dum.Nctype = 'float';
dum.Dimension = {'lat'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'latitude','degrees_north','time, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'wind_time';
dum.Nctype = 'double';
dum.Dimension = {'wind_time'};
dum.Attribute = struct('Name',{'long_name','units','calendar','field'},'Value',{'time since initialization','days since 1900-01-01 00:00:00','gregorian','time, scalar, series'});
nc_addvar(outFile,dum)

dum.Name = 'Vwind';
dum.Nctype = 'float';
dum.Dimension = {'wind_time','lat','lon'};
dum.Attribute = struct('Name',{'long_name','units','time','coordinates','field'},'Value',{'eastward_wind','m/s','wind_time','lon lat wind_time','northward_wind, scalar, series'});
nc_addvar(outFile,dum);



% Global attributes section

nc_attput(outFile,nc_global,'title', 'NISKINE1D' );
nc_attput(outFile,nc_global,'type', 'ROMS/TOMS history file' );
nc_attput(outFile,nc_global,'format', 'netCDF-3 64bit offset file' );

% Fill in grid data

nc_varput(outFile,'lat',lat);
nc_varput(outFile,'lon',lon);
nc_varput(outFile,'wind_time',timesROMS);



Vwind = zeros(nt,ny,nx);
for tt=1:nt
    Vwind(tt,:,:) = v(tt);
end;
nc_varput(outFile,'Vwind',Vwind);


%%

% function thetastandard = met2standard (thetameteo)
% thetastandard=mod(-90-thetameteo,360);
% end

