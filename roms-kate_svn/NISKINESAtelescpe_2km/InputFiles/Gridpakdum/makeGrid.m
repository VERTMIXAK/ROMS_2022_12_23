clear;

% The idea here is to take an existing gr/import/c1/VERTMIX/jgpender/roms-kate_svn/NISKINESA_2km/InputFiles/Gridpakid and wrap a telescoping layer
% around the outside. 
%       /import/c1/VERTMIX/jgpender/roms-kate_svn/NISKINESA_2km/InputFiles/Gridpak

% Don't even worry about lat and lon because this is a conic projection and
% the latitude and longitude lines are all skew.

Lm = 99;
Mm = 125;

xmin = -99000;
xmax =  99000;
ymin = -4124000;
ymax = -3874000;

%% Define the telescoping

% The original grid is a very even 2km. Telescope out to 6km 

lhsX = xmin - fliplr(cumsum(1000*[3 4 5 6]));
rhsX = xmax + cumsum(1000*[3 4 5 6]);

botY = ymin - fliplr(cumsum(1000*[3 4 5 6]));
topY = ymax + cumsum(1000*[3 4 5 6]);

newX = [lhsX xmin:2000:xmax rhsX];
newY = [botY ymin:2000:ymax topY];

fig(1);plot(newX)
fig(2);plot(newY)



%% Create the coast.in file

% the data write begins in the upper left corner, runs counterclockwise
% until you get back (almost) to the starting point.

% Remember that you're not supposed to duplicate the corners!!


nx=length(newX); ny=length(newY);

dumWest = zeros(ny,2);
dumWest(:,2) = fliplr(newY(1:end));
dumWest(:,1) = newX(1);

dumSouth = zeros(nx,2);
dumSouth(:,2) = newY(1);
dumSouth(:,1) = newX(1:end);

dumEast = zeros(ny,2);
dumEast(:,2) = newY(1:end);
dumEast(:,1) = newX(end);

dumNorth = zeros(nx,2);
dumNorth(:,2) = newY(end);
dumNorth(:,1) = fliplr(newX(1:end));


%%

fig(10);clf;
plot(dumWest(:,2),dumWest(:,1),'*');hold on
plot(dumSouth(:,2),dumSouth(:,1),'*')
plot(dumEast(:,2),dumEast(:,1),'*')
plot(dumNorth(:,2),dumNorth(:,1),'*')

%%

% coast = vertcat(dumWest,dumSouth,dumEast,dumNorth);

['Include/gridparam.h:  Lm=',num2str(nx-1),'   Mm=',num2str(ny-1)]

% save('coast.in','coast','-ascii')


%% Create the sqgrid.in file

% Note that I can skip the fort2sq.bash script. What this does is convert
% lat/lon to x/y, but I've already got x/y for this grid.

save('west.in','dumWest','-ascii')
save('east.in','dumEast','-ascii')
save('north.in','dumNorth','-ascii')
save('south.in','dumSouth','-ascii')

unix(['echo "',num2str(ny),' " > sqgrid.in']);
unix(['cat west.in >> sqgrid.in']);

unix(['echo "',num2str(nx),' " >> sqgrid.in']);
unix(['cat south.in >> sqgrid.in']);

unix(['echo "',num2str(ny),' " >> sqgrid.in']);
unix(['cat east.in >> sqgrid.in']);

unix(['echo "',num2str(nx),' " >> sqgrid.in']);
unix(['cat north.in >> sqgrid.in']);




