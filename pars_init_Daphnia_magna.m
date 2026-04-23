function [par, metaPar, txtPar] = pars_init_Daphnia_magna(metaData)

metaPar.model = 'std'; 

%% core primary parameters 
par.z = 0.1516;        free.z     = 0;      units.z = '-';          label.z = 'zoom factor for female'; 
par.F_m = 30.17;       free.F_m   = 0;      units.F_m = 'l/d.cm^2'; label.F_m = '{F_m}, max spec searching rate'; 
par.kap_X = 0.9;       free.kap_X = 0;      units.kap_X = '-';      label.kap_X = 'digestion efficiency of food to reserve'; 
par.kap_P = 0.05;      free.kap_P = 0;      units.kap_P = '-';      label.kap_P = 'faecation efficiency of food to faeces'; 
par.v = 0.1858;        free.v     = 0;      units.v = 'cm/d';       label.v = 'energy conductance'; 
par.kap = 0.5809;      free.kap   = 0;      units.kap = '-';        label.kap = 'allocation fraction to soma';
par.kap_R = 0.95;      free.kap_R = 0;      units.kap_R = '-';      label.kap_R = 'reproduction efficiency'; 
par.p_M = 1200;        free.p_M   = 0;      units.p_M = 'J/d.cm^3'; label.p_M = '[p_M], vol-spec somatic maint'; 
par.p_T = 0;           free.p_T   = 0;      units.p_T = 'J/d.cm^2'; label.p_T = '{p_T}, surf-spec somatic maint'; 
par.k_J = 0.2537;      free.k_J   = 0;      units.k_J = '1/d';      label.k_J = 'maturity maint rate coefficient';
par.E_G = 4400;        free.E_G   = 0;      units.E_G = 'J/cm^3';   label.E_G = '[E_G], spec cost for structure'; 
par.E_Hb = 0.05464;     free.E_Hb  = 0;      units.E_Hb = 'J';       label.E_Hb = 'maturity at birth';   % modified from AmP to meet experimental data; value was 0.05464
par.E_Hp = 0.378;      free.E_Hp  = 0;      units.E_Hp = 'J';       label.E_Hp = 'maturity at puberty'; % modified from AmP to meet experimental data; value was 1.09
par.h_a = 0.0002794;   free.h_a   = 0;      units.h_a = '1/d^2';    label.h_a = 'Weibull aging acceleration'; 
par.s_G = -0.3;        free.s_G   = 0;      units.s_G = '-';        label.s_G = 'Gompertz stress coefficient for female'; 

%% other parameters 
par.T_A = 6400;        free.T_A   = 0;      units.T_A = 'K';        label.T_A = 'Arrhenius temperature'; 
par.T_ref = 293.15;    free.T_ref = 0;      units.T_ref = 'K';      label.T_ref = 'Reference temperature'; 
par.del_M = 0.264;     free.del_M = 0;      units.del_M = '-';      label.del_M = 'shape coefficient'; 
par.f = 0.8556;        free.f     = 0;      units.f = '-';          label.f = 'scaled functional response';
par.L_0 = 0.082;       free.L_0   = 0;      units.L_0 = '-';        label.L_0 = 'initial length';
par.mu_x = 0.023;      free.mu_x = 0;      units.mu_x  = 'J/mg';  label.mu_x  = 'conversion of mg carbon to J for algal food (Desmodesmus subspicatus)';

%% toxicity parameters 
% feeding:
%   par.c_0  =  4.044e-05;     free.c_0 = 1;        units.c_0 = 'µg/l';     label.c_0 = 'no-effect concentration sub-lethal';
%   par.c_T  =  0.9701;      free.c_T = 1;        units.c_T =  'µg/l';    label.c_T = 'tolerance concentration'; 
%   par.k_e  =  0.02337;     free.k_e = 1;        units.k_e = 'd-1';      label.k_e = 'elimination rate constant';

%cost for structure and repro
%  par.c_0  =  7.121e-05;  free.c_0 = 1;        units.c_0 = 'µg/l';     label.c_0 = 'no-effect concentration sub-lethal';
%  par.c_T  =  0.2004;    free.c_T = 1;        units.c_T =  'µg/l';    label.c_T = 'tolerance concentration'; 
%  par.k_e  =  0.003064;   free.k_e = 1;        units.k_e = 'd-1';      label.k_e = 'elimination rate constant';

