base=`ls *.h | grep -v ana_ | cut -d '.' -f1`

inFile=`ls ocean*.in`
outFile=$inFile"_restart"
cp $inFile $outFile

dum1="NRREC == 0"
dum2="NRREC == -1"
sed -i "s/$dum1/$dum2/" $outFile

dum1=`grep "FPOSNAM =" $outFile | grep -v '!' | rev | cut -d '/' -f1 | rev`
dum2=`echo $dum1"_restart"`
sed -i "s/$dum1/$dum2/" $outFile



dum2="     ININAME == .\/netcdfOutput_daysXX_YY\/"$base"_rst.nc"

dumN=`grep -n "ININAME =" $outFile | cut -d ':' -f1`

echo "dumN $dumN  dum2 $dum2"

dum=$dumN"s/.*/$dum2/"

sed -i "1031s/.*/$dum2/"  $outFile

