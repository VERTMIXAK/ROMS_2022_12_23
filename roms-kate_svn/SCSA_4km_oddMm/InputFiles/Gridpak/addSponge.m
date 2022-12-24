gridFileOrig = 'SCSA_4km.nc_noSponge';
gridFile     = 'SCSA_4km_ViscDiff_4.nc';

unix(['cp ',gridFileOrig,' ',gridFile]);

dum = nc_varget(gridFile,'h');
[ny nx] =size(dum);

% What I do here is make a 2D array of visc2 and diff2 and the other
% routine simply adds the fields to the grid file. The interior values are
% ones, and trend linearly to the edge values which are higher by a factor
% of cff, over a distance of thickness pixels.

% The defaults in ana_sponge.h seem to be

cff = 4;
thickness = 6;


%%

ramp = [1:(cff-1)/thickness:cff];


vec1 = [fliplr(ramp) ones(1,nx - 2 - 2*thickness) ramp];
vec2 = [fliplr(ramp) ones(1,ny - 2 - 2*thickness) ramp];

mat1 = zeros(ny,nx); mat2 = mat1;

for jj=1:ny
    mat1(jj,:) = vec1;
end

for ii=1:nx
    mat2(:,ii) = vec2;
end

% fig(1);clf;
% pcolor(mat1);shading flat;colorbar

% fig(2);clf;
% pcolor(mat2);shading flat;colorbar

visc_factor = 0*mat1;
for ii=1:nx; for jj=1:ny
    visc_factor(jj,ii) = max(mat1(jj,ii),mat2(jj,ii));
    end;end

diff_factor = 1 + 0*visc_factor;

fig(3);clf;
pcolor(visc_factor);shading flat;colorbar

aaa=5;


%% Update the grid file

%
% ADD_SPONGE:  Adds sponge data to a ROMS Grid NetCDF file
%
% add_sponge(gridFile, visc_factor, diff_factor)
%
% Adds enhanced viscosity and diffusion scaling variables (visc_factor
% and diff_factor) to an existing ROMS Grid NetCDF file.  These scales
% are used in an application to set sponge areas with larger horizontal
% mixing coefficients for the damping of high frequency noise coming
% from open boundary conditions or nesting.  In ROMS, these scales are
% used as follows:
%
%    visc2_r(i,j) = visc2_r(i,j) * visc_factor(i,j)
%    visc4_r(i,j) = visc4_r(i,j) * visc_factor(i,j)
%
%    diff2(i,j,itrc) = diff2(i,j,itrc) * diff_factor(i,j)
%    diff4(i,j,itrc) = diff4(i,j,itrc) * diff_factor(i,j)
%
% where the variables 'visc_factor' and 'diff_factor' are defined at
% RHO-points.  Usually, sponges are linearly tapered over several grid
% points adjacent to the open boundaries.  Its positive values linearly
% increase from the inner to outer edges of the sponge. At the interior
% of the grid we can values of zero (no mixing) or one (regular mixing).
%
% NOTICE that it is more advantageous to specify these scaling factors
% in the ROMS Grid that coding it inside ROMS.  We can plot and adjust
% their values in an easy way in Matlab.
%
% On Input:
%
%    gridFile        GRID NetCDF file name (string)
%    visc_factor   Viscosity factor (2D array; nondimensional, positive)
%    diff_factor   Diffusivity factor (2D array; nondimensional, positive)
%

% svn $Id$
%=========================================================================%
%  Copyright (c) 2002-2020 The ROMS/TOMS Group                            %
%    Licensed under a MIT/X style license                                 %
%    See License_ROMS.txt                           Hernan G. Arango      %
%=========================================================================%

%--------------------------------------------------------------------------
% Inquire grid NetCDF file.
%--------------------------------------------------------------------------

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

