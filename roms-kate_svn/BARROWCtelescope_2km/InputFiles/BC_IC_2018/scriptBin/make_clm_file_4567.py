import matplotlib
matplotlib.use('Agg')
import subprocess
from multiprocessing import Pool
from functools import partial
import os
import sys
import string

import pycnal
import pycnal_toolbox
import subprocess

irange=(200,600)
jrange=(250,720)
#irange = None
#jrange = None

#months = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
months = ['04', '05', '06', '07']
#months = ['04','05','06','07','08','09','10']
#months = ['06']

#src_varname = ['aice', 'hice', 'snow_thick']
src_varname2 = ['zeta', 'temp', 'salt', 'u_eastward', 'v_northward']
src_varname = ['aice', 'hice', 'snow_thick', 'uice_eastward', 'vice_northward']
src_sigma = ['sig11', 'sig22', 'sig12']
part_filename = '/import/c1/VERTMIX/jgpender/roms-kate_svn/BARROW_Kate/InputFiles/KatesSourceFiles/arctic4_2018_'
#part_filename = '/import/AKWATERS/kshedstrom/Arctic4/run16/months/arctic4_2018_'
dst_grd = pycnal.grid.get_ROMS_grid('BARROWCtelescope_2km')
src_grd = pycnal.grid.get_ROMS_grid('ARCTIC4')

def do_file(month):
    global src_varname
    wts_file = './ini_121/remap_weights_ARCTIC4_to_BARROWCtelescope_2km_bilinear_*'
    src_filename = part_filename + month + '.nc'
    print('src_filename = ',src_filename)
    lcopy = list(src_varname)
    l2copy = list(src_varname2)
    scopy = list(src_sigma)
    dst_var = pycnal_toolbox.remapping(l2copy, src_filename,\
                     wts_file, src_grd, dst_grd, rotate_uv=True,\
                     irange=irange, jrange=jrange, \
                     uvar='u_eastward', vvar='v_northward',\
                     rotate_part=True)
#    dst_var = pycnal_toolbox.remapping(lcopy, src_filename, \
#                     wts_file, src_grd, dst_grd, irange=irange, \
#                     jrange=jrange)
    dst_var = pycnal_toolbox.remapping(lcopy, src_filename, \
                     wts_file, src_grd, dst_grd, rotate_uv=True, \
                     irange=irange, jrange=jrange, \
                     uvar='uice_eastward', vvar='vice_northward', \
                     rotate_part=True)
    dst_var = pycnal_toolbox.remapping_tensor(scopy, src_filename,\
                     wts_file, src_grd, dst_grd, rotate_sig=True,\
                     irange=irange, jrange=jrange)

#processes = 1
processes = 4
p = Pool(processes)
results = p.map(do_file, months)
