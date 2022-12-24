\rm *.nc
for date in `cat dates.txt`
do
	for file in `ls /import/AKWATERS/kshedstrom/Arctic4/run16/averages/arctic*$date*`
	do
		outFile=`echo $file | rev | cut -d '/' -f1 | rev`
		echo $outFile
		ncks -v aice,hice,tisrf,snow_thick,ti,uice_eastward,vice_northward,sig11,sig22,sig12,temp,salt,u,v,zeta $file $outFile
	done

#	ncks -v aice,hice,tisrf,snow_thick,ti,uice_eastward,vice_northward,sig11,sig22,sig12  /import/AKWATERS/kshedstrom/Arctic4/run16/averages/arctic*$date* $outFile

done
