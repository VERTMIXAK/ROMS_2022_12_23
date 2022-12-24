clear

% This process is not so hard on a Mercator grid because the edges fall on
% latitude and longitude lines. I used to be able to just type in the
% lat/lon extrema and be done with it. Other grids (Lambert Conic or rotated
% Lambert conic) won't have this at all, so I need a way to mathematically
% describe the edges, ideally based on information sucked up from the grid
% file.

% It turns out this is not so back because I can simply read in the lat/lon
% for the psi grid and they will form a nice rectilinear array even if the
% latitudes and longitudes are skew.


gridFile = '../Gridpak/BoB_4km.nc';

mask = nc_varget(gridFile,'mask_psi');
lat_rho  = nc_varget(gridFile,'lat_rho');
lon_rho  = nc_varget(gridFile,'lon_rho');
lat  = nc_varget(gridFile,'lat_psi');
lon  = nc_varget(gridFile,'lon_psi');
[ny nx] = size(lon);

% fig(20);clf;pcolor(mask);shading flat

%% Fiddle a bit

% I don't actually want to use the corners on the top edge; I only want to
% go up each side as far as the start of the land mask.

find(mask(:,1)==1);  jUL=ans(end)
find(mask(:,end)==1);jUR=ans(end)

LLlat = lat(1,1);
LLlon = lon(1,1);

ULlat = lat(jUL,1);
ULlon = lon(jUL,1);

LRlat = lat(1,end);
LRlon = lon(1,end);

URlat = lat(jUR,end);
URlon = lon(jUR,end);


% Plot the 4 water corners (red) plus the land locked corners on the top
% edge (green).

fig(1);clf;plot(LLlon,LLlat,'r*');hold on
plot(LRlon,LRlat,'r*')
plot(ULlon,ULlat,'r*')
plot(URlon,URlat,'r*')

plot(lon(end,1),lat(end,1),'g*')
plot(lon(end,end),lat(end,end),'g*')

plot(lon(1,:),lat(1,:))
plot(lon(1:jUL,1),lat(1:jUL,1))
plot(lon(1:jUR,end),lat(1:jUR,end))

floatLat = [LLlat ULlat LRlat URlat];
floatLon = [LLlon ULlon LRlon URlon];

%% Do the bottom edge

% The length of the bottom edge is 992 km, which means
%   992 / 25 = 40 25-km intervals

sw_dist([lat(1,1) lat(1,end)],[lon(1,1) lon(1,end)],'km')/(nx-1);
sw_dist([lat(1,1) lat(1,end)],[lon(1,1) lon(1,end)],'km')

% I should be able to calculate a new set of lat/lon using interp2. I'll do
% this because the edges are not necessarily straight lines in lat/lon. You
% can definitely see this when you plot the lat/lon points for the bottom
% edge against a straight line connecting the corners (red).

% fig(8);clf;plot(lon(1,:));hold on;plot([1 nx],[lon(1,1) lon(1,end)],'r');title('just lon')
% fig(9);clf;plot(lat(1,:));hold on;plot([1 nx],[lat(1,1) lat(1,end)],'r');title('just lat')
% fig(10);clf;plot(lon(1,:),lat(1,:));hold on;plot([lon(1,1) lon(1,end)],[lat(1,1) lat(1,end)],'r');title('lat vs lon')

% I should be able to pick a set of lats and then let interp2 pick the lons
% to lie on the curce 

lonB = lon(1,1) + (1:39)* (lon(1,end)-lon(1,1))/40;
latB = interp1(lon(1,:),lat(1,:),lonB);
plot(lonB,latB,'g*')

% Looks fine, so paste the into my float plot.
fig(1); plot(lonB,latB,'b*')

floatLat = [floatLat latB];
floatLon = [floatLon lonB];

% Plot this for confirmation
% fig(20);clf;
% plot(lon_rho(1:2,:),lat_rho(1:2,:),'b.');hold on
% keyboard
% plot(lonB,latB,'r.')
% keyboard
% plot(LLlon,LLlat,'r.')
% keyboard
% plot(LRlon,LRlat,'r.')

%% Sides, general discussion

% I'm really only interested in the over-water length of the sides. The
% coast is not straight, of course, so the length of the LHS (water only),
% 672 km, is not the same as the length of the RHS, 632 km.

lengthL = sw_dist([lat(1,1) lat(jUL,1)],[lon(1,1) lon(jUL,1)],'km')
lengthR = sw_dist([lat(1,end) lat(jUR,end)],[lon(1,end) lon(jUR,end)],'km')

% The sides are also trickier because Harper wants 10 km intervals near the
% coast (up to ~ 100 km out) and 25 km intervals after that. I am going put
% the outer 550 km on 25 km intervals, leaving
%   118 km of ~10 km intervals on the LHS
% and
%   78  km of ~10 km intervals on the RHS


%% Do the LHS

% Find the location separating the 10 km intervals from the 25 km
% intervals. It should be 550 km from the lower left corner.

midLonL = lon(1,1) - (lon(1,1) -lon(jUL,1))*550/lengthL;
midLatL = interp1(lon(:,1),lat(:,1),midLonL);
sw_dist([lat(1,1) midLatL],[lon(1,1) midLonL],'km')
fig(1);plot(midLonL,midLatL,'r*')

