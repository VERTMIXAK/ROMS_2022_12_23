#!/bin/bash

source ~/.runPycnal

year=2018

python regrid_runoff.py BARROWCtelescope_2km -z --regional_domain -f /import/c1/AKWATERS/kate/JRA55-do/runoff_JRA55-do-1-4-0_${year}.* Barrow_runoff_${year}.nc > log


python add_rivers.py JRA-1.4_Barrow_rivers_${year}.nc
python make_river_clim.py Barrow_runoff_${year}.nc JRA-1.4_Barrow_rivers_${year}.nc
## Squeezing JRA is dangerous - different number of rivers when you change years.
##python squeeze_rivers.py JRA-1.4_Barrow_rivers_${year}.nc squeeze.nc
##mv squeeze.nc JRA-1.4_Barrow_rivers_${year}.nc


python add_temp.py JRA-1.4_Barrow_rivers_${year}.nc


python set_vshape.py JRA-1.4_Barrow_rivers_${year}.nc

