function [prdData, info] = predict_Daphnia_magna(par, data, auxData)
  %global tvol tfeed tclear
  
  % unpack par, data, auxData
  cPar = parscomp_st(par); vars_pull(par); 
  vars_pull(cPar);  vars_pull(data);  vars_pull(auxData); 
  
  % customized filters to contrain additional parameter
filterChecks = ...
    c_0 <=0;
  
  if filterChecks
    info = 0;
    prdData = {};
    return;
  end
  
  % compute temperature correction factors
  TC = tempcorr(temp.tLc1, T_ref, T_A);       % all data at T_ref  

  % life cycle
  pars_tp = [g k l_T v_Hb v_Hp];
  [t_p, t_b, l_p, l_b,  info] = get_tp(pars_tp, f);
  
  % initial
   aT_b = t_b/ k_M/ TC;  %age at birth at f and T
   L_b = L_m * l_b;           % cm, structural length at birth at f
   pars_UE0 = [V_Hb; g; k_J; k_M; v]; % compose parameter vector
   U_E0 = initial_scaled_reserve(f, pars_UE0); % d.cm^2, initial scaled reserve
  
  %temperature correction
   pT_M = TC * p_M; % maintenance rate constant, J / d.cm^3
   vT = TC * v;     % energy conductance, cm / d
   kT_J = TC * k_J;  % maturity maintenance rate, d-1
   pT_Am = p_Am * TC;  % surface-area specific maximum assimilation rate, J / d.cm^2    
    
 %% experimental condtions   
  tfeed = [ ... time (d), feeding event
    0	2
    1	0
    2	3
    3	0
    4	0
    5	2
    6	0
    7	2
    8	0
    9	3
    10	0
    11	0
    12	2
    13	0
    14	2
    15	0
    16	3
    17	0
    18	0
    19	2
    20	0
    21	3
    22	0
    23	0
    24	2
    25	0
    26	2
    27	0
    28	2
    29	0
    30	0
   ];

  tclear = [ ... time (d), cleaning events (0/1)  1 = cleaning and removal of food
    0	1
    1	0
    2	1
    3	0
    4	0
    5	1
    6	0
    7	1
    8	0
    9	1
    10	0
    11	0
    12	1
    13	0
    14	1
    15	0
    16	1
    17	0
    18	0
    19	1
    20	0
    21	1
    22	0
    23	0
    24	1
    25	0
    26	1
    27	0
    28	1
    29	0
    30	0
   ];
  
   tvol = [ ... time (d), volume added L
    0	0.002816503
    1	0.003965158
    2	0.003965158
    3	0.003612421
    4	0.002635636
    5	0.003612421
    6	0.002635636
    7	0.002635636
    8	0.004140901
    9	0.004140901
    10	0.00330173
    11	0.003187831
    12	0.00330173
    13	0.003187831
    14	0.003187831
    15	0.004107678
    16	0.004107678
    17	0.002874562
    18	0.002480457
    19	0.002874562
    20	0.002480457
    21	0.002480457
    22	0.00357198
    23	0.002545972
    24	0.00357198
    25	0.002545972
    26	0.002545972
    27	0.002529534
    28	0.002529534
    29	0.002529534
    30	0.002529534
   ];
    
