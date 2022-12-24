import netCDF4
import subprocess
import pyroms
from pyroms_toolbox import jday2date
import projmap
from mpl_toolkits.basemap import Basemap
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from datetime import datetime

grd = pyroms.grid.get_ROMS_grid('BARROW')
clat = grd.hgrid.lat_rho
clon = grd.hgrid.lon_rho

m = projmap.Projmap('barrow')
x, y = m(clon, clat)

colors = np.array([ [0.65, 0.60, 0.60], \
                      [0.65, 0.75, 0.75], \
                      [0.65, 0.90, 0.90], \
                      [0.60, 1.00, 1.00], \
                      [0.50, 1.00, 1.00], \
                      [0.40, 1.00, 1.00], \
                      [0.25, 1.00, 1.00], \
                      [0.10, 1.00, 1.00], \
                      [0.05, 0.95, 1.00], \
                      [0.00, 0.85, 1.00], \
                      [0.00, 0.75, 1.00], \
                      [0.00, 0.65, 1.00], \
                      [0.00, 0.50, 1.00], \
                      [0.00, 0.40, 0.85], \
                      [0.00, 0.30, 0.75], \
                      [0.00, 0.20, 0.60], \
                      [0.00, 0.00, 0.50]], 'f')
cmap = mpl.colors.ListedColormap(colors)

levels = [ 0, 10, 20, 30, 40, 50, 60, 100, 200, 400, 600, 800, \
           1000, 1500, 2000, 2500, 3000, 4000, 5000 ]

fig = plt.figure(figsize=(8,9))

print("Plotting Depth")
m.drawcoastlines()
m.drawmapboundary()
#m.drawmapboundary(fill_color='#99ffff')
m.fillcontinents(color='0.3',lake_color='0.3')
#   m.fillcontinents(color='coral',lake_color='aqua')
#nc = netCDF4.Dataset(file, "r")
#aice = nc.variables["aice"][0,:,:]
#time = nc.variables["ocean_time"][0]
#nc.close()
#cs = m.contourf(x, y, grd.vgrid.h, levels=levels, cmap=cmap, extend='both')
cs = m.contourf(x, y, grd.vgrid.h, levels, norm=mpl.colors.LogNorm(vmin=2., vmax=4000.), cmap=cmap)
parallels = np.arange(70.,76.,1.)
# labels = [left,right,top,bottom]
m.drawparallels(parallels,labels=[0, 0, 1, 0])
meridians = np.arange(-160.,-130.,5.)
m.drawmeridians(meridians,labels=[1, 1, 0, 1])
#   csa = m.contour(x, y, aice, levels=levels, linewidths=(1,), colors='k')
#   csa = m.contour(x, y, aice, levels=levels, colors=('k',))

#myday = jday2date(time/86400.)
#date_tag = myday.strftime('%d %B %Y')
#plt.title(date_tag, fontsize=20)

#print(date_tag)
cbar = plt.colorbar(cs, orientation='horizontal')
#cbar.ax.tick_params(labelsize=15)

plt.savefig('bathy4.png')
#   frames.append((fig))
plt.close()

