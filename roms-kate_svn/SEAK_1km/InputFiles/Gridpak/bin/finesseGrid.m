sourceFile = 'SEAK_1km.nc_preFinesse';

newGridFile = 'SEAK_1km.nc';

unix(['cp ',sourceFile,' ',newGridFile])

h = nc_varget(newGridFile,'h');

%% iteration 1

ii=176;jj=50;
jvec = [jj-3:jj+3];
ivec = [ii-3:ii+3];
flipud(round(h(jvec,ivec)))

fig(1);
imagesc(ivec,jvec,sq(h(jvec,ivec)));axis xy;colorbar;title('h');caxis([0 400])

h(jj,ii) = 100.;
h(jj,ii-1) = 350.;
h(jj+1,ii-1) = 350.;

fig(2);
imagesc(ivec,jvec,sq(h(jvec,ivec)));axis xy;colorbar;title('h');caxis([0 400])

367
%% write to file

nc_varput(newGridFile,'h',h);
