import matplotlib
matplotlib.use('Agg')
import subprocess
import pdb
from multiprocessing import Pool

import pycnal
import pycnal_toolbox

src_varname = ['zeta','temp','salt','u_eastward','v_northward']

irange=(200,600)
jrange=(250,720)
#irange = None
#jrange = None

#months = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
#months = ['01', '02', '03', '04', '05', '06', '07', '08']
#months = ['06','07','08','09','10']
months = ['06']

# Change src_filename to your directory for the file's containing variable data
part_filename = '/import/c1/VERTMIX/jgpender/roms-kate_svn/BARROW_Kate/InputFiles/KatesSourceFiles/averages/arctic4_avg_2018-'
#part_filename = '/import/AKWATERS/kshedstrom/Arctic4/run16/averages/arctic4_avg_2018-'

wts_file = "./ini_121/remap_weights_ARCTIC4_to_BARROWB_2km_bilinear_*"
src_grd = pycnal.grid.get_ROMS_grid('ARCTIC4')
dst_grd = pycnal.grid.get_ROMS_grid('BARROWB_2km')
# Outfile is a parameter to allow you to place these created remap files in a different
# directory than the one that is default which is where the file came from.

def do_file(month):
    src_filename = part_filename + month + '*.nc'
    lcopy = list(src_varname)
    print('working on file '+src_filename)
# didn't work even with processes=1
#    pdb.set_trace()
    dst_var = pycnal_toolbox.remapping_bound(lcopy, src_filename, \
                     wts_file, src_grd, dst_grd, rotate_uv=True, \
                     irange=irange, jrange=jrange, \
                     uvar='u_eastward', vvar='v_northward', rotate_part=True)

processes = 4
p = Pool(processes)
results = p.map(do_file, months)
