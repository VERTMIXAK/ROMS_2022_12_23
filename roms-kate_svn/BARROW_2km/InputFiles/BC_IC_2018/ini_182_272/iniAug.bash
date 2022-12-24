source ~/.runPycnal

for file in `ls /import/c1/VERTMIX/jgpender/roms-kate_svn/BARROW_Kate/InputFiles/KatesSourceFiles/averages/arc*2018-08*`
do
	date=`echo $file | cut -d '-' -f3-4 | cut -d '.' -f1 `
	cp ini.py_template iniAug.py
	sed -i "s/XXXXX/$date/" iniAug.py

	echo $file

	python iniAug.py

done

