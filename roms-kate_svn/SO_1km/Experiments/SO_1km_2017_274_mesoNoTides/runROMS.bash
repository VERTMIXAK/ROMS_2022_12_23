#!/bin/bash
source ~/.runROMSintel

export INTEL_LICENSE_FILE=28518@license.rcs.alaska.edu


printenv | grep -i license

echo " "
echo " "



printenv |grep NETCDF



export NETCDF=/usr/local/pkg/netcdf/netcdf-4.3.0.intel-2016
export NETCDF_INCDIR=/usr/local/pkg/netcdf/netcdf-4.3.0.intel-2016/include

export PATH=$PATH\:~/bin:.
export LD_LIBRARY_PATH=$HOME/PyCNAL_fromKate/site-packages:$LD_LIBRARY_PATH
export PYCNAL_GRIDID_FILE=$HOME/Python/gridid.txt
export PYCNAL_GRID_FILE=$HOME/Python/gridid.txt
export PYCNAL_PATH=$HOME/Python
export XCOASTDATA=/import/c/w/jpender/ROMS/BathyData/world_int.cst
export ETOPO2=/import/c/w/jpender/ROMS/BathyData/etopo2.Gridpak.nc
export TOPO30=/import/c/w/jpender/ROMS/BathyData/topo30.Gridpak_TS.nc
export TOPO30TS=/import/c/w/jpender/ROMS/BathyData/topo30.Gridpak_TS.nc
export INDIANO2=/import/c/w/jpender/ROMS/BathyData/indiano2.Gridpak.nc
export PALAU_HIRES=/import/c/w/jpender/ROMS/BathyData/Palau_hires.nc 

umask 0027




clear

echo ""
echo ""
echo ""



ROMSdir=`pwd`
#echo $ROMSdir

#ROI="PALAU"
#ROI="GUAM"
#ROI="SCS"
#ROI="NISKINEthilo"
#ROI="TS"
#ROI="BoB"
#ROI="BoB3"
ROI="SO"

#gridRes="0.015625"
#gridRes="0.03125"
gridRes="1km"
#gridRes="2km"
#gridRes="4km"
#gridRes="UH"
#gridRes="HYCOM"
#gridRes="HYCOMMERRA"
#gridRes="15_120"
#gridRes="120B"
#gridRes="120C_UHMERRA"
#gridRes="120C_Inner"
#gridRes="120C_UH_Direct"
#gridRes="120C_HYCOMMERRA"
#gridRes="120"
#gridRes="120HYCOMMERRA"
#gridRes="120HYCOM"
#gridRes="0.125"
#gridRes="0.25"
#gridRes="800m"
#gridRes="400m"
#gridRes="8000m"


# pick one and only one option from this set
#exptMode="tidesOnly"
#exptMode="meso"
exptMode="mesoNoTides"
#exptMode="meso_Eig"
#exptMode="tidesOnly_Eig"
#exptMode="meso_UHdirect"



exptname=`echo $ROI | tr "[A-Z]" "[a-z]"`
#echo $exptname
gridName=$ROI"_"$gridRes

Appsdir="Apps/"$gridName"/"
compileInputFile=$Appsdir$exptname".h"
runInputFile=$Appsdir"ocean_"$exptname".in"
#varinfoFile=$Appsdir"varinfo.dat"
varinfoFile="./Apps/varinfo.dat"

#echo $compileInputFile"_"$exptMode

printf "cp $compileInputFile"_"$exptMode \t\t$compileInputFile\n"
cp $compileInputFile"_"$exptMode $compileInputFile

printf "cp $runInputFile"_"$exptMode  \t$runInputFile\n"
cp $runInputFile"_"$exptMode     $runInputFile

#printf "cp $varinfoFile"_*"  \t$varinfoFile\n"
#cp $varinfoFile"_"$exptMode     $varinfoFile


#!!!!!!!!!!!!!!!!!!!!!!!
# Optional note to append to the experiment name
#nameAppend=""
#nameAppend="_fixFloats"
#nameAppend="_wetdry"
#nameAppend="_Freshwater"

