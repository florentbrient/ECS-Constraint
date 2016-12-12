# Constraint of ECS based on temporal variability
This routine aims to compute a posterior ECS probability distribution function weighted by how well models reproduce temporal variability

The code is written in MATLAB. In a near future, it will translate in Python

The routine needs :
- ECS values for N models
- Temporal variabilities for the same N models and for the observations
- The original temporal variability is not needed, only a statistical significant number
 of samples aiming to reproduce the uncertainty of the original temporal variability (Nb=100).
 This uncertainty can be produced by a bootstrapping procedure
- The likelihood of a model given the observations and its related weight can be computed by :
  - A log-likelihood function (use_normal=1)
  - A Kullback-Leibler measure (use_normal=0). The divergence is the relative entropy between a model's PDF
  and the observed PDF, which indicate how much information is lost if the model's PDF is used to
  approximate the observed PDF

The routine provide :
- The posterior PDF
- The weights for every model
- The likelihoods for every model


References
----------

Brient F and Schneider T (2016) Constraints on Climate Sensitivity from Space-Based Measurements of Low-Cloud Reflection. J. Clim., 29:5821–5835, DOI: 10.1175/JCLI-D-15-0897.1
Burnham K. P. and D. R. Anderson (2010) Model Selection and Multimodel Inference: A Practical Information-Theoretic Approach. 2nd ed., Springer, New York, NY.