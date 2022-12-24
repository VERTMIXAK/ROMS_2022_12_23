otpsFile = 'TidesM2S2O1K1/SCSA_tides_otps.nc';
matlabFile = 'Tides/SCSA_M2S2K1O1_2007.nc';

comp1 = nc_varget(otpsFile,'tide_period');
comp2 = nc_varget(matlabFile,'tide_period');

order1 = [4,3,2,1]
order2 = [2,1,3,4]

eamp1 = nc_varget(otpsFile,'tide_Eamp');
eamp2 = nc_varget(matlabFile,'tide_Eamp');

epha1 = nc_varget(otpsFile,'tide_Ephase');
epha2 = nc_varget(matlabFile,'tide_Ephase');

%%

fig(1);clf;
imagesc(sq(eamp1(order1(4),:,:)));axis xy
fig(2);clf;
imagesc(sq(eamp2(order2(4),:,:)));axis xy

%%

fig(11);clf;
imagesc(mod(sq(epha1(order1(1),:,:)  -100 ),360));axis xy;colorbar
caxis([180,330])
fig(12);clf;
imagesc(mod(sq(epha2(order2(1),:,:)  -100 ),360));axis xy;colorbar
caxis([180,330])

%%

fig(21);clf;
imagesc(mod(sq(epha1(order1(2),:,:) -100 ),360));axis xy;colorbar
caxis([150,300])
fig(22);clf;
imagesc(mod(sq(epha2(order2(2),:,:)      ),360));axis xy;colorbar
caxis([150,300])

%%

fig(31);clf;
imagesc(sq(epha1(order1(3),:,:)));axis xy;colorbar
caxis([50,200])
fig(32);clf;
imagesc(mod(sq(epha2(order2(3),:,:) + 10),360));axis xy;colorbar
caxis([50,200])

%%
fig(41);clf;
imagesc(sq(epha1(order1(4),:,:)));axis xy;colorbar
caxis([0,150])
fig(42);clf;
imagesc(mod(sq(epha2(order2(4),:,:) + 85),360));axis xy;colorbar
caxis([0,150])

% fig(5);clf;
% imagesc(sq(  epha1(order1(4),:,:) - epha2(order2(4),:,:)  ));axis xy;colorbar
