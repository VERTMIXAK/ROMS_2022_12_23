\rm -r netcdfOutput_nameLinks
mkdir netcdfOutput_nameLinks
for file in ./netcdfOutput*/*his*.nc 
do
	oldName=`echo $file | rev | cut -d '/' -f1 | cut -d '_' -f2-10 | rev`
#	echo "old name  " $oldName
    seconds=`ncdump -v ocean_time $file | grep ';' | tail -1 | rev | cut -d ' ' -f2 | rev`
	lineOrig=`grep -n $seconds ~/arch/addl_Scripts/dayConverterCommas.txt | cut -d ':' -f1`
	line=`echo " $lineOrig - 1 " |bc`
	date=`head -$line ~/arch/addl_Scripts/dayConverterCommas.txt | tail -1 | cut -d ',' -f1`
	year=`echo $date | cut -d '-' -f1`
    month=`echo $date | cut -d '-' -f2`
    day=`echo $date | cut -d '-' -f3`
	newName=`echo $oldName"_"$year$month$day".nc"`
#    echo $file $year $month $day
	echo $file $newName
	ln $file "netcdfOutput_nameLinks/"$newName
#name_his2_YYYYMMDD.nc
done