echo "optional note on file name is " $nameAppend


echo ""

echo "experiment mode:    " $exptMode
echo "grid name:          " $gridName
echo "compile input file: " $compileInputFile
echo "run input file:     " $runInputFile
echo "varinfo file:       " $varinfoFile
echo "name append:        " $nameAppend
echo ""



### Start extracting information from relevant files as an internal consistency check.

gridFile=`grep GRDNAME $runInputFile | grep -v '!' | cut -d '.' -f2-10`
gridFileShort=`echo $gridFile | rev | cut -d '/' -f1 | rev `
echo "gridFile = $gridFile"
echo "gridFileShort = $gridFileShort"
echo "The grid file for this experiment is $gridFile"
echo ""




echo $runInputFile
# get the desired tiling from the run input file
tileX=`grep "NtileI ==" $runInputFile  | cut -d "=" -f3 | head -c 7`
tileY=`grep "NtileJ ==" $runInputFile  | cut -d "=" -f3 | head -c 7`
echo "tileX is "$tileX
echo "tileY is "$tileY
echo ""



echo "about to start tidesOnly check"
echo "experiment mode is $exptMode"

# grab the start date for the run

if [ $exptMode == "tidesOnly" ]; then 
    	echo "analytic initial conditions"
        dstart=`grep DSTART $runInputFile | grep -v '! !' | head -1 | cut -d "." -f1 | tail -c 6`
        echo "analytic dstart is " $dstart
	day=` echo " $dstart - 42003 + 1 " | bc`
	echo "day = $day"

	if [ $day -gt 0 ] && [ $day -lt 366 ]; then
                year="2015"
		echo "year is $year"	
		if [ $day -lt 10 ]; then
			date=$year"_00"$day
			echo "date is $date"
		elif [ $day -gt 99 ]; then
			date=$year"_"$day
                        echo "date is $date"
		else
			date=$year"_0"$day
                        echo "date is $date"
		fi
		echo "start date stamp is: $date"
        fi

        day=` echo " $dstart - 41638 + 1 " | bc`
        if [ $day -gt 0 ] && [ $day -lt 366 ]; then
                year="2014" 
                echo "year is $year"
                if [ $day -lt 10 ]; then
                        date=$year"_00"$day
                elif [ $day -gt 99 ]; then
                        date=$year"_"$day
                else
                        date=$year"_0"$day
                fi
                echo "start date stamp is: $date"
        fi
	
        day=` echo " $dstart - 41273 + 1 " | bc`
        if [ $day -gt 0 ] && [ $day -lt 366 ]; then
                year="2013" 
                echo "year is $year"
                if [ $day -lt 10 ]; then
                        date=$year"_00"$day
                elif [ $day -gt 99 ]; then
                        date=$year"_"$day
                else
                        date=$year"_0"$day
                fi
                echo "start date stamp is: $date"
        fi

        day=` echo " $dstart - 40907 + 1 " | bc`
        if [ $day -gt 0 ] && [ $day -lt 366 ]; then
                year="2012" 
                echo "year is $year"
                if [ $day -lt 10 ]; then
                        date=$year"_00"$day
                elif [ $day -gt 99 ]; then
                        date=$year"_"$day
                else
                        date=$year"_0"$day
                fi
                echo "start date stamp is: $date"
        fi
fi

echo "done with tidesOnly check"
echo " "





# check for remaining situations

if [ $exptMode == "meso" ] || [ $exptMode == "mesoNoTides" ] || [ $exptMode == "meso_UHdirect" ]; then
        echo "start from ini file"
        ini_name=`grep ININAME $runInputFile | grep -v "!" | cut -d "=" -f3  `
        echo "IC file name is  "$ini_name

	dstart=`grep DSTART $runInputFile | grep -v '! !' | head -1 | cut -d "." -f1 | tail -c 6`
	echo "dstart from ocean.in file is " $dstart
	
#	echo "./"$gridName`echo $ini_name | cut -d "." -f5-10`	
	if [ ! -e "./"$gridName`echo $ini_name | cut -d "." -f5-10` ]; then
		echo "IC file doesn't exist"
		exit 1
		fi


	temp=`echo $ini_name | rev | cut -d "/" -f1-4 | rev`
	ini_name2=$gridName"/"$temp
