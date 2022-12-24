for month in `cat months.txt`
do
	outFile="arctic4_"$month"_BARROWCtelescope_2km.nc"
	echo $month $outFile
	ls ../averages/*$month*
	

exit
	
#	ncrcat ../dailyROMSoutput/*$month* dum.nc
#	ncra -d ocean_time dum.nc $outFile
#	\rm dum.nc

	ncra ../averages/*$month* $outFile

done