%  par.c_0  =  3.988e-05;  free.c_0 = 1;        units.c_0 = 'nM';     label.c_0 = 'no-effect concentration sub-lethal';
%  par.c_T  =  5.607e-05;    free.c_T = 1;        units.c_T =  'nM';    label.c_T = 'tolerance concentration'; 
%  par.k_e  =  2.356e-05;   free.k_e = 1;        units.k_e = 'd-1';      label.k_e = 'elimination rate constant';


% increased allocation to soma (kappa):
%   par.c_0  =  1.322e-05;     free.c_0 = 1;        units.c_0 = 'µg/l';     label.c_0 = 'no-effect concentration sub-lethal';
%   par.c_T  =  0.897;      free.c_T = 1;        units.c_T =  'µg/l';    label.c_T = 'tolerance concentration'; 
%   par.k_e  =  0.007832;     free.k_e = 1;        units.k_e = 'd-1';      label.k_e = 'elimination rate constant';

% decreased allocation to soma (kappa):
%   par.c_0  =  4.363e-05;     free.c_0 = 1;        units.c_0 = 'µg/l';     label.c_0 = 'no-effect concentration sub-lethal';
%   par.c_T  =  1.279;      free.c_T = 1;        units.c_T =  'µg/l';    label.c_T = 'tolerance concentration'; 
%   par.k_e  =  0.01218;     free.k_e = 0;        units.k_e = 'd-1';      label.k_e = 'elimination rate constant';

% maintenance:
%   par.c_0  =  0.1884;     free.c_0 = 0;        units.c_0 = 'µg/l';     label.c_0 = 'no-effect concentration sub-lethal';
%   par.c_T  =  2.174;      free.c_T = 0;        units.c_T =  'µg/l';    label.c_T = 'tolerance concentration'; 
%   par.k_e  =  0.08658;     free.k_e = 1;        units.k_e = 'd-1';      label.k_e = 'elimination rate constant';

% energy conductance
%  par.c_0  =  0.0001223;  free.c_0 = 1;        units.c_0 = 'µg/l';     label.c_0 = 'no-effect concentration sub-lethal';
%  par.c_T  =  0.005695;    free.c_T = 1;        units.c_T =  'µg/l';    label.c_T = 'tolerance concentration'; 
%  par.k_e  =  0.0008062;   free.k_e = 1;        units.k_e = 'd-1';      label.k_e = 'elimination rate constant';

%cost for reproduction
  par.c_0  =  0.00013;  free.c_0 = 1;        units.c_0 = 'µg/l';     label.c_0 = 'no-effect concentration sub-lethal';
  par.c_T  =  0.169;    free.c_T = 1;        units.c_T =  'µg/l';    label.c_T = 'tolerance concentration'; 
  par.k_e  =  0.00518;   free.k_e = 1;        units.k_e = 'd-1';      label.k_e = 'elimination rate constant';

% hazard during oogenesis
%  par.c_0  =  4.053e-05;  free.c_0 = 1;        units.c_0 = 'µg/l';     label.c_0 = 'no-effect concentration sub-lethal';
%  par.c_T  =  0.9982;    free.c_T = 1;        units.c_T =  'µg/l';    label.c_T = 'tolerance concentration'; 
%  par.k_e  =  0.02236;   free.k_e = 1;        units.k_e = 'd-1';      label.k_e = 'elimination rate constant';

%% 
%%survival is not considered here
par.c_0s = 0;          free.c_0s =0;        units.c_0s  = 'ng/l';   label.c_0s = 'no-effect concentration survival';
par.b    = 0;          free.b = 0;          units.b = 'd-1';        label.b = 'killing rate';
par.h_0  = 0;          free.h_0 = 0;        units.h_0 = 'd-1';      label.h_0 = 'background hazard rate';
%%
% offspring related correction factors
par.z_E0 = 182.5;       free.z_E0 = 0;        units.z_E0 = '1/L^2';  label.z_E0 = 'scaling factor cost of an egg vs. mother length';

%% set chemical parameters from Kooy2010 
[par, units, label, free] = addchem(par, units, label, free, metaData.phylum, metaData.class);
par.d_V = 0.19;     free.d_V   = 0;   units.d_V = 'g/cm^3';         label.d_V = 'specific density of structure';  % g/cm^3, specific density of structure, see ref bibkey

%% Pack output: 
txtPar.units = units; txtPar.label = label; par.free = free; 