#        echo "temp " $temp "  ini_name2 " $ini_name2

        dstart=`ncdump -v ocean_time  $ini_name2 | grep "ocean_time =" | grep -v "UN" | cut -c 15-19`
        echo "day number from IC file is " $dstart

        date=`echo $ini_name2 | rev | cut -d "/" -f1 | rev | cut -d "_" -f2-3 `
#	date=`echo $ini_name2 | rev | cut -d "/" -f1 | cut -d "_" -f5-6 | rev`
	echo "start date stamp is: " $date
fi
echo ""


# check tidal forcing
useTides=`grep LTIDES $compileInputFile | grep -v ifdef |rev | cut -d " " -f2-5 | rev |cut -d '#' -f2 | cut -d " " -f2`
echo "useTides: " $useTides

if [ $useTides == 'define' ]; then
	echo "use tidal forcing"
	tideCode1=`grep "/Tides" $runInputFile   | cut -d '_' -f2 `
	dum=`grep "/Tides" $runInputFile  | grep -v "!" | cut -d "/" -f5 `
	if [ $dum == 'SCS_tides_otps.nc' ]; then
		tideCode2=""
	else
		tideCode2=`grep "/Tides" $runInputFile  | grep -v "!" | cut -d "/" -f5 | cut -d "_" -f4`
	fi
	tideCode="_"$tideCode1
#   tideCode=$tideCode1$tideCode2
else
	tideCode=""
fi
	echo "tide code is " $tideCode
#echo "tide code 2 is " $tideCode2

#exit


# find length of run
echo ""
ntimes=`grep NTIMES $runInputFile | grep -v "!" | cut -d "=" -f3`
dt=`grep "DT ==" $runInputFile | grep -v "!" | cut -d "=" -f3 | cut -d "." -f1`

#echo 'ntimes=' $ntimes
#echo 'dt=' $dt

runDays=` echo " $ntimes * $dt / 86400 " | bc`
echo "run time is " $runDays " days"
echo ""



# construct experiment name and create a directory to hold it (unless the directory already exist,
# in which case exit

echo "exptMode  $exptMode"

exptName=$gridName"/Experiments/"$gridName"_"$date"_"$exptMode$tideCode$nameAppend

echo "experiment name is" 
echo $exptName



if [ -e $exptName ]; then
        echo "you already have an experiment with this name"
        exit 1
fi




# Check the file write intervals

echo " "
dt=`grep "DT ==" $runInputFile | cut -d "=" -f3 | cut -d " " -f2 | cut -d "." -f1`
echo "dt=" $dt

nhis=`grep "NHIS ==" $runInputFile |grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 | cut -d '!' -f1`
nqck=`grep "NQCK ==" $runInputFile |grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 | cut -d '!' -f1`
ndefhis=`grep "NDEFHIS ==" $runInputFile |grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 | cut -d '!' -f1`
ndefqck=`grep "NDEFQCK ==" $runInputFile |grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 | cut -d '!' -f1`

echo "nhis="$nhis  "nqck="$nqck
echo "ndefhis="$ndefhis  "ndefqck="$ndefqck

hisSnapShot=` echo "scale=2; $dt * $nhis / 3600" | bc -l`
hisNewFile=` echo "scale=2; $dt * $ndefhis / 3600" | bc -l`
echo "hisSnapShot  = "$hisSnapShot  "hours    hisNewFile = "$hisNewFile" hours"

qckSnapShot=` echo "scale=2; $dt * $nqck / 3600" | bc -l`
qckNewFile=` echo "scale=2; $dt * $ndefqck / 3600" | bc -l`
echo "qckSnapShot = "$qckSnapShot  "hours    qckNewFile = "$qckNewFile" hours"
echo " "
echo " "



navg=`grep "NAVG ==" $runInputFile |grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 `
ndefavg=`grep "NDEFAVG ==" $runInputFile |grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 `
echo "navg="$navg  "ndefavg="$ndefavg

