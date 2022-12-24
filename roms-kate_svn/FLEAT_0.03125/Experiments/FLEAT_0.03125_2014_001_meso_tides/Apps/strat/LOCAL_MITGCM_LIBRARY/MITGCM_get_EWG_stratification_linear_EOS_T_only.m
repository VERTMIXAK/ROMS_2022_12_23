function MODEL=MITGCM_get_mode_1_OBCs(MODEL)
EWG=load('/import/c/w/jpender/dataDir/levitus_ewg');
%%

% z-grid
% Nominal depth of model (meters)

% Density (Temperature)
clear N2* p*
%%
%keyboard
 idx = nearest(EWG.lon,MODEL.lon_strat);
 jdx = nearest(EWG.lat,MODEL.lat_strat);

S = sq(EWG.S(1,:,jdx-1:jdx+1,idx-1:idx+1));
T = sq(EWG.T(1,:,jdx-1:jdx+1,idx-1:idx+1));
P = sw_pres(EWG.z,MODEL.reflat)';
Pmax = sw_pres(MODEL.H_max,MODEL.reflat)

S=lowpass(sq(mean(mean(S,2),3)),1);
T=lowpass(sq(mean(mean(T,2),3)),1);
sig0ewg = sw_pden(S,T,P',0);Pi=linspace(P(1),P(end),500);
sig0ewgi=interp1(P,sig0ewg,Pi);
[N2ewg,~,p_ave]=sw_bfrq(S ,T ,sw_pres(EWG.z,MODEL.reflat),MODEL.reflat);

x=p_ave;y = lowpass(log10(N2ewg),1);p=polyfit(x,y,2); % fit a second order poly to the log of stratification
% orig N2_fit = 10.^(p(3)+p(2)*x+p(1)*x.^2); N2_fit=N2_fit-min(N2_fit)+10^-6.5;%shift minimum to 10e-6
x2=[x;Pmax];N2_fit2 = 10.^(p(3)+p(2)*x2+p(1)*x2.^2);

%N2_fit2=N2_fit2-min(N2_fit2)+10^-6.5;%shift minimum to 10e-6
N2_fit2=N2_fit2-min(N2_fit2)+MODEL.N2_min;


%N2 = interp1(p_ave,N2_fit,sw_pres(MODEL.Z,MODEL.reflat)); N2(1)=N2(2);N2(end)=N2(end-1);
N2 = interp1(x2,N2_fit2   ,sw_pres(MODEL.Z,MODEL.reflat)); %N2(1)=N2(2);N2(end)=N2(end-1);

%JGP add cheat
N2(1)=N2(2);


% plot the original buoyancy
% fig(10);clf;plot(x,N2ewg);title('N2ewg')
% fig(11);clf;plot(x,y);title('lowpass(log10(N2ewg),1)')
% fig(12);clf;plot(x2,N2_fit2);title('extrapolated N2')

%% JGP make mods
blah=5;

N2ewg_JGP = N2ewg;
N2ewg_JGP(N2ewg_JGP<MODEL.N2_min )=MODEL.N2_min;
yJGP=lowpass(log10(N2ewg_JGP),1);


x2JGP=[x', [6000:500:MODEL.H_max]]';
y2JGP = [yJGP', log10(MODEL.N2_min)*ones(1,length(x2JGP)-length(yJGP))]';

fig(21);clf;plot(x2JGP,y2JGP);title('lowpass(log10(N2ewg),1)')


% pJGP=polyfit(x2JGP,y2JGP,2); % fit a second order poly to the log of stratification
% % orig N2_fit = 10.^(p(3)+p(2)*x+p(1)*x.^2); N2_fit=N2_fit-min(N2_fit)+10^-6.5;%shift minimum to 10e-6
% N2_fit2_JGP = 10.^(pJGP(3)+pJGP(2)*x2JGP+pJGP(1)*x2JGP.^2);
% fig(22);clf;plot(x2JGP,N2_fit2_JGP);title('N2.fit2.JGP second order')

% %N2_fit2=N2_fit2-min(N2_fit2)+10^-6.5;%shift minimum to 10e-6
% N2_fit2=N2_fit2-min(N2_fit2)+MODEL.N2_min;

% pJGP=polyfit(x2JGP,y2JGP,3); % fit a third order poly to the log of stratification
% % orig N2_fit = 10.^(p(3)+p(2)*x+p(1)*x.^2); N2_fit=N2_fit-min(N2_fit)+10^-6.5;%shift minimum to 10e-6
% N2_fit2_JGP = 10.^(pJGP(4)+pJGP(3)*x2JGP+pJGP(2)*x2JGP.^2+pJGP(1)*x2JGP.^3);
% fig(23);clf;plot(x2JGP,N2_fit2_JGP);title('N2.fit2.JGP third order')

pJGP=polyfit(x2JGP,y2JGP,5); % fit a fifth order poly to the log of stratification
N2_fit2_JGP = 10.^(pJGP(6)+pJGP(5)*x2JGP+pJGP(4)*x2JGP.^2+pJGP(3)*x2JGP.^3+pJGP(2)*x2JGP.^4+pJGP(1)*x2JGP.^5);
% fig(23);clf;plot(x2JGP,N2_fit2_JGP);title('N2.fit2.JGP fifth order')


fig(24);clf; plot(x2JGP,y2JGP);hold on
plot(x2JGP,log10(N2_fit2_JGP),'r');title('log10(N2.ewg) vs log10(N2.fit) fifth order')

fig(25);clf; plot(x2JGP,10.^(y2JGP));hold on;
plot(x2JGP,N2_fit2_JGP,'r');title('N2.ewg vs N2.fit fifth order')
%% Insert new N2_fit2

% %N2_fit2=N2_fit2-min(N2_fit2)+10^-6.5;%shift minimum to 10e-6
% N2_fit2=N2_fit2-min(N2_fit2)+MODEL.N2_min;

N2_fit2=N2_fit2_JGP;
x2=x2JGP;

%N2 = interp1(p_ave,N2_fit,sw_pres(MODEL.Z,MODEL.reflat)); N2(1)=N2(2);N2(end)=N2(end-1);
N2 = interp1(x2,N2_fit2   ,sw_pres(MODEL.Z,MODEL.reflat)); %N2(1)=N2(2);N2(end)=N2(end-1);

%JGP add cheat
N2(1)=N2(2);


%%
dT = MODEL.delZ.*N2/9.8/MODEL.alphaT;
Tnew = -cumsum([dT]);
% rescale because fit is not quite right
scale = [T(end)-T(1)]/Tnew(end);
MODEL.Tref=scale*Tnew+T(1);
MODEL.N2=N2;

fig(30);clf;plot(MODEL.Z,MODEL.Tref);title('Tref')
%%
%keyboard
return
%%
% find best exponential to describe density that matches bottom and upper 200m using simple search
bs = 100:10:2000;cmap=jet(length(bs));stds=[];
surfidx=find(Pi<=100);
sigbot = sig0ewgi(end);sigsurf=mean(sig0ewg(surfidx));
for bdx = 1:length(bs)
	stds(bdx) = rms(sig0ewgi'-(sigbot-(sigbot-sigsurf)*exp(-Pi'/bs(bdx))));
end
b = bs(find(stds==min(stds)));
sigfit = sigbot-(sigbot-sigsurf)*exp(-Pi'/b);
figure(200);clf
plot(sig0ewgi,Pi,'k');axis ij;hold on
plot(sigfit,Pi);axis ij;hold on
N2_fit2 = interp1(sw_dpth(Pi',MODEL.reflat),(9.8/1030)*gradient(sigfit)./gradient(Pi'),sw_pres(MODEL.Z,MODEL.reflat));
N2_fit2=N2_fit2-N2_fit2(end)+10.^-6.5;
%%
