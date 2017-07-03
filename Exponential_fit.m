function [fitresult, gof, opts] = Exponential_fit(l, S, Num_of_exp)
%CREATEFIT1(L,S)
%  Create a fit.
%
%  Data for 'Exponential_fit' fit:
%      X Input : l
%      Y Output: S
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 02-Nov-2015 15:38:46


%% Fit: 'Exponential_fit'.
[xData, yData] = prepareCurveData( l, S );

if nargin < 3
    Num_of_exp = 'exp1';
end

% Set up fittype and options.
if strcmpi(Num_of_exp,'exp1')
    ft = fittype( 'exp1' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.StartPoint = [4096774.90045829 -0.0140042100546227];
    opts.Upper = [inf 0];
elseif strcmpi(Num_of_exp,'exp2')
    % Set up fittype and options.
    ft = fittype( 'exp2' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.StartPoint = [729.408028541869 -0.00121329818315127 -19.8566782088419 -0.0134511524119246];
    opts.Upper = [inf 0 inf 0];
else
    error('Please enter a valid number of exponentials');
end

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Create a figure for the plots.
%figure( 'Name', 'Exponential_fit' );

% Plot fit with data.
%subplot( 2, 1, 1 );
%h = plot( fitresult, xData, yData );
%legend( h, 'S vs. l', 'Exponential_fit', 'Location', 'NorthEast' );
% Label axes
%xlabel l
%ylabel S
%grid on

% Plot residuals.
%subplot( 2, 1, 2 );
%h = plot( fitresult, xData, yData, 'residuals' );
%legend( h, 'Exponential_fit - residuals', 'Zero Line', 'Location', 'NorthEast' );
% Label axes
%xlabel l
%ylabel S
%grid on

