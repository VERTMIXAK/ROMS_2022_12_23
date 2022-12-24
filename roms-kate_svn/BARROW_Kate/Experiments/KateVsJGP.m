fileKate = '/import/c1/AKWATERS/kshedstrom/Barrow/barrow_his_00015.nc';
% fileJGP = './BARROW_Kate_fromKatesOriginals/netcdfOutput/barrow_his_00016.nc';
fileJGP  = './BARROW_Kate_recalculatedInput2/netcdfOutput/barrow_his_00016.nc';

dumKate = nc_varget(fileKate,'u');
dumJGP  = nc_varget(fileJGP ,'u');

%%

tKate = nc_varget(fileKate,'ocean_time')
tJGP  = nc_varget(fileJGP ,'ocean_time')

%%

% tt=9

fig(1);clf;
imagesc(sq(dumKate(end,end,:,:)));axis xy;title('surface u - use Kate"s originals');

fig(2);clf
imagesc(sq(dumJGP(end,:,:)));axis xy;title('surface u - use recalculated versions of Kate"s files');

fig(3);clf;
imagesc(sq(dumKate(end,end,:,:))-sq(dumJGP(end,:,:)));axis xy;colorbar;title('difference')

sq(dumKate(end,end,:,:))-sq(dumJGP(end,:,:));max(abs(ans(:)))



