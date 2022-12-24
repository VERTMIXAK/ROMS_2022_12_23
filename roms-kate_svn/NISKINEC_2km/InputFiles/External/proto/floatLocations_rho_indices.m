clear

% This process is not so hard on a Mercator grid because the edges fall on
% latitude and longitude lines. I used to be able to just type in the
% lat/lon extrema and be done with it. Other grids (Lambert Conic or rotated
% Lambert conic) won't have this at all, so I need a way to mathematically
% describe the edges, ideally based on information sucked up from the grid
% file.

% It turns out this is not so back because I can simply read in the lat/lon
% for the rho grid and they will form a nice rectilinear array even if the
% latitudes and longitudes are skew.


gridFile = '../Gridpak/BoB_4km.nc';

mask = nc_varget(gridFile,'mask_rho');
lat  = nc_varget(gridFile,'lat_rho');
lon  = nc_varget(gridFile,'lon_rho');
[ny nx] = size(lon);

% fig(20);clf;pcolor(mask);shading flat

%% Fiddle a bit

% I don't actually want to use the corners on the top edge; I only want to
% go up each side as far as the start of the land mask. The other thing is
% that I'm going to deliberately go in one grid point all around out of
% pure paranoia.

find(mask(:,2)==1);  jUL=ans(end)
find(mask(:,end-1)==1);jUR=ans(end)

% Do the LHS

LHS24 = [2:6:24*6]
LHS12 = [LHS24(end)+3:3:jUL]

jLHS = [fliplr(LHS12) fliplr(LHS24)]
iLHS = 2 + 0*jLHS

% Do the bottom

iBot = [2+6:6:nx-1-6]
jBot = 2 + 0*iBot

% Do the RHS
RHS24 = LHS24
RHS12 = [RHS24(end)+3:3:jUR]

jRHS = [RHS24 RHS12]
iRHS = (nx-1) + 0*jRHS

jTot = [jLHS jBot jRHS]
iTot = [iLHS iBot iRHS]

fig(1);clf;plot(iTot,jTot,'b*')


aaa=5;




%% write the float locations to file

nDays = 10

fileID = fopen( 'floatIndicesOnly.txt','w');

for ii=1:length(iTot); 
	fprintf(fileID,'1  0  1  %4i  0.0d0 %4i  %4i  -1  1.0d0 0.d0 0.d0 0.d0\n',nDays,iTot(ii),jTot(ii));
end;

done('write')
