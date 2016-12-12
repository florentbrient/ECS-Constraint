function [ ci_l, ci_u ] = confidence_intervals(dpdf, x, clevels)
%CONFIDENCE_INTERVALS Confidence intervals from given pdf
%   [ci_l, ci_u] = confidence_intervals(dpdf, clevels) calculates the lower
%   bounds ci_l and upper bounds ci_u for the confidence intervals with
%   confidence levels clevels (clevels can be a vector). Inputs are a
%   discrete pdf (dpdf) given at points x.

dcdf           = cumtrapz(x, dpdf);

% posterior confidence intervals
lc             = (1-clevels)./2;     % lower bound probabilities
uc             = lc + clevels;       % upper bound probabilities
ci_l           = interp1(dcdf, x, lc, 'pchip');
ci_u           = interp1(dcdf, x, uc, 'pchip');

end

