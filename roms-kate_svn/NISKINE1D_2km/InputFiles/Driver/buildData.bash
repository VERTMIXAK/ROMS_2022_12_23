#!/bin/bash

# get center coordinates for the experiment

lat=`grep lat latlon.txt | cut -d '=' -f2 | cut -d '_' -f1`
lon=`grep lon latlon.txt | cut -d '=' -f2 | cut -d '_' -f1`
echo "lat "$lat"    lon "$lon

#lon2=` expr 360 - $lon`
lon2=` echo " 360 - $lon " | bc `
echo $lon2

#echo $lat $lon
location=`echo "_"$lon"W_"$lat"N"`
#echo $location

year=`grep year latlon.txt | cut -d '=' -f2`
day=`grep day latlon.txt | cut -d '=' -f2`
date=`echo "_"$year"_"$day`


dataDir="../Input"$location"/"
iniDir="ini"$date"/"

\rm -r $dataDir
mkdir  $dataDir
mkdir  $dataDir$iniDir

cp NISKINE_grid_template.nc grid.nc




matlab -nodisplay -nosplash <grid.m 
mv ./grid.nc $dataDir"grid"$location"_2km.nc"

matlab -nodisplay -nosplash <ic.m

mv ic.nc $dataDir$iniDir"IC"$date$location"_2km.nc"
\rm CMEMS*
