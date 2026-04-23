Supplementary information to
Linking molecular responses to organismal outcomes under complex contaminant stress: a systems biology approach for predictive ecotoxicology

Louise M Stevenson, Andre Gergs, Lea Rahlfes, Ferdinand Pfab, Paul C. Pickhardt, Teresa J Mathews, Natàlia Garcia‐Reyero, Cheryl A Murphy, Roger M Nisbet, Philipp Antczak


1) Set up Matlab and DEBtool
Running the model in Matlab requires DEBtool, the Matlab function library for Dynamic Energy Budget (DEB) theory.
Download DEBtool from: https://github.com/add-my-pet/DEBtool_M
After downloading, unzip the package and add the DEBtool folders to the Matlab path.

2) Required Model Files
The following files are needed to run the Daphnia magna model:
run_Daphnia_magna.m
mydata_Daphnia_magna.m
pars_init_Daphnia_magna.m
predict_Daphnia_magna.m

Files were modified from Bas Kooijman, Andre Gergs. 2023. AmP Daphnia magna, version 2023/03/29 https://www.bio.vu.nl/thb/deb/deblab/add_my_pet/entries_web/Daphnia_magna/Daphnia_magna_res.html

Further documentation is available here: https://debportal.debtheory.org/docs/AmPeps.html

3) Running Model Simulations
Execute the script run_Daphnia_magna.m to run the model and generate simulations.


4) Testing Different Physiological Modes of Action (pMoAs)
To test alternative pMoAs:
Comment or uncomment the respective code sections in predict_Daphnia_magna.m (lines 236–263).
Ensure consistent parameterization by commenting/uncommenting the corresponding parameter blocks in pars_init_Daphnia_magna.m (lines 32–76).


5) Parameter Re-estimation
For re-estimating model parameters, follow the workflow described at:
https://debportal.debtheory.org/docs/AmPestimation.html