% Do the 25 km intervals, 22 count

lonL25 = midLonL + (1:21)* (lon(1,1)-midLonL)/22;
latL25 = interp1(lon(:,1),lat(:,1),lonL25);
fig(1); plot(lonL25,latL25,'b*')

% Do the 10 km intervals, 12 count

lonL10 = lon(jUL,1) + (1:11)* (midLonL-lon(jUL,1))/12;
latL10 = interp1(lon(:,1),lat(:,1),lonL10);
fig(1); plot(lonL10,latL10,'b*')

floatLat = [floatLat midLatL latL25 latL10];
floatLon = [floatLon midLonL lonL25 lonL10];


% %Plot this for confirmation
% fig(20);clf;
% plot(lon_rho(:,1:2),lat_rho(:,1:2),'b.');hold on
% plot(LLlon,LLlat,'r.')
% plot(ULlon,ULlat,'r.')
% plot(midLonL,midLatL,'r.')
% keyboard
% plot(lonL10,latL10,'r.')
% keyboard
% plot(lonL25,latL25,'r.')
% keyboard


%% Do the RHS

% Find the location separating the 10 km intervals from the 25 km
% intervals. It should be 550 km from the lower right corner.

midLonR = lon(1,end) - (lon(1,end) -lon(jUR,end))*550/lengthR;
midLatR = interp1(lon(:,end),lat(:,end),midLonR);
sw_dist([lat(1,end) midLatR],[lon(1,end) midLonR],'km')
fig(1);plot(midLonR,midLatR,'r*')


% Do the 25 km intervals, 22 count

lonR25 = midLonR + (1:21)* (lon(1,end)-midLonR)/22;
latR25 = interp1(lon(:,end),lat(:,end),lonR25)
fig(1); plot(lonR25,latR25,'b*')

% Do the 10 km intervals, 8 count

lonR10 = lon(jUR,end) + (1:7)* (midLonR-lon(jUR,end))/8;
latR10 = interp1(lon(:,end),lat(:,end),lonR10)
fig(1); plot(lonR10,latR10,'b*')


floatLat = [floatLat midLatR latR25 latR10];
floatLon = [floatLon midLonR lonR25 lonR10];

% %Plot this for confirmation
% fig(20);clf;
% plot(lon_rho(:,end-1:end),lat_rho(:,end-1:end),'b.');hold on
% plot(LRlon,LRlat,'r.')
% plot(URlon,URlat,'r.')
% plot(midLonR,midLatR,'r.')
% keyboard
% plot(lonR10,latR10,'r.')
% keyboard
% plot(lonR25,latR25,'r.')
% keyboard

%% reorder the floats

floatLatOrig = floatLat;
floatLonOrig = floatLon;
keyboard

floatLat = ULlat;
floatLon = ULlon;
fig(1);plot(floatLon,floatLat,'c*')
keyboard

floatLat = [floatLat latL10];
floatLon = [floatLon lonL10];
fig(1);plot(floatLon,floatLat,'c*')
keyboard

floatLat = [floatLat midLatL];
floatLon = [floatLon midLonL];
fig(1);plot(floatLon,floatLat,'c*')
keyboard

floatLat = [floatLat latL25];
floatLon = [floatLon lonL25];
fig(1);plot(floatLon,floatLat,'c*')
keyboard

floatLat = [floatLat LLlat];
floatLon = [floatLon LLlon];
fig(1);plot(floatLon,floatLat,'c*')
keyboard

floatLat = [floatLat latB];
floatLon = [floatLon lonB];
fig(1);plot(floatLon,floatLat,'c*')
keyboard

floatLat = [floatLat LRlat];
floatLon = [floatLon LRlon];
fig(1);plot(floatLon,floatLat,'c*')
keyboard

floatLat = [floatLat fliplr(latR25)];
floatLon = [floatLon fliplr(lonR25)];
fig(1);plot(floatLon,floatLat,'c*')
keyboard

floatLat = [floatLat midLatR];
floatLon = [floatLon midLonR];
fig(1);plot(floatLon,floatLat,'c*')
keyboard

floatLat = [floatLat fliplr(latR10)];
floatLon = [floatLon fliplr(lonR10)];
fig(1);plot(floatLon,floatLat,'c*')
keyboard

floatLat = [floatLat URlat];
floatLon = [floatLon URlon];
fig(1);plot(floatLon,floatLat,'c*')






%% write the float locations to file

nDays = 10

fileID = fopen( 'floatNumbersOnly.txt','w');

for ii=1:length(floatLon); 
	fprintf(fileID,'1  1  1  %4i  0.0d0 %10.3f  %10.3f  -1  1.0d0 0.d0 0.d0 0.d0\n',nDays,floatLon(ii),floatLat(ii));
end;

done('write')


%%

fig(20);clf;
plot(lon_rho(:,1:2),lat_rho(:,1:2),'k.');hold on
plot(LLlon,LLlat,'r.')
plot(ULlon,ULlat,'r.')
plot(lonL25,latL25,'r.')
plot(lonL10,latL10,'r.')
plot(midLonL,midLatL,'r.')
