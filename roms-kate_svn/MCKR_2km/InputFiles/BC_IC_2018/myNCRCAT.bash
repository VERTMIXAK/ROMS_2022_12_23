ncrcat scheduleForDeletion/arctic4_avg_*  MCKR_sea_bdry_2018.nc
ncrcat scheduleForDeletion/arctic4_avg2_* MCKR_ice_bdry_2018.nc
ncrcat scheduleForDeletion/arctic4_2*     MCKR_CLM_2018.nc

ncatted -O -a units,ocean_time,o,c,"days since 1900-01-01 00:00:00" MCKR_sea_bdry_2018.nc
ncatted -O -a units,ocean_time,o,c,"days since 1900-01-01 00:00:00" MCKR_ice_bdry_2018.nc
ncatted -O -a units,ocean_time,o,c,"days since 1900-01-01 00:00:00" MCKR_CLM_2018.nc

source ~/.runPycnal

python ini_121/set* MCKR_sea_bdry_2018.nc
python ini_121/set* MCKR_ice_bdry_2018.nc
python ini_121/set* MCKR_CLM_2018.nc
