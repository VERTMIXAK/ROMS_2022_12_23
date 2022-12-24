clear;

% The idea here is to take an existing grid and wrap a telescoping layer
% around the outside. 
%   /import/c1/VERTMIX/jgpender/roms-kate_svn/BARROW_2km/InputFiles/Gridpak


% The corners for the original BARROW_2km grid are:
p1=[-342610.029319732,-1648500.33989288]
p2=[-393703.375,-2226245.5]
p3=[295606.36774849,-2287205.14691508]
p4=[346699.713428757,-1709459.98680796]

% This grid is rotated a bit, so the edges aren't along x or y grid lines.
% Figure out what the rotation angle is.

th = atan( (p3(2)-p2(2)) / (p3(1)-p2(1))  ) 

Rmat = [cos(th) -sin(th);sin(th) cos(th)];
unRotatemat = [cos(th) sin(th);-sin(th) cos(th)];

P1=p1*Rmat
P2=p2*Rmat
P3=p3*Rmat
P4=p4*Rmat



xmin = -196058.4285;
xmax =  495942.5715;
ymin = -2252273.7336;
ymax = -1672272.7336;

xmin = (P1(1)+P2(1) ) /2
xmax = (P3(1)+P4(1) ) /2
ymin = (P2(2)+P3(2) ) /2
ymax = (P1(2)+P4(2) ) /2


aaa=5;

%% Define the telescoping

% The original grid is a very even 2km. Telescope out to 6km intervals over a
% distance of about 173km. Keep fiddling with myStretch until the
% accumulated distance is about right.

minInterval = .5;
% maxInterval = 2;
% myStretch = 0;
% seed = cumsum(1000*[minInterval+myStretch:myStretch:maxInterval])

% Game the numbers to match the corners for BARROWtelescope_2km
seed = cumsum(500*ones(1,328))


lhsX = xmin - fliplr(seed);
rhsX = xmax +        seed;

botY = ymin - fliplr(seed);
topY = ymax +        seed;

newX = [lhsX xmin:1000*minInterval:xmax];
newY = [botY ymin:1000*minInterval:ymax];
% newX = [lhsX xmin:1000*minInterval:xmax rhsX];
% newY = [botY ymin:1000*minInterval:ymax topY];



fig(1);plot(newX);title('newX')
fig(2);plot(newY);title('newY')



%% Create the coast.in file - i.e. generate the x,y pairs around the perimeter

% the data write begins in the upper left corner, runs counterclockwise
% until you get back (almost) to the starting point.

% Remember that you ARE supposed to duplicate the corners!!


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

aaa=5;

%%
% 
% fig(10);clf;
% plot(dumWest(:,2),dumWest(:,1),'*');hold on
% plot(dumSouth(:,2),dumSouth(:,1),'*')
% plot(dumEast(:,2),dumEast(:,1),'*')
% plot(dumNorth(:,2),dumNorth(:,1),'*')

fig(11);clf;
plot(dumWest(:,1),dumWest(:,2),'*');hold on
plot(dumSouth(:,1),dumSouth(:,2),'*')
plot(dumEast(:,1),dumEast(:,2),'*')
plot(dumNorth(:,1),dumNorth(:,2),'*')


aaa=5;


%% Now rotate the grid of points to match BARROW_2km

[index ~] = size(dumWest);
for ii=1:index
    dumWest(ii,:) = dumWest(ii,:) * unRotatemat;
end

[index ~] = size(dumSouth);
for ii=1:index
    dumSouth(ii,:) = dumSouth(ii,:) * unRotatemat;
end

[index ~] = size(dumEast);
for ii=1:index
    dumEast(ii,:) = dumEast(ii,:) * unRotatemat;
end

[index ~] = size(dumNorth);
for ii=1:index
    dumNorth(ii,:) = dumNorth(ii,:) * unRotatemat;
end


% fig(20);clf;
% plot(dumWest(:,2),dumWest(:,1),'*');hold on
% plot(dumSouth(:,2),dumSouth(:,1),'*')
% plot(dumEast(:,2),dumEast(:,1),'*')
% plot(dumNorth(:,2),dumNorth(:,1),'*')

fig(21);clf;
plot(dumWest(:,1),dumWest(:,2),'*');hold on
plot(dumSouth(:,1),dumSouth(:,2),'*')
plot(dumEast(:,1),dumEast(:,2),'*')
plot(dumNorth(:,1),dumNorth(:,2),'*')


aaa=5;

%%

% coast = vertcat(dumWest,dumSouth,dumEast,dumNorth);

['Include/gridparam.h:  Lm=',num2str(nx-1),'   Mm=',num2str(ny-1)]

% save('coast.in','coast','-ascii')


%% Create the sqgrid.in file

% Note that I can skip the fort2sq.bash script. What this does is convert
% lat/lon to x/y, but I've already got x/y for this grid.

save('west.in','dumWest','-ascii');
save('east.in','dumEast','-ascii');
save('north.in','dumNorth','-ascii');
save('south.in','dumSouth','-ascii');

unix(['echo "',num2str(ny),' " > sqgrid.in']);
% unix(['echo "',num2str(ny-1),' " > sqgrid.in']);
unix(['cat west.in >> sqgrid.in']);

unix(['echo "',num2str(nx),' " >> sqgrid.in']);
% unix(['echo "',num2str(ny-1),' " > sqgrid.in']);
unix(['cat south.in >> sqgrid.in']);

unix(['echo "',num2str(ny),' " >> sqgrid.in']);
% unix(['echo "',num2str(ny-1),' " >> sqgrid.in']);
unix(['cat east.in >> sqgrid.in']);

unix(['echo "',num2str(nx),' " >> sqgrid.in']);
% unix(['echo "',num2str(nx-1),' " >> sqgrid.in']);
unix(['cat north.in >> sqgrid.in']);


