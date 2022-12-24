for month in `cat months.txt`
do
	outFile=ave_$month.nc
	echo $month $outFile
	ls ../dailyROMSoutput/*$month*
	
	
#	ncrcat ../dailyROMSoutput/*$month* dum.nc
#	ncra -d ocean_time dum.nc $outFile
#	\rm dum.nc

	ncra ../dailyROMSoutput/*$month* $outFile

done