avgSnapShot=` echo "scale=2; $dt * $navg / 3600" | bc -l`
avgNewFile=` echo "scale=2; $dt * $ndefavg / 3600" | bc -l`
echo "avgSnapShot  = "$avgSnapShot  "hours    avgNewFile = "$avgNewFile" hours"
echo " "
echo " "



# check floats
useFloats=`grep FLOATS $compileInputFile | grep -v OFFLINE | grep -v ifdef | cut -d " " -f1`
echo "useFloats: " $useFloats
if [ $useFloats == '#define' ]; then
#        echo "use floats"
	nflt=`grep "NFLT ==" $runInputFile |grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 `
	fltSnapShot=` echo "scale=2; $dt * $nflt / 3600" | bc -l`
#	echo "nflt = $nflt"
	echo "fltSnapShot  = $fltSnapShot  hours" 
fi
echo " "
echo " "



# check stations
useStations=`grep STATIONS $compileInputFile | grep -v ifdef | cut -d " " -f1`
#echo "useStations: " $useStations
if [ $useStations == '#define' ]; then
        echo "use stations"
        nsta=`grep "NSTA ==" $runInputFile |grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 `
        staSnapShot=` echo "scale=2; $dt * $nsta / 3600" | bc -l`
#	echo "nsta = $nsta"
        echo "staSnapShot  = $staSnapShot  hours"
fi




echo " "
echo " "
echo "************************"
echo "Additional sanity checks"
echo " "







origGridName=`echo "$gridName/InputFiles/Gridpak/$gridFileShort"`
echo "original Grid Name is $origGridName"


ncwa -O $origGridName gridAve.nc
pm=`ncdump gridAve.nc |grep "pm =" | cut -d " " -f4`
pn=`ncdump gridAve.nc |grep "pn =" | cut -d " " -f4`

#echo "pm = $pm    pn = $pn"

pm=`echo $pm | sed -e 's/[eE]-/ * 10^-/'`
pn=`echo $pn | sed -e 's/[eE]-/ * 10^-/'`

#echo "pm = $pm    pn = $pn"

pm=`echo " 1 * $pm " |bc -l`
pn=`echo " 1 * $pn " |bc -l`

#echo "pm = $pm    pn = $pn"

# jgp note: the above line uses "bc -l" to do floating point 
# if you leave off the -l then you get integer arithmetic


\rm gridAve.nc
deltaXi=` echo " 1 / $pm " |bc `
deltaEta=`echo " 1 / $pn " |bc `

echo "This grid has average deltaXi = $deltaXi m  and  average deltaEta = $deltaEta m"

dum=`echo " .5 * $deltaXi + .5 * $deltaEta " |bc `
#echo "ave should be $dum"

rounded=`echo " scale=1; ( $dum + .5 ) / 1000 " |bc`
echo "so I am going to call this a $rounded km grid"
echo " "
echo " "


DT=`grep "DT =="      $runInputFile | grep -v '!' | cut -d "=" -f3 | cut -d " " -f2 | cut -d "." -f1`
NDTFAST=`grep "NDTFAST ==" $runInputFile | grep -v '!' | cut -d "=" -f3 | cut -d " " -f2 | cut -d "." -f1`

TNU2=`grep "TNU2 =="    $runInputFile | grep -v ad_ | grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 `
TNU4=`grep "TNU4 =="    $runInputFile | grep -v ad_ | grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 `

VISC2=`grep "VISC2 =="   $runInputFile | grep -v ad_ | grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2`
VISC4=`grep "VISC4 =="   $runInputFile | grep -v ad_ | grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 `

ZNUDG=`grep "ZNUDG =="   $runInputFile | grep -v ad_ | grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 | cut -d "." -f1`
TNUDG=`grep "TNUDG =="   $runInputFile | grep -v ad_ | grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 | cut -d "." -f1`
M2NUDG=`grep "M2NUDG =="   $runInputFile | grep -v ad_ | grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 | cut -d "." -f1`
M3NUDG=`grep "M3NUDG =="   $runInputFile | grep -v ad_ | grep -v '! !' | cut -d "=" -f3 | cut -d " " -f2 | cut -d "." -f1`

