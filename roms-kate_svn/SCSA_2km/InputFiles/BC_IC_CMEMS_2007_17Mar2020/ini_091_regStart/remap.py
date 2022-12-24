import numpy as np
import os
try:
  import netCDF4 as netCDF
except:
  import netCDF3 as netCDF
import matplotlib.pyplot as plt
import time
from datetime import datetime
from matplotlib.dates import date2num, num2date

import pycnal
import pycnal_toolbox
import _remapping

class nctime(object):
    pass

def remap(src_file, src_varname, src_grd, dst_grd, dxy=20, cdepth=0, kk=0, dst_dir='./'):
    
    # get time
    nctime.long_name = 'time'
    nctime.units = 'days since 1900-01-01 00:00:00'
    # time reference "days since 1900-01-01 00:00:00"
#    ref = datetime(1900, 1, 1, 0, 0, 0)
#    ref = date2num(ref)
#    tag = src_file.rsplit('/')[-1].rsplit('_')[-2].rsplit('-')[0]
#    print(tag)
#    year = int(tag[:4])
#    month = int(tag[4:6])
#    day = int(tag[6:])
#    time = datetime(year, month, day, 0, 0, 0)
#    time = date2num(time)
#    time = time - ref
#    time = time + 2.5 # 5-day average
    cdf = netCDF.Dataset(src_file) 
    src_var = cdf.variables[src_varname][0]
    time = cdf.variables['ocean_time'][0]


    # create IC file
    dst_file = src_file.rsplit('/')[-1]
    dst_file = dst_dir + dst_file[:-3] + '_' + src_varname + '_ic_' + dst_grd.name + '.nc'
    print('\nCreating file', dst_file)
    if os.path.exists(dst_file) is True:
        os.remove(dst_file)
    pycnal_toolbox.nc_create_roms_file(dst_file, dst_grd, nctime)

    # open IC file
    nc = netCDF.Dataset(dst_file, 'a', format='NETCDF3_64BIT')

    #load var
    cdf = netCDF.Dataset(src_file)
    src_var = cdf.variables[src_varname]

    #get missing value
    spval = src_var._FillValue
    src_var = src_var[0]

    # determine variable dimension
    #ndim = len(src_var.dimensions)
    ndim = len(src_var.shape)

    print("jgp print")
    print('jgp:  src_varname = ', src_varname)


    if src_varname == 'ssh':
        pos = 't'
        Cpos = 'rho'
        z = src_grd.z_t
        Mp, Lp = dst_grd.hgrid.mask_rho.shape
        wts_file = 'remap_weights_GLBa0.08_to_SCSA_2km_bilinear_t_to_rho.nc'
        dst_varname = 'zeta'
        dimensions = ('ocean_time', 'eta_rho', 'xi_rho')
        long_name = 'free-surface'
        units = 'meter'
        field = 'free-surface, scalar, series'
    elif src_varname == 'temp':
        pos = 't'
        Cpos = 'rho'
        z = src_grd.z_t
        Mp, Lp = dst_grd.hgrid.mask_rho.shape
        wts_file = 'remap_weights_GLBa0.08_to_SCSA_2km_bilinear_t_to_rho.nc'
        dst_varname = 'temp'
        dimensions = ('ocean_time', 's_rho', 'eta_rho', 'xi_rho')
        long_name = 'potential temperature'
        units = 'Celsius'
        field = 'temperature, scalar, series'
    elif src_varname == 'salt':
        pos = 't'
        Cpos = 'rho'
        z = src_grd.z_t
        Mp, Lp = dst_grd.hgrid.mask_rho.shape
        wts_file = 'remap_weights_GLBa0.08_to_SCSA_2km_bilinear_t_to_rho.nc'
        dst_varname = 'salt'
        dimensions = ('ocean_time', 's_rho', 'eta_rho', 'xi_rho')
        long_name = 'salinity'
        units = 'PSU'
        field = 'salinity, scalar, series'
    else:
#        raise ValueError, 'Undefined src_varname'
        print('some kind of error')

    if ndim == 3:
        # build intermediate zgrid
        zlevel = -z[::-1,0,0]
        nzlevel = len(zlevel)
        dst_zcoord = pycnal.vgrid.z_coordinate(dst_grd.vgrid.h, zlevel, nzlevel)
        dst_grdz = pycnal.grid.ROMS_Grid(dst_grd.name+'_Z', dst_grd.hgrid, dst_zcoord)


    # create variable in file
    print('Creating variable', dst_varname)
    nc.createVariable(dst_varname, 'f8', dimensions, fill_value=spval)
    nc.variables[dst_varname].long_name = long_name
    nc.variables[dst_varname].units = units
    nc.variables[dst_varname].field = field
    #nc.variables[dst_varname_north]._FillValue = spval


    # remapping
    print('remapping', dst_varname, 'from', src_grd.name, \
              'to', dst_grd.name)
    print('time =', time)


    if ndim == 3:
        # flood the grid
        print('flood the grid')

#        print('src_varname is   ', src_varname)
#        print('src_var is ',src_var)
#        print('src_grd is ',src_grd)
#        print('pos is ',pos)
#        print('spval is ',spval)
#        print('dxy is ',dxy)
#        print('cdepth is ',cdepth)
#        print('kk is', kk)

        src_varz = pycnal_toolbox.Grid_HYCOM.flood_fast(src_var, src_grd, pos=pos, spval=spval, \
                                dxy=dxy, cdepth=cdepth, kk=kk)
    else:
        src_varz = src_var

    # horizontal interpolation using scrip weights
    print('horizontal interpolation using scrip weights')
    dst_varz = pycnal.remapping.remap(src_varz, wts_file, \
                                          spval=spval)

    if ndim == 3:
        # vertical interpolation from standard z level to sigma
        print('vertical interpolation from standard z level to sigma')
        dst_var = pycnal.remapping.z2roms(dst_varz[::-1,:,:], dst_grdz, \
                          dst_grd, Cpos=Cpos, spval=spval, flood=False)
    else:
        dst_var = dst_varz

    # write data in destination file
    print('write data in destination file')
    nc.variables['ocean_time'][0] = time
    nc.variables[dst_varname][0] = dst_var

    # close destination file
    nc.close()

    if src_varname == 'ssh':
        return dst_varz
