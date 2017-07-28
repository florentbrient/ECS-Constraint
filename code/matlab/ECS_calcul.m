% Constraining ECS from temporal variability

% Load files
pathdata = '../../data/';
filename = [pathdata,'datafile.mat'];
load(filename);

% use_normal :type of likelihood 
% 0 : Kullback-Leibler measure
% 1 : normal likelihood function
use_normal = 0;

% Calculate constraints
[ECS_pdf,w_model,log_llh]=ECS_constraint(ECS,Namemodels,slope,slopeobs,use_normal)