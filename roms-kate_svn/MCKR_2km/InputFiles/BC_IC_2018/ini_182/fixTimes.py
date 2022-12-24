import numpy as np
import netCDF4
import sys


ncfile = sys.argv[1]
nc = netCDF4.Dataset(ncfile, 'a', format='NETCDF3_CLASSIC')

oldTime = 3739392000
newTime = 3739305600

time = nc.variables['ocean_time'][:]
print('time ', time)
time = 3739392000

print('new time ', time) 

nc.variables['ocean_time'][:] = time

nc.close()
