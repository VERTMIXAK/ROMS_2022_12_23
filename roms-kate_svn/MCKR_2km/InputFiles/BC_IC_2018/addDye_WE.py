import numpy as np
import netCDF4
import sys

# NOTE: modified to ignore southern boundary


ncfile = sys.argv[1]
nc = netCDF4.Dataset(ncfile, 'a', format='NETCDF3_CLASSIC')

#west = nc.variables['temp_west'][0,:,:]
#east = nc.variables['temp_east'][0,:,:]
#north = nc.variables['temp_north'][0,:,:]
#south = nc.variables['temp_south'][0,:,:]
##spval = south._FillValue


spval = 1.e30




nc.createDimension('dye_time', 1)
nc.createVariable('dye_time', 'f8', ('dye_time'))
nc.variables['dye_time'].units = 'days'
nc.variables['dye_time'][:] = 0.0



# west

west = 1.0
east = 0.0
north = 0.0
south = 0.0
age = 0.0

nc.createVariable('dye_west_01', 'f8', ('dye_time', 's_rho', 'eta_rho'), fill_value=spval)
nc.variables['dye_west_01'].long_name = 'Western boundary condition for dye_01.'
nc.variables['dye_west_01'].units = 'N/A'
nc.variables['dye_west_01'].time = 'dye_time'
nc.variables['dye_west_01'][:] = west

nc.createVariable('dye_east_01', 'f8', ('dye_time', 's_rho', 'eta_rho'), fill_value=spval)
nc.variables['dye_east_01'].long_name = 'Eastern boundary condition for dye_01.'
nc.variables['dye_east_01'].units = 'N/A'
nc.variables['dye_east_01'].time = 'dye_time'
nc.variables['dye_east_01'][:] = east

nc.createVariable('dye_north_01', 'f8', ('dye_time', 's_rho', 'xi_rho'), fill_value=spval)
nc.variables['dye_north_01'].long_name = 'Northern boundary condition for dye_01.'
nc.variables['dye_north_01'].units = 'N/A'
nc.variables['dye_north_01'].time = 'dye_time'
nc.variables['dye_north_01'][:] = north

nc.createVariable('dye_south_01', 'f8', ('dye_time', 's_rho', 'xi_rho'), fill_value=spval)
nc.variables['dye_south_01'].long_name = 'Southern boundary condition for dye_01.'
nc.variables['dye_south_01'].units = 'N/A'
nc.variables['dye_south_01'].time = 'dye_time'
nc.variables['dye_south_01'][:] = south



nc.createVariable('dye_west_02', 'f8', ('dye_time', 's_rho', 'eta_rho'), fill_value=spval)
nc.variables['dye_west_02'].long_name = 'Western dye age boundary condition for dye_01.'
nc.variables['dye_west_02'].units = 'time'
nc.variables['dye_west_02'].time = 'dye_time'
nc.variables['dye_west_02'][:] = age
 
nc.createVariable('dye_east_02', 'f8', ('dye_time', 's_rho', 'eta_rho'), fill_value=spval)
nc.variables['dye_east_02'].long_name = 'Eastern dye age boundary condition for dye_01.'
nc.variables['dye_east_02'].units = 'time'
nc.variables['dye_east_02'].time = 'dye_time'
nc.variables['dye_east_02'][:] = age
 
nc.createVariable('dye_north_02', 'f8', ('dye_time', 's_rho', 'xi_rho'), fill_value=spval)
nc.variables['dye_north_02'].long_name = 'Northern dye age boundary condition for dye_01.'
nc.variables['dye_north_02'].units = 'time'
nc.variables['dye_north_02'].time = 'dye_time'
nc.variables['dye_north_02'][:] = age

nc.createVariable('dye_south_02', 'f8', ('dye_time', 's_rho', 'xi_rho'), fill_value=spval)
nc.variables['dye_south_02'].long_name = 'Southern dye age boundary condition for dye_01.'
nc.variables['dye_south_02'].units = 'time'
nc.variables['dye_south_02'].time = 'dye_time'
nc.variables['dye_south_02'][:] = age


# east

west = 0.0
east = 0.0
north = 0.0
south = 0.0
age = 0.0

nc.createVariable('dye_west_03', 'f8', ('dye_time', 's_rho', 'eta_rho'), fill_value=spval)
nc.variables['dye_west_03'].long_name = 'Western boundary condition for dye_03.'
nc.variables['dye_west_03'].units = 'N/A'
nc.variables['dye_west_03'].time = 'dye_time'
nc.variables['dye_west_03'][:] = west

nc.createVariable('dye_east_03', 'f8', ('dye_time', 's_rho', 'eta_rho'), fill_value=spval)
nc.variables['dye_east_03'].long_name = 'Eastern boundary condition for dye_03.'
nc.variables['dye_east_03'].units = 'N/A'
nc.variables['dye_east_03'].time = 'dye_time'
nc.variables['dye_east_03'][:] = east

nc.createVariable('dye_north_03', 'f8', ('dye_time', 's_rho', 'xi_rho'), fill_value=spval)
nc.variables['dye_north_03'].long_name = 'Northern boundary condition for dye_03.'
nc.variables['dye_north_03'].units = 'N/A'
nc.variables['dye_north_03'].time = 'dye_time'
nc.variables['dye_north_03'][:] = north

nc.createVariable('dye_south_03', 'f8', ('dye_time', 's_rho', 'xi_rho'), fill_value=spval)
nc.variables['dye_south_03'].long_name = 'Southern boundary condition for dye_03.'
nc.variables['dye_south_03'].units = 'N/A'
nc.variables['dye_south_03'].time = 'dye_time'
nc.variables['dye_south_03'][:] = south


nc.createVariable('dye_west_04', 'f8', ('dye_time', 's_rho', 'eta_rho'), fill_value=spval)
nc.variables['dye_west_04'].long_name = 'Western dye age boundary condition for dye_01.'
nc.variables['dye_west_04'].units = 'time'
nc.variables['dye_west_04'].time = 'dye_time'
nc.variables['dye_west_04'][:] = age
 
nc.createVariable('dye_east_04', 'f8', ('dye_time', 's_rho', 'eta_rho'), fill_value=spval)
nc.variables['dye_east_04'].long_name = 'Eastern dye age boundary condition for dye_01.'
nc.variables['dye_east_04'].units = 'time'
nc.variables['dye_east_04'].time = 'dye_time'
nc.variables['dye_east_04'][:] = age
 
nc.createVariable('dye_north_04', 'f8', ('dye_time', 's_rho', 'xi_rho'), fill_value=spval)
nc.variables['dye_north_04'].long_name = 'Northern dye age boundary condition for dye_01.'
nc.variables['dye_north_04'].units = 'time'
nc.variables['dye_north_04'].time = 'dye_time'
nc.variables['dye_north_04'][:] = age

nc.createVariable('dye_south_04', 'f8', ('dye_time', 's_rho', 'xi_rho'), fill_value=spval)
nc.variables['dye_south_04'].long_name = 'Southern dye age boundary condition for dye_01.'
nc.variables['dye_south_04'].units = 'time'
nc.variables['dye_south_04'].time = 'dye_time'
nc.variables['dye_south_04'][:] = age


nc.close()