#echo "TNU2 $TNU2"
#echo "TNU4 $TNU4"
#echo "VISC2 $VISC2"
#echo "VISC4 $VISC4"
#echo "ZNUDG $ZNUDG"
#echo "TNUDG $TNUDG"
#echo "M2NUDG $M2NUDG"
#echo "M3NUDG $M3NUDG"


echo "Double check the following parameters for this grid interval in the table below:"
echo " "

echo " , , , , , , , , , " >dum.txt
echo "$rounded,$DT,$NDTFAST,$TNU2,$TNU4,$VISC2,$VISC4,$ZNUDG,$TNUDG,$M2NUDG,$M3NUDG,$gridName" >> dum.txt

cat DB.csv dum.txt | column -s, -t
\rm dum.txt

echo " ";echo " "
echo "print out the LBC"
echo " "

zBC=`   grep "LBC(isFsur)" $runInputFile | grep -v '! !' | grep -v '!!' | grep -v values | grep -v ad_ `
ubarBC=`grep "LBC(isUbar)" $runInputFile | grep -v '! !' | grep -v '!!' | grep -v values | grep -v ad_ `
vbarBC=`grep "LBC(isVbar)" $runInputFile | grep -v '! !' | grep -v '!!' | grep -v values | grep -v ad_ `
uvelBC=`grep "LBC(isUvel)" $runInputFile | grep -v '! !' | grep -v '!!' | grep -v values | grep -v ad_ `
vvelBC=`grep "LBC(isVvel)" $runInputFile | grep -v '! !' | grep -v '!!' | grep -v values | grep -v ad_ `
mtkeBC=`grep "LBC(isMtke)" $runInputFile | grep -v '! !' | grep -v '!!' | grep -v values | grep -v ad_ `

tempBC=`grep "! temperature" $runInputFile |grep -v salin | grep -v '!!' | grep -v '! !' | grep -v ad_ `
saltBC=`grep "! salinity" $runInputFile |grep -v temp | grep -v '!!' | grep -v '! !' | grep -v ad_ `

saltBC=`echo -e $saltBC | cut -d '\' -f 1`
saltBC="\t  $saltBC ! \t salinity"
#echo -e $saltBC

echo $zBC	        > dum.txt
echo $ubarBC	   >> dum.txt
echo $vbarBC       >> dum.txt
echo $uvelBC       >> dum.txt
echo $vvelBC       >> dum.txt
echo $mtkeBC       >> dum.txt
echo $tempBC       >> dum.txt
echo -e $saltBC    >> dum.txt

cat dum.txt | column -s" " -t
\rm dum.txt


echo " ";echo " "


#exit


#!!!!!!!!!!!!!!!!!!!!
# Optional README file for the experiment directory
                      
echo $exptName > README
echo "The idea here is to redo an old experiment" >>README
echo "  /archive/u1/uaf/jgpender/roms-kate_svn/TS_0.03125/ExperimentsTS_0.03125_2015_001_TidesM2_10plus5days_tidesOnly" >>README
echo "with a different bathy smoothing. The grid file has" >>README
echo "14 layers in hmax, so the point is to put a different one of these into h." >>README




#!!!!!!!!!!!!!!
# put exit here to stop before compile

#exit




#!!!!!!!!!!!!!!!!!!!!!!!!!!!
# compile ROMS and move the executable to the experiment directory

#echo "makefile is " scriptStuff/makefile_$gridName
cp scriptStuff/makefile_template makefile

#sed -i "/template_appl/c\ $ROI" makefile
sed -i "s/template_appl/$ROI/" makefile

sed -i "s/template_header/$gridName/" makefile
sed -i "s/template_analyt/$gridName/" makefile



echo ""   
echo "" 
echo ""

## compile
make -j 8 clean
#\rm -r Build
make    > makelogM

#exit



# go ahead and make a debug copy
echo "about to clean and then compile romsG"
sed -i '/USE_DEBUG ?=/c\   USE_DEBUG ?= on' makefile
make clean
#\rm -r Build
make -j 8 > makelogG

