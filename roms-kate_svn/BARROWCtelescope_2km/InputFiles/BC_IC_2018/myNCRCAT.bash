ncrcat scheduleForDeletion/arctic4_avg_*  Barrow_sea_bdry_2018.nc
ncrcat scheduleForDeletion/arctic4_avg2_* Barrow_ice_bdry_2018.nc
ncrcat scheduleForDeletion/arctic4_2*     Barrow_CLM_2018.nc

ncatted -O -a units,ocean_time,o,c,"days since 1900-01-01 00:00:00" Barrow_sea_bdry_2018.nc
ncatted -O -a units,ocean_time,o,c,"days since 1900-01-01 00:00:00" Barrow_ice_bdry_2018.nc
ncatted -O -a units,ocean_time,o,c,"days since 1900-01-01 00:00:00" Barrow_CLM_2018.nc

source ~/.runPycnal

python ini_121/set* Barrow_sea_bdry_2018.nc
python ini_121/set* Barrow_ice_bdry_2018.nc
python ini_121/set* Barrow_CLM_2018.nc