%% univariate data ----------------
   L_0 = 0.0844; %L_b/del_M;
    E_t0 =  p_Am * (L_0 * del_M)^2 * 0.5; % J, initial reserve
    E_H0 = E_Hb; % J, initial maturity
    E_R0 = 0; % J, initial reproduction buffer    
    XJ = 0; %J, food     
    tfeed(:,2) = tfeed(:,2)*0.026/mu_x; %0.026 mgC/daphnid/day
    
    par_LEHR = [pT_M, vT, kT_J, pT_Am, kap, E_G, f, E_Hp, kap_R, kap_X, F_m, U_E0 * p_Am]; % pack parameters
    par_exp = [z_E0]; % additional parameters 
    
    LEHRCS_0 = [L_0*del_M; E_t0; E_H0; E_R0; 0; 100; XJ; L_0*del_M; 0]; % pack initial conditions
    t = tLc1(:,1); % time vectorfor length
    t2 = tNc1(:,1); % time vector for offspring
    
    % define options for the ODE solver    
    options = odeset;
    options = odeset(options, 'RelTol',1e-4,'AbsTol',1e-7); % specify tightened tolerances
    options = odeset(options,'InitialStep',max(t)/2000,'MaxStep',max(t)/200); % specify smaller stepsize

    c = [0	0.015  0.06	 0.12 0.25 1 4]; % concentrations
    for i = 1:length(c)
        tNc = ['tNc',num2str(i)];
        tLc = ['tLc',num2str(i)];     
        par_CS = [k_e, c_0, c_T, c_0s, b, h_0, c(i)];
        
        par_LEHRCS = [par_LEHR, par_CS, par_exp]; 
        [t, LEHRCS] = ode45(@get_LEHRCS, t, LEHRCS_0, options, par_LEHRCS, tfeed, tclear, tvol);  
        L = LEHRCS(:,8)/del_M; % cm, physical length 
         
        %save to file
            filename = ['results_',num2str(c(i)),'nM.Hg.csv'];
            if isfile(filename)
                 % File exists.
            else
                 csvwrite(filename ,LEHRCS);
            end      
        
        [t2, LEHRCS] = ode45(@get_LEHRCS, t2, LEHRCS_0, options, par_LEHRCS, tfeed, tclear, tvol);
        N = LEHRCS(:,9); % #, cumulative reproduction
       
        % pack to output
        prdData.(tNc) = N;  
        prdData.(tLc) = L;     
    end
    
    % Boersma offspring size relative to mother size, assuming that
    % increase in Wwb 1:1 scales with increased E0
    pLb =  z_E0 * (LLb(:,1)*del_M).^2;
    prdData.LLb = pLb;
end


%% SUBFUNCTION 

