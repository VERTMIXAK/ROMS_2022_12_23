\rm -r SC*/TP*

for dir in `ls |grep SC`
do
	echo $dir
	cd $dir
	pwd

	cp -r ../TP* .
	cd TP*

	bash batM2.bash
	bash batS2.bash
	bash batK1.bash
	bash batO1.bash
	cd ../..	
done
