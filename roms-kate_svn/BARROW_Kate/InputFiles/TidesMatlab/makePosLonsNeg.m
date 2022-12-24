clear;

posAngleFile  = 'BoB3_M2S2K1O1_2013_posAngle.nc';
negAngleFile  = 'BoB3_M2S2K1O1_2013_negAngle.nc';

unix(['cp ',posAngleFile,' ',negAngleFile]);

Cangle   = nc_varget(negAngleFile,'tide_Cangle');
Cphase   = nc_varget(negAngleFile,'tide_Cphase');

aaa=5;

Cangle   = mod(Cangle   + 180,360) - 180;
Cphase   = mod(Cphase   + 180,360) - 180;

nc_varput(negAngleFile,'tide_Cangle'  ,Cangle)
nc_varput(negAngleFile,'tide_Cphase'  ,Cphase)