top=`pwd`
for file in `ls  | grep ini_2`
do
	cd $top'/'$file
	bash buildData.bash	
done
