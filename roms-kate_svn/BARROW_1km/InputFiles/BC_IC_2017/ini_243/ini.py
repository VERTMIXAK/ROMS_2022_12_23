
import pycnal
import pycnal_toolbox

#src_varname = ['zeta','aice','hice','tisrf','snow_thick', \
#               'ageice','ti','t0mk','s0mk', 'temp','salt','u_eastward','v_northward']
src_varname = ['u_eastward','v_northward','zeta','aice','hice','tisrf', \
                'snow_thick','ageice','ti','t0mk','s0mk', 'temp','salt']
irange=(200,600)
jrange=(250,720)
#irange = None
#jrange = None

# Need to pick up ubar/vbar and uice/vice later

# Change src_filename to your directory for the file's containing variable data
src_filename = '/import/AKWATERS/kshedstrom/Arctic4/run16/averages/arctic4_avg_2017-08-31T.nc'
wts_file = "./remap_weights_ARCTIC4_to_BARROW_1km_bilinear_*"
src_grd = pycnal.grid.get_ROMS_grid('ARCTIC4')
dst_grd = pycnal.grid.get_ROMS_grid('BARROW_1km')
# Outfile is a parameter to allow you to place these created remap files in a different
# directory than the one that is default which is where the file came from.
dst_var = pycnal_toolbox.remapping(src_varname, src_filename, wts_file, \
                src_grd, dst_grd, rotate_uv=True, irange=irange, jrange=jrange, \
                uvar='u_eastward', vvar='v_northward', rotate_part=True)
dst_var = pycnal_toolbox.remapping(['uice','vice'], src_filename, \
                wts_file, src_grd, dst_grd, rotate_uv=True, \
                irange=irange, jrange=jrange, uvar='uice', vvar='vice')
#dst_var = pycnal_toolbox.remapping(['uice_eastward','vice_northward'], src_filename, \
#                wts_file, src_grd, dst_grd, rotate_uv=True, \
#                irange=irange, jrange=jrange, \
#                uvar='uice_eastward', vvar='vice_northward', rotate_part=True)
dst_var = pycnal_toolbox.remapping_tensor(['sig11','sig22','sig12'], src_filename, \
                wts_file, src_grd, dst_grd, rotate_sig=True, \
                irange=irange, jrange=jrange, shapiro=False)
