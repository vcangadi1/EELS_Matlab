function [p, R2, adjR2, fun, back] = mlls_fit_modified(core_loss_spectrum, energy_loss_HIGH_LOSS, model_begin_channel, model_end_channel, Diff_cross_sections, Fit_Type, Optional_lowloss_spectrum)
%%

dfc = Diff_cross_sections;


% Plural scattering
if nargin == 7
    dfc = plural_scattering(dfc, Optional_lowloss_spectrum);
end

% high loss energy-loss axis
l = energy_loss_HIGH_LOSS;

% High loss spectrum
S = core_loss_spectrum;

%% Get Residue of the spectrum
% model background with exponential function
b = model_begin_channel;
e = model_end_channel;
if e-b+1 > 100 && b < length(l)*0.25
    back = feval(Power_law(l(b:e),S(b:e)),l);
else
    back = feval(Exponential_fit(l(b:e),S(b:e)),l);
end

%%

switch Fit_Type
    case {'A','a'}
        %% A). Fit Residue spectrum with dfc, baseline
        
        rS = S - back;
        
        %% define lb, ub, p0 for lsqcurvefit
        
        %lb = [ones(1,size(dfc,2)) * -1000, -10, 0];
        %ub = [ones(1,size(dfc,2)) * 1E4, 10, 1E4];
        %p0 = [ones(1,size(dfc,2)) * 30, 1, 1];
        lb = [ones(1,size(dfc,2)) * -1000];
        ub = [ones(1,size(dfc,2)) * 1E4];
        p0 = [ones(1,size(dfc,2)) * 30];
        
        %% fit background
        tic;
        %fun = @(p,l) ([p(1),p(1)+p(2),p(1)+p(2)+p(3)] * dfc')';
        %fun = @(p,l) [dfc,l,ones(length(l),1)] * p';
        fun = @(p,l) dfc * p';
        options = optimoptions(@lsqcurvefit,'display','none');
        p = lsqcurvefit(fun,p0,l,rS,lb,ub,options);
        [R2,adjR2] = rsquare(rS, fun(p,l),size(dfc,2)+1);
        toc;
        
        %% Redefine simpler function
        %fun = @(p) [dfc,l,ones(length(l),1)] * p';
        fun = @(p) dfc * p';
        
        %% display
        %disp(p);
        %disp(R2);
        %figure;
        %plotEELS(l,rS)
        %plotEELS(l,fun(p,l))
        %}
        
        %%
        
    case {'B','b'}
        %% B). Fit Spectrum with back, dfc
        
        %% define lb, ub, p0 for lsqcurvefit
        
        lb = [-10, ones(1,size(dfc,2)) * -1000];
        ub = [ones(1,size(dfc,2)+1) * 1E4];
        p0 = [ones(1,size(dfc,2)+1) * 30];
        
        %% fit background
        tic;
        %fun = @(p,l) ([p(1),p(1)+p(2),p(1)+p(2)+p(3)] * dfc')';
        fun = @(p,l) [back,dfc] * p';
        options = optimoptions(@lsqcurvefit,'display','none');
        p = lsqcurvefit(fun,p0,l,S,lb,ub,options);
        [R2,adjR2] = rsquare(S, fun(p,l),size(dfc,2)+1);
        toc;
        
        %% Redefine simpler function
        fun = @(p) [back,dfc] * p';
        
        %% display
        %disp(p);
        %disp(R2);
        %figure;
        %plotEELS(l,rS)
        %plotEELS(l,fun(p,l))
        %}
        
        
        %%
        
    case {'C','c'}
        %% C). Fit Spectrum with back,dfc,baseline
        
        %% define lb, ub, p0 for lsqcurvefit
        
        lb = [ones(1,size(dfc,2)+1) * -1000, -1000, -1E10];
        ub = [ones(1,size(dfc,2)+1) * 1E4, 1000, 1E10];
        p0 = [1,ones(1,size(dfc,2)) * 30, 0, 0];
        
        %% fit background
        tic;
        %fun = @(p,l) ([p(1),p(1)+p(2),p(1)+p(2)+p(3)] * dfc')';
        fun = @(p,l) [back,dfc,l,ones(length(l),1)] * p';
        options = optimoptions(@lsqcurvefit,'display','none');
        p = lsqcurvefit(fun,p0,l,S,lb,ub,options);
        [R2,adjR2] = rsquare(S, fun(p,l),size(dfc,2)+2);
        toc;
        
        %% Redefine simpler function
        fun = @(p) [back,dfc,l,ones(length(l),1)] * p';
        %}
        
        %%
        
    case {'D','d'}
        %% D). Fit Spectrum with back,dfc,baseline
        
        %% define lb, ub, p0 for lsqcurvefit
        
        lb = [ones(1,size(dfc,2)+2) * -1000, -1000, -1E10];
        ub = [ones(1,size(dfc,2)+2) * 1E4, 1000, 1E10];
        p0 = [1,1,ones(1,size(dfc,2)) * 30, 0, 0];
        
        %% fit background
        tic;
        %fun = @(p,l) ([p(1),p(1)+p(2),p(1)+p(2)+p(3)] * dfc')';
        fun = @(p,l) [back.*l.^p(1),dfc,l,ones(length(l),1)] * p(2:7)';
        options = optimoptions(@lsqcurvefit,'display','none');
        p = lsqcurvefit(fun,p0,l,S,lb,ub,options);
        [R2,adjR2] = rsquare(S, fun(p,l),size(dfc,2)+3);
        toc;
        
        %% Redefine simpler function
        fun = @(p) [back.*l.^p(1),dfc,l,ones(length(l),1)] * p(2:7)';
       
        %
    case {'E','e'}
        %% E). Fit Spectrum with back,dfc,baseline
        
        %% define lb, ub, p0 for lsqcurvefit
        
        lb = [ones(1,size(dfc,2)+2) * -1000, -1000, -1E10];
        ub = [ones(1,size(dfc,2)+2) * 1E4, 1000, 1E10];
        p0 = [1,1,ones(1,size(dfc,2)) * 30, 0, 0];
        
        %% fit background
        tic;
        %fun = @(p,l) ([p(1),p(1)+p(2),p(1)+p(2)+p(3)] * dfc')';
        fun = @(p,l) [back.^p(1),dfc,l,ones(length(l),1)] * p(2:7)';
        options = optimoptions(@lsqcurvefit,'display','none');
        p = lsqcurvefit(fun,p0,l,S,lb,ub,options);
        [R2,adjR2] = rsquare(S, fun(p,l),size(dfc,2)+3);
        toc;
        
        %% Redefine simpler function
        fun = @(p) [back.^p(1),dfc,l,ones(length(l),1)] * p(2:7)';
        
end