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


#dataDir="../Input"$location"/"
dataDir='.'

iniDir="ini"$date"/"

echo "dataDir  "$dataDir
echo "iniDir   "$iniDir


#exit



#\rm -r $dataDir
#mkdir  $dataDir
#mkdir  $dataDir$iniDir

cp ../Gridpak/NISKINE_grid_template.nc grid.nc




matlab -nodisplay -nosplash <grid.m 
mv ./grid.nc "NISKINE"$location"_2km.nc"
exit


matlab -nodisplay -nosplash <ic.m

mv ic.nc $dataDir$iniDir"IC"$date$location"_2km.nc"
\rm CMEMS*
