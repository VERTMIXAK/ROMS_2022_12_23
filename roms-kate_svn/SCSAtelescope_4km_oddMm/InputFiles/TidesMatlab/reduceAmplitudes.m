origFile = 'AllComponents_2007.nc';
newFile1 = 'AllComponents.5_2007.nc';
newFile2 = 'AllComponents.25_2007.nc';

unix(['cp ',origFile,' ',newFile1]);
unix(['cp ',origFile,' ',newFile2]);

dum = nc_varget(newFile1,'tide_Cmax');
nc_varput(newFile1,'tide_Cmax',.5*dum);

dum = nc_varget(newFile1,'tide_Cmin');
nc_varput(newFile1,'tide_Cmin',.5*dum);

dum = nc_varget(newFile1,'tide_Eamp');
nc_varput(newFile1,'tide_Eamp',.5*dum);




dum = nc_varget(newFile2,'tide_Cmax');
nc_varput(newFile2,'tide_Cmax',.25*dum);

dum = nc_varget(newFile2,'tide_Cmin');
nc_varput(newFile2,'tide_Cmin',.25*dum);

dum = nc_varget(newFile2,'tide_Eamp');
nc_varput(newFile2,'tide_Eamp',.25*dum);
