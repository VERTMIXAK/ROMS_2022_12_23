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

echo "year  $year"
echo "day   $day"

dayMinus1=` echo $day - 1 | bc `

# make sure lat/lon match directory name

lonDir=`pwd |rev |cut -d '/' -f1 |rev | cut -d '_' -f2 | cut -d 'W' -f1`
latDir=`pwd |rev |cut -d '/' -f1 |rev | cut -d '_' -f3 | cut -d 'N' -f1`

echo "latDir $latDir     lonDir $lonDir"

if [[ $lat != $latDir ]]
then
    echo "mismatch lat"
	exit
fi

if [[ $lon != $lonDir ]]
then
    echo "mismatch lon"
	exit
fi


#exit

# create the python IC files

cp make_ic_file_proto.py make_ic1.py
cp make_ic_file_proto.py make_ic2.py

sed -i s/YEAR/$year/ make_ic1.py
sed -i s/YEAR/$year/ make_ic2.py

sed -i s/DAY/$dayMinus1/ make_ic1.py
sed -i s/DAY/$day/       make_ic2.py

sed -i s/IC_X/IC_1/ make_ic1.py
sed -i s/IC_X/IC_2/       make_ic2.py



# get the grid file template

cp ../../Gridpak/grid_Template_500.nc grid.nc


# update lat/lon and f in the grid file

matlab -nodisplay -nosplash <grid.m 
cp ./grid.nc ../../Gridpak/Grid.nc


source ~/.runPycnal
python make_remap_weights_file.py
python make_ic1.py
python make_ic2.py

python settime.py IC_1.nc
python settime.py IC_2.nc


#exit

module purge
module load matlab/R2013a
matlab -nodisplay -nosplash < averageSnapshots.m
matlab -nodisplay -nosplash < averageFields.m

\rm IC_1.nc
\rm IC_2.nc
\rm remap*.nc
\rm -r _*