function [dLEHRCS] = get_LEHRCS(t, LEHRCS, par_LEHRCS, tfeed, tclear, tvol)
    %% function to calculate L, E, H, R , C and S dynamically over time
    % input parameters: 
    p_M     = par_LEHRCS(1);   % J/d.cm^3, vol-spec somatic maint
    v       = par_LEHRCS(2);   % cm/d, energy conductance
    k_J     = par_LEHRCS(3);   % 1/d, maturity maint rate coefficient
    p_Am    = par_LEHRCS(4);   % J / d.cm^2, surface-area specific maximum assimilation rate
    kap     = par_LEHRCS(5);   % -, allocation fraction to soma
    E_G     = par_LEHRCS(6);   % J/cm^3, spec cost for structure
    f_0     = par_LEHRCS(7);   % -, control scaled functional response 
    E_Hp    = par_LEHRCS(8);   % J, maturity at puberty
    kap_R   = par_LEHRCS(9);   % -, reproduction efficiency    
    kap_X   = par_LEHRCS(10);  % -, digestion efficiency   
    F_m     = par_LEHRCS(11);  % search rate
    E0      = par_LEHRCS(12);  % J d.cm^2, initial reserve    
    ke      = par_LEHRCS(13);  % d-1, elimination rate constant
    c0      = par_LEHRCS(14);  % ng/l, no-effect concentration sub-lethal
    cT      = par_LEHRCS(15);  % ng/l, tolerance concentration
    c0s     = par_LEHRCS(16);  % ng/l, no-effect concentration survival
    b       = par_LEHRCS(17);  % d-1, killing rate
    h0      = par_LEHRCS(18);  % d-1, background hazard rate
    c       = par_LEHRCS(19);  % ng/l, external concentration   
    z_E0    = par_LEHRCS(20);  % L^-2, scaling factor increased egg costs with length      
    Lm      = p_Am *kap / p_M; % cm, maximum structural length  

    % initialize output parameters
    L       = LEHRCS(1); % cm, state 1 is the structural length at previous time point
    E       = LEHRCS(2); % J, state 2 is the energy reserve
    H       = LEHRCS(3); % J, state 3 is energy invested in maturity
    R       = LEHRCS(4); % J, state 4 is the reproduction buffer
    cV      = LEHRCS(5); % ng/l, internal concentration
    S       = LEHRCS(6); % -, survival probability 
    XJ      = LEHRCS(7); % -, Food density 
    Lmax    = LEHRCS(8); % -, maximum length (to mimic that carapax length does not shrink)
    RN      = LEHRCS(9); % -, Embryos
    
    %% stress and physiological modes of action
   
    % calculate the stress factor
    s  = (1/cT)*max(0,cV-c0); % stress factor
    
    % mode of action: effect on feeding
    % p_Am = p_Am * max(0, 1- s);  
    
    % mode of action: effect on assimilation
    %kap_X = kap_X * max(0, 1- s);
   
    % mode of action: effect on maintenance costs
    %   p_M = p_M * (1 + s); k_J = k_J * (1 + s);
   
    % mode of action: effect on growth cost and cost for maturity and reproduction
       % E_G = E_G * (1 + s);    E0 = E0 * (1 + s);  k_J = k_J*(1 + s);  
      
    % mode of action: effect on cost for reproduction
      %  E0 = E0 * (1 + s);
      
    % mode of action: effect on overhead costs for making an egg
      kap_R = kap_R / (1 + s); %implemented via the reproduction efficency

    % mode of action: hazard during oogenesis
     % kap_R = kap_R * exp(-s); %implemented via the reproduction efficency
     
    % mode of action: effect on energy conductance
     %  v = v / (1 + s);
      
    %increased allocation to soma        
      % kap = min(kap * max(0, 1 + s),1); %or     
      % kap = kap / max(0 , 1 + s); 
     
    %% scaled functional response and ingestion
    xK = p_Am/ kap_X / (F_m); 
    X = XJ/ (0.045 + spline1(t, tvol)); 
    f = (L.^2 * p_Am / kap_X * X/(xK + X))/(p_Am*L.^2);    
    pX =(L.^2 * p_Am / kap_X * X/(xK + X));
    
    %% fluxes, growth, reproduction and food    
    % growth rate    
    r = ((E * v / L^4) - (p_M / kap)) / ((E / L^3) + (E_G / kap)); % 1/d, specific growth rate
    % fluxes
    pC = E * (v / L -  r);            % J/d, mobilization
    pA = f * p_Am * L^2;              % J/d, assimilation
    pJ = H * k_J;                     % J/d; energy invested in maturity  
    
    % calculate changes in state variables
    dL = L * r / 3;                   % cm/d growth 
    dLmax = max(0, L * r / 3); %carapax length will not decrease over time    
    dE = pA - pC;                     % J/d reserve dynamics  
    dH = (H < E_Hp) * max(0, (1 - kap) * pC - pJ);          % J/d increase in maturation
    dR = (H >= E_Hp) * kap_R * max(0, (1 - kap) * pC - pJ); % J/d investment in reproduction  

    %approximation for increased egg size with decreasing food
    E0 = E0 * z_E0 *L^2;
    dRN = dR /E0; % Number of embryos  
    
    %Food availability 
    dXJ= -(L.^2 * p_Am / kap_X * X/(xK + X))*(1-spline1(t, tclear)) + spline1(t, tfeed)- XJ * spline1(t, tclear) ; 
        
    %% damage, hazard and survival
    dcV = ke * (Lm/L)*(f*c- cV) - cV*(3/L)*dL; %change in scaled internal concentration (scaled damage)linked to scaled functional response
     
    h  = b * max(0,cV-c0s); % calculate the hazard rate
    dS = -(h + h0)* S;      % change in survival probability (incl. background mortality)       
    
    %% collect derivatives  
    dLEHRCS = [dL; dE; dH; dR; dcV; dS; dXJ; dLmax; dRN];    
    
end


    
