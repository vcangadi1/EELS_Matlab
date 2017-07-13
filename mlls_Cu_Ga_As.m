clc
clear all

%% Load SI of high loss and low loss

EELS = load('C:\Users\elp13va.VIE\Desktop\EELS data\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp1offset950time2s.mat');
EELS = EELS.EELS;
l = EELS.energy_loss_axis';

EELZ = load('C:\Users\elp13va.VIE\Desktop\EELS data\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp0.2offset0time0.1s.mat');
EELZ = EELZ.EELS;

%% Load differential cross sections

dfcCu = diffCS_L23(29,928,197,16.6,l);
dfcGa = diffCS_L23(31,1120,197,16.6,l);
dfcAs = diffCS_L23(33,1325,197,16.6,l);

%dc = [dfcCu, dfcGa, dfcAs];

%% define lb, ub, p0 for lsqcurvefit
lb = [0,0,0];
ub = [1E10,1E10,1E10];

p0 = [300,300,300];

%% fit background

for ii = 90:-1:1
    for jj = 43:-1:1
        fprintf('Fitting (%d,%d)\n',ii,jj);
        S = squeeze(EELS.SImage(ii,jj,:));
        % smooth spectrum with spline function
        S = feval(Spline(l,S),l);
        Sm(ii,jj,1:EELS.SI_z) = S;
        % correct dispersion
        Z = resample(squeeze(EELZ.SImage(ii,jj,:)),1,5);        
        % plural scatter differential cross-section
        pdfcCu = plural_scattering(dfcCu, Z);
        pdfcGa = plural_scattering(dfcGa, Z);
        pdfcAs = plural_scattering(dfcAs, Z);
        % model background with exponential function
        B(ii,jj,1:EELS.SI_z) = S - feval(Exponential_fit(l(1:63),S(1:63)),l);
        rS = squeeze(B(ii,jj,:));
        fun = @(p,l) p(1)*pdfcCu + (p(2)+p(1))*pdfcGa + (p(3)+p(2)+p(1))*pdfcAs;
        p = lsqcurvefit(fun,p0,l,rS,lb,ub);
        %A(ii,jj) = p(1);
        %r(ii,jj) = p(2);
        Cu(ii,jj) = p(1);
        Ga(ii,jj) = p(2);
        As(ii,jj) = p(3);
        R2(ii,jj) = rsquare(rS, p(1)*pdfcCu + (p(2)+p(1))*pdfcGa + (p(3)+p(2)+p(1))*pdfcAs);
    end
end

EELB = EELS;
EELB.SImage = B;

plotEELS(EELB)