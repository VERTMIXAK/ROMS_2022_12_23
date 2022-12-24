source ~/.runPycnal

for file in `ls /import/c1/VERTMIX/jgpender/roms-kate_svn/BARROW_Kate/InputFiles/KatesSourceFiles/averages/arc*2018-09*`
do
	date=`echo $file | cut -d '-' -f3-4 | cut -d '.' -f1 `
	cp ini.py_template iniSep.py
	sed -i "s/XXXXX/$date/" iniSep.py

	python iniSep.py

done

