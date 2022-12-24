gridFileOrig = 'SCSAtelescope_4km.nc';

dum = nc_varget(gridFileOrig,'h');

pm = nc_varget(gridFileOrig,'pm');
pn = nc_varget(gridFileOrig,'pn');

A = 1 ./ ( pm .* pn) / (4000^2) ;


myMaxPmPn = max(pm,pn);
myMinPmPn = min(pm,pn);

fig(10);clf
imagesc( 1 ./ myMinPmPn /4000); shading flat


[ny nx] =size(dum);

% What I do here is make a 2D array of visc2 and diff2 and the other
% routine simply adds the fields to the grid file. The interior values are
% ones, and trend linearly to the edge values which are higher by a factor
% of cff, over a distance of thickness pixels.

% The defaults in ana_sponge.h seem to be

cff = 4;
thickness = 6;




%% Peg viscosity to Area

% visc_factor = 1 ./ myMinPmPn /4000;
diff_factor = 1 ./ myMinPmPn /4000; diff_factor = (diff_factor -1) *110 + 1;
visc_factor = diff_factor;

fig(1);clf;
imagesc(visc_factor);axis xy;colorbar

fig(2);clf;
imagesc(diff_factor);axis xy;colorbar

nn = round(max(diff_factor(:)) )

aaa=5;



%--------------------------------------------------------------------------
% Inquire grid NetCDF file.
%--------------------------------------------------------------------------


gridFile     = ['SCSAtelescope_4km_ViscDiff_',num2str(nn),'.nc'];

aaa=5;

unix(['cp ',gridFileOrig,' ',gridFile]);

I = nc_inq(gridFile);

got.visc = any(strcmp({I.Variables.Name}, 'visc_factor'));
got.diff = any(strcmp({I.Variables.Name}, 'diff_factor'));

if got.visc == 0
    dum.Name = 'visc_factor';
    dum.Nctype = 'float';
    dum.Dimension = {'eta_rho','xi_rho'};
    dum.Attribute = struct('Name',{'long_name'},'Value',{'sponge for viscosity'});
    nc_addvar(gridFile,dum);
    nc_varput(gridFile,'visc_factor',visc_factor);
end

if got.diff == 0
    dum.Name = 'diff_factor';
    dum.Nctype = 'float';
    dum.Dimension = {'eta_rho','xi_rho'};
    dum.Attribute = struct('Name',{'long_name'},'Value',{'sponge for diffusion'});
    nc_addvar(gridFile,dum);
    nc_varput(gridFile,'diff_factor',diff_factor);
end

