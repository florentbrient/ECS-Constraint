# ECS-Constraint
Calcul of a posterior ECS probability distribution function weighted by how well models reproduce temporal variability

The code originated from Brient and Schneider (16). 
A preprocessing averaging (https://github.com/florentbrient/Cloud-variability-time-frequency) is used to identify temporal variability of monthly-mean variations over tropical low-cloud (TLC) regions.

## Preprocessing
### Input
| Frequency | Variable | CMOR labels | Unit | File Format |
|:----------|:-----------------------------|:-------------|:--------|:------------|
| monthly mean | Relative humidity profile  | hur     |  -    | nc
| monthly mean | Sea surface temperature  | ts     |  K    | nc
|  | TOA outgoing shortwave flux at the top-of-the-atmosphere  | rsut     |  Wm-2    | nc
|  | Clear-sky outgoing shortwave flux at the top-of-the-atmosphere  | rsutcs     |  Wm-2    | nc

We identified TLC regions as the 25% of the tropical ocean area (30°N–30°S) with the lowest midtropospheric (500 hPa) relative humidity. 
Monthly time series of surface temperature (sst) and cloud albedo (albcld, i.e. the difference between rsutcs-rsut) are created over these TLC regions, for both observations and models.

We averaged over the same equal-area grid with 240x121 cells globally for relevant inter-model and model-to-observations comparisons.

We compute the co-variations between low-cloud albedo and surface temperature for observations, along with uncertainties computed with a bootstrapping framework.

See https://github.com/florentbrient/Cloud-variability-time-frequency for more details about the preprocessing.

### Output
Outputs of this preprocessing are listed in "datafile.mat", including co-variations between SST and cloud albedo for the observations and 29 CMIP5 models. 
Values of Equilibrium climate sensitivity (ECS) for these 29 models are also listed in the file.

## Diagnostic calculation
### Definition
- The original temporal variability is not needed. We use a statistical significant number
 of randomly-created samples aiming to reproduce the uncertainty of the original temporal variability (Nb samples).
 This uncertainty are produced by a bootstrapping procedure.
- The likelihood of a model given the observations and its related weight can be computed by :
  - A Kullback-Leibler measure (use_normal=0, by default). The divergence is the relative entropy between a model's PDF
  and the observed PDF, which indicate how much information is lost if the model's PDF is used to
  approximate the observed PDF
  - A log-likelihood function (use_normal=1)
- The routine to call in named "ECS_calcul.mat"
  
### Input
The original code makes use of the output data from the preprocessing analysis. 
These data are listed in "datafile.mat" for :
 - Observations ('slope') : Uncertainty of the original slopes are created through 200 bootstrap samples of the TLC temporal variations (183 months from March 2000 through May 2015).
 - CMIP models ('slopeobs') : Unertainties of the model slopes are created through 3*200 bootstrap samples of the TLC temporal variations (based on 3 time periods of 183 months-long from 1959 to 2005).
 
Inputs listed in "datafile.mat" are those used in Brient and Schneider (16).


### Output
  - Data
    - The routine diagnoses the prior and posterior ECS modes and 66% and 90% confidence intervals
    - This diagnostics is written in "ECS_prior.txt" and "ECS_posterior.txt", available in https://github.com/florentbrient/ECS-Constraint/tree/master/data/

  - Figures
    - The code creates some figures, all of which are available at https://github.com/florentbrient/ECS-Constraint/tree/master/figures:
      - The prior ECS probability density estimate for observations and each model are named "Prior_posterior_PDF_(model).png"
      - The prior and posterior ECS probability density estimate is "Posterior_ECS_29models.png"

## One supplementary routine :
- confidence_intervals.mat : Compute 66% and 90% confidence intervals 

## Remarks
- The code should be rewritten in Python for consistency with the preprocessing.


References
----------
Brient F and Schneider T (2016) Constraints on Climate Sensitivity from Space-Based Measurements of Low-Cloud Reflection. J. Clim., 29:5821–5835, DOI: 10.1175/JCLI-D-15-0897.1
