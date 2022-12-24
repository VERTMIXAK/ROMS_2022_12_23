clear

% This process is not so hard on a Mercator grid because the edges fall on
% latitude and longitude lines. I used to be able to just type in the
% lat/lon extrema and be done with it. Other grids (Lambert Conic or rotated
% Lambert conic) won't have this at all, so I need a way to mathematically
% describe the edges, ideally based on information sucked up from the grid
% file.

% It turns out this is not so bad because I can simply read in the x/y
% for the rho grid and they will form a nice rectilinear array even if the
% latitudes and longitudes are skew.


gridFile = '../Gridpak/NISKINEC_2km.nc';

mask = nc_varget(gridFile,'mask_rho');
y  = nc_varget(gridFile,'y_rho');
x  = nc_varget(gridFile,'x_rho');
mask = nc_varget(gridFile,'mask_rho');

[ny,nx] = size(x);
inset= 1 + 4;

xSW =    inset;
xNW =    inset;
xSE = nx-inset;
xNE = nx-inset;

ySW =    (10+10)/2;
yNW =   (150+10)/2;
% yNW = ny-inset;
ySE =    (50)/2;
yNE = ny-inset;

fig(3);clf;pcolor(mask);shading flat;hold on

plot([xSW,xNW],[ySW,yNW])
% plot([xSW,xSE],[ySW,ySE])
% plot([xSE,xNE],[ySE,yNE])
% plot([xNW,xNE],[yNW,yNE])



fig(4);clf;pcolor(x,y,mask);shading flat;hold on
plot([x(ySW,xSW),x(yNW,xNW)],[y(ySW,xSW),y(yNW,xNW)])
% plot([x(ySW,xSW),x(yNW,xNW)],[y(ySW,xSW),y(yNW,xNW)])
% plot([xSW,xSE],[ySW,ySE])
% plot([x(ySE,xSE),x(yNE,xNE)],[y(ySE,xSE),y(yNE,xNE)])
% plot([x(yNW,xNW),x(yNE,xNE)],[y(yNW,xNW),y(yNE,xNE)])


aaa=5;



%% Find the x,y coordinates for the launch points

nSpacing = 10;          % 100 km spacing

jWest = [ySW:5:yNW];
iWest = xSW + 0*jWest;


% nWest = round( (yNW - ySW) / nSpacing ); 
% jWest = [ySW:(yNW-ySW)/nWest:yNW];
% iWest = xSW + 0*jWest;

% nNorth = round( (yNW - ySW) / 10 );
% iNorth = [xNW:(xNE-xNW)/nNorth:xNE];
% jNorth = yNW + 0*iNorth;
% 
% nEast = round( (yNE - ySE) / nSpacing ); 
% jEast = [ySE:(yNE-ySE)/nEast:yNE];
% iEast = xSE + 0*jEast;

% Eliminate dupes

% iNorth = iNorth(2:end-1);
% jNorth = jNorth(2:end-1);



fig(5);clf;pcolor(mask);shading flat;hold on

plot(iWest,jWest,'*')
% plot(iNorth,jNorth,'*')
% plot(iEast,jEast,'*')





aaa=5;

%% write the float locations to file

% Combine the launch points into single vectors

iReleaseLocs = iWest;
jReleaseLocs = jWest;

% iReleaseLocs = [iWest, iNorth, fliplr(iEast) ];
% jReleaseLocs = [jWest, jNorth, fliplr(jEast) ];

count = length(jReleaseLocs);

% All times are in days

nDays = 30;
nInterval = 1;
nReleases = nDays/nInterval;   % must be integer

nDepths = 1;
depth1 = -1;
% depth2 = -30;


% fileID = fopen( 'floatNumbersOnly.txt','w');
fileID = fopen( 'floats_niskinec.in','w');


% hmin=100;count=0
% for ii=1:length(X); for jj=1:length(Y)
%         h(Y(jj),X(ii))
%         if h(Y(jj),X(ii)) >100
%             count=count+1;
%         end;
% end;end;
% [nFloats count]


% Start writing to file


fprintf(fileID,'     Lfloats == T\n\n');
fprintf(fileID,'       FRREC == 0\n\n');

fprintf(fileID,'     NFLOATS == %10i\n\n',nReleases*count*nDepths);
% fprintf(fileID,' ');
fprintf(fileID,'POS = G, C, T, N,  Ft0,  Fx0,    Fy0,    Fz0,    Fdt,    Fdx,    Fdy,   Fdz\n');
% fprintf(fileID,' ');



% Surface floats - type 2  constant depth

for nn=1:length(iReleaseLocs);
    fprintf(fileID,'1  0  1  %4i  0.0d0 %10.3f  %10.3f  -1  %10.3f 0.d0 0.d0 0.d0\n',nReleases,iReleaseLocs(nn),jReleaseLocs(nn),nInterval);          
end;


% lower layer of floats  - type 2 constant depth
% 
% for nn=1:length(iReleaseLocs); 
%     fprintf(fileID,'1  1  2  %4i  0.0d0 %10.3f  %10.3f  -15  %9.3f 0.d0 0.d0 0.d0\n',nReleases,iReleaseLocs(nn),jReleaseLocs(nn),nInterval);
% end;




done('write')

