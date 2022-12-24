hraw = nc_varget('BARROW_500m_posLons.nc','hraw');

size(hraw)


%%

fig(1);
pcolor(sq(hraw(7,:,:)-hraw(5,:,:)));shading flat;colorbar

fig(2);
pcolor(sq(hraw(7,end-100:end,1:100)-hraw(4,end-100:end,1:100)));shading flat;colorbar