#!/bin/csh   

set nonomatch

foreach dirList (`ls .. | grep set | sort -r`)
#	echo $dirList
#        ls ../$dirList
	foreach fileList(`ls ../$dirList |grep palau |grep -v restart | grep -v rst`)
#		echo `ls ../$dirList"/"$fileList`
		ln -s ../$dirList"/"$fileList $fileList
	end
end

