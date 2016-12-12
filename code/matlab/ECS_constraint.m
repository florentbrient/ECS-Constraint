function [ECS_pdf,w_model,log_llh]=ECS_constraint(ECS,slope,slopeobs,use_normal)
% Constraining ECS from temporal variability
%
% Bayesian Model Averaging (BMA): Using normal distribution for model
% distribution of slopes to compute likelihood of data given model
% combinations
%
% Routine could be tested by loading : datafile.mat
%
% Input : 
% ECS : Equilibirum climate sensitivity values (M models)
% slope : a MxN table (M models having N bootstrapped samples of the
% original slope) for the temporal variability
% slopeobs : a N column listeing boostrapped samples of the observed temporal variability 
% use_normal : type of likelihood (0 : Kullback-Leibler measure, 1 : normal likelihood function)
%
% Output : 
% ECS_pdf : Posterior PDF of models' ECS
% w_model : weight attributed to every model
% log_llh : likelihood of every model given the observed distribution

% ECS for each model, sort in ascending order
[ECS_model, is] = sort(ECS);     

% Reorder temporal variability of models
slopemodel      = slope(is, :);

% number of model
m              = length(ECS_model); 

% number of boostrap
b              = length(slopeobs); 

% initialize weight
log_llh        = zeros([m, 1]);

% Making plots
make_plots     = 1;

% Type of the likelihood function
if use_normal   % compute sufficient statistics for evaluation of normal likelihood function
     % means and variances of model slopes
     dadT_model_m   = mean(slopemodel);     % mean of dadT for each model
     dadT_model_var = var(slopemodel);      % variances of dadT across models    
else            % use full pdf
     % observed PDF
     [obs_pdf, xi]   = ksdensity(slopeobs);
end

% Compute the maximum likelihood for every model
for i=1:m
    if use_normal
         % normal log_likelihood 
         log_llh(i)  = -0.5*b*log(dadT_model_var(i)) ...
             - 0.5*sum((slopeobs - dadT_model_m(i)).^2)/dadT_model_var(i);
    else
         % use K-L divergence 
         model_pdf  = ksdensity(slopemodel(i, :), xi);
         log_llh(i) = -trapz(xi, obs_pdf .* log(obs_pdf./ model_pdf));
                        
         if make_plots
            figure(i);
            clf
            plot(xi, obs_pdf, 'g', xi, model_pdf, 'r')
            title(['Red : Model ',i,' ; Green : Obs',' ; llh=', num2str(log_llh(i))])
         end
    end
end

% maximum likelihood
[max_llh, ~]      = max(log_llh);
    
% normalized weights of subensembles
w  = exp(log_llh - max(log_llh));
w_model= w/sum(w);

% compute unweigthed (original) PDF 
[ECS_pdf0, x0]   = ksdensity(ECS_model);
% compute posterior PDF 
[ECS_pdf, x]   = ksdensity(ECS_model, 'weights', w_model);

% quick diagnostics: posterior mode and confidence intervals
[~, imax]  = max(ECS_pdf);
ECS_mode   = x(imax);                                            % mode of the posterior PDF
[ECS_l90, ECS_u90] = confidence_intervals(ECS_pdf, x, .9);       % 90% confidence interval
[ECS_l66, ECS_u66] = confidence_intervals(ECS_pdf, x, .66);      % 66% confidence interval
    
disp(['max_llh=', num2str(max_llh), ' : Posterior mode ', num2str(ECS_mode), ...
     ' [', num2str(ECS_l90(end)), ' (',num2str(ECS_l66(end)),'),  ',...
     ' (', num2str(ECS_u66(end)), ') ',num2str(ECS_u90(end)),']' ])

% Final figure (prior and posterior PDF of ECS)
if make_plots
   figure(i);
   clf
   plot(x0, ECS_pdf0, 'k-', x, ECS_pdf, 'k--')
   title(['Prior (-) and Posterior (--) PDF of ECS (',num2str(m),' models)'])
end
 
end