#exit

mkdir $exptName
cp -r $Appsdir $exptName
cp runROMS.bash $exptName
cp Apps/varinfo.dat $exptName

#\cp -r  ./Build $exptName
#mv makelog* $exptName
#\cp -r ./ROMS $exptName/Apps


echo "done with compiles"



if [ -e romsM ] || [ -e romsG ]; then
        mv roms* $exptName
        mv makelog $exptName
else
        echo "Compile problem, dude."
#        exit
fi

# move to the experiment directory and tidy up

cd $exptName
pwd

echo "gridName=" $gridName
\mv $gridName "Apps"
mv varinfo.dat Apps

mv ../../README .

cp ~/.runROMSintel Apps/runROMSintel
chmod gu+w Apps/runROMSintel

#cp ~/roms/ROMS .



#mv Apps/TPXOstuff .



#mv Apps/matlab .
#mv Apps/regridTools .
#mv Apps/spectralTools .

#cp $ROMSdir/addlTools/* .

cp ../../InputFiles/Gridpak/$gridFileShort .


# create the batch script and start the job

wallTime="24:00:00"
nProc=` echo " $tileX * $tileY " | bc `



#echo "np is " $np
#echo "wallTime is " $wallTime
#echo "number of processors is "$nProc
#echo "number of nodes is " $nNodes

echo " "
echo "NOTE: this is a $runDays day run and the requested wall time is $wallTime using $nProc processors"
echo " "



    batName=$exptMode".sbat"
    echo $batName


    echo "#!/bin/bash" 																					> $batName
    echo '#SBATCH --partition=t2standard'               												>>$batName
#    echo '#SBATCH --partition=t2small'              													>>$batName 
    echo '#SBATCH --ntasks='$nProc            															>>$batName
    echo '#SBATCH --mail-user=jgpender@alaska.edu'     													>>$batName
    echo '#SBATCH --mail-type=BEGIN'      																>>$batName
    echo '#SBATCH --mail-type=END'      																>>$batName
    echo '#SBATCH --mail-type=FAIL'      																>>$batName
    echo '#SBATCH --time='$wallTime      																>>$batName
    echo '#SBATCH --output=roms.%j'      																>>$batName

    echo 'source ~/.runROMSintel'                   													>>$batName

    echo 'ulimit -l unlimited'                         													>>$batName
    echo 'ulimit -s unlimited'                        													>>$batName


    echo '/bin/rm -r  netcdfOutput log nodes.* roms.*'													>>$batName
    echo 'mkdir netcdfOutput'																			>>$batName




    echo 'NRREC=`grep NRREC Apps/ocean_niskine.in | grep -v ! | cut -d "=" -f2 | cut -c 2`'				>>$batName
    echo 'if [ $NRREC != "0" ]; then'																	>>$batName
    echo '	lastData=`grep ININAME Apps/ocean_niskine.in | grep -v '!' | rev | cut -d '/' -f2 | rev`'	>>$batName
    echo '	cp $lastData/*rst.nc netcdfOutput'															>>$batName
    echo '    cp $lastData/*flt.nc netcdfOutput'														>>$batName
    echo '	ROI=`find Apps -name *.in | rev | cut -d '.' -f2 | cut -d '_' -f1 |rev`'					>>$batName	
    echo '	dum="_rst.nc"'																				>>$batName
    echo '	sed -i "s/floats_$ROI.in/floats_$ROI$dum/" Apps/ocean_$ROI.in'								>>$batName		
    echo 'fi'																							>>$batName





    echo "mpirun -np $nProc  romsM ./Apps/ocean_$exptname.in > log"   									>>$batName 

    echo "bash ../../../addl_Scripts/timeROMS/getRunTime.bash >> log" 									>>$batName

    rm nodes.*


mkdir netcdfOutput

# temp stuff
#mpirun -np 4 ./romsM  Apps/ocean_palau.in >log &
# temp end





sbatch $batName


echo "again, the experiment name is"
echo $exptName










