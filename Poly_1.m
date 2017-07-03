function [fitresult, gof] = Poly_1(energy_loss, Spectrum)
%CREATEFIT1(energy_loss,Spectrum)
%  Create a fit.
%
%  Data for 'Poly_1' fit:
%      X Input : energy_loss
%      Y Output: Spectrum
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 17-Sep-2015 13:12:14


%% Fit: 'Poly_1'.
[xData, yData] = prepareCurveData( energy_loss, Spectrum );

% Set up fittype and options.
ft = fittype( 'poly1' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

% Plot fit with data.
%figure( 'Name', 'Poly_1' );
%h = plot( fitresult, xData, yData );
%legend( h, 'Spectrum vs. energy_loss', 'Poly_1', 'Location', 'NorthEast' );
% Label axes
%xlabel energy_loss
%ylabel Spectrum
%grid on