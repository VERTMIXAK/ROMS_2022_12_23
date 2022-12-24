\rm *.nc

file1=SCSA_4km_2007_091_tidesOnly_M2S2K1O1_nudg150
ncrcat ../$file1/netcdfOutput/*his2* dum1.nc

nud1=`echo $file1 | cut -d 'g' -f2`

echo $nud1

while read file2
do
	nud2=`echo $file2 | cut -d 'g' -f2`
	name="ncdiffHIS2_"$nud1"_vs_"$nud2".nc"
    echo $file2  $nud2  $name
	ncrcat ../$file2/netcdfOutput/*his2* dum2.nc
	ncdiff dum1.nc dum2.nc $name
	\rm dum2.nc
done < fileList.txt

