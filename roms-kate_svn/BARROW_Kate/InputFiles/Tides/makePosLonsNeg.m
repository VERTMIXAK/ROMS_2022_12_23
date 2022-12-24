clear;

posAngleFile  = 'Barrow_tides_otps_posAngle.nc';
negAngleFile  = 'Barrow_tides_otps_negAngle.nc';

unix(['cp ',posAngleFile,' ',negAngleFile]);

Cangle   = nc_varget(negAngleFile,'tide_Cangle');
Cphase   = nc_varget(negAngleFile,'tide_Cphase');

Cangle   = mod(Cangle   + 180,360) - 180;
Cphase   = mod(Cphase   + 180,360) - 180;

nc_varput(negAngleFile,'tide_Cangle'  ,Cangle)
nc_varput(negAngleFile,'tide_Cphase'  ,Cphase)