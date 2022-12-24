for dir in `ls | grep N | grep -v template | grep -v LBC`
do
	echo $dir | cut -d '_' -f5,6
	lat=`ncks -H -d xi_rho,2 -d eta_rho,2 -v lat_rho $dir/*.nc | cut -d '=' -f2`
    lon=`ncks -H -d xi_rho,2 -d eta_rho,2 -v lon_rho $dir/*.nc | cut -d '=' -f2`
	lon=` echo " $lon - 360 " | bc `
	echo $lon    $lat
	echo " "
done
