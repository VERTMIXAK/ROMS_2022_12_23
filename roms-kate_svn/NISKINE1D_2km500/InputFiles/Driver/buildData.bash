#!/bin/bash

# get center coordinates for the experiment

lat=`grep lat latlon.txt | cut -d '=' -f2 | cut -d '_' -f1`
lon=`grep lon latlon.txt | cut -d '=' -f2 | cut -d '_' -f1`
echo "lat "$lat"    lon "$lon

#lon2=` expr 360 - $lon`
lon2=` echo " 360 - $lon " | bc `
#echo $lon2

#echo $lat $lon
location=`echo "_"$lon"W_"$lat"N"`
#echo $location

year=`grep year latlon.txt | cut -d '=' -f2`
day=`grep day latlon.txt | cut -d '=' -f2`
date=`echo "_"$year"_"$day`

echo "date  " $date

dataDir="../Input"$location"/"
iniDir="ini"$date"/"

\rm -r $dataDir
mkdir  $dataDir
mkdir  $dataDir$iniDir

cp ../Gridpak_template/NISKINE_template_2km.nc grid.nc

exit

matlab -nodisplay -nosplash <grid.m 

exit

matlab -nodisplay -nosplash <ic.m


exit


mv ./grid.nc $dataDir"grid"$location"_2km.nc"
mv ic.nc $dataDir$iniDir"IC"$date$location"_2km.nc"
\rm CMEMS*
