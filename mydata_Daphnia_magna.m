function [data, auxData, metaData, txtData, weights] = mydata_Daphnia_magna
%global tvol tfeed tclear

%% set metaData
metaData.phylum     = 'Arthropoda'; 
metaData.class      = 'Branchiopoda'; 
metaData.order      = 'Cladocera'; 
metaData.family     = 'Daphniidae';
metaData.species    = 'Daphnia_magna'; 
metaData.species_en = 'Waterflea'; 
metaData.T_typical  = C2K(20); % K, body temp
metaData.data_0     = {'none'}; 
metaData.data_1     = {'t-L'; 't-N'; 'L-W'}; 

metaData.author_mod = {'Andre Gergs'};   
metaData.date_mod   = [2026 03 12];              
metaData.email_mod  = {'andre.gergs@bayer.com'};            
metaData.address_mod = {'Bayer AG'}; 


%% uni-variate data
%time since start experiment (d), body length (cm)
tLc = [ ... %concentrations 
1	0.084312	0.081936	0.086848	0.082588	0.083984	0.086348	0.08506
3	0.1046	0.106464	0.108048	0.110879167	0.11406	0.114970833	0.119964
6	0.209495238	0.210104762	0.205325	0.20546	0.217238095	0.216115	0.223633333
8	0.243605	0.243438095	0.244655	0.244225	0.261847619	0.251425	0.2483
10	0.274645	0.268395238	0.26502	0.26799	0.273461905	0.26872	0.266014286
13	0.30475625	0.295335294	0.296453333	0.29485625	0.2942	0.293453333	0.279641176
15	0.3130875	0.309352941	0.313733333	0.30554375	0.305929412	0.3034	0.290841176
17	0.314583333	0.308869231	0.310709091	0.303733333	0.305653846	0.303963636	0.291592308
20	0.335858333	0.323815385	0.331763636	0.323475	0.32735	0.321018182	0.3137
22	0.349025	0.341930769	0.345518182	0.334566667	0.342675	0.342072727	0.327269231
24	0.351183333	0.350388889	0.354885714	0.3422125	0.3468125	0.346457143	0.330588889
27	0.379242857	0.367425	0.357628571	0.35785	0.353157143	0.351242857	0.34185
29	0.364128571	0.3501375	0.3485	0.3504375	0.352942857	0.3486	0.3404
31	0.366742857	0.36185	0.362628571	0.3509375	0.363957143	0.349928571	0.3438875
];
t = tLc(:,1)-1; % d, time, starting at time 0
L = tLc(:,2:end); % g, wet weight 

for i = 1: (length(tLc(1,:))-1)
tLc = ['tLc',num2str(i)];
data.(tLc) = [t, L(:,i)]; % d, #
units.(tLc)   = {'d', 'cm'};  label.(tLc) = {'time', 'body length'};  
temp.(tLc)    = C2K(20);  units.temp.(tLc) = 'K'; label.temp.(tLc) = 'temperature';
bibkey.(tLc) = 'Stevenson_etal';
comment.(tLc) = 'coal ash';
end

% time since start experiment (d), neonates (#)
% neonate data corrected for time when eggs were first observed in control,
% Tubes (replicates) 107 and 110 remove: females hardy reproduced after first brood
tNc = [ ... %concentrations 
1	0	0	0	0	0	0	0
3	0	0	0	0	0	0	0
6	0	0.428571429	0.65	0	0	0	0
8	8.95	9.19047619	8.176315789	8.5	8.947368421	8.5	7.19047619
10	16.0125	18.77871148	16.50964912	17.3125	17.21403509	13.1	8.778711485
13	20.1375	21.0140056	19.24298246	18.875	18.08070175	15.43333333	10.30812325
15	24.05416667	23.62939022	22.42480064	21.875	19.48070175	17.97878788	12.30812325
17	28.8875	31.32169791	28.24298246	30.04166667	19.48070175	23.52424242	16.23120017
20	31.22083333	31.93708253	28.24298246	30.375	21.38070175	25.97878788	16.69273863
22	36.07797619	33.93708253	32.67155388	32.375	25.88070175	28.69307359	17.19273863
24	40.50654762	39.06208253	36.95726817	41	32.08070175	33.12164502	20.31773863
27	44.7922619	41.18708253	39.3858396	41.125	32.08070175	34.26450216	20.69273863
];

t = tNc(:,1)-1; % d, time, starting at time 0
N = tNc(:,2:end); % #, cumulative numbers

for i = 1: (length(tNc(1,:))-1)
tNc = ['tNc',num2str(i)];
data.(tNc) = [t, N(:,i)]; % d, #
units.(tNc)   = {'d', '#'};  label.(tNc) = {'time', 'cumulative neonates'};  
temp.(tNc)    = C2K(20);  units.temp.(tNc) = 'K'; label.temp.(tNc) = 'temperature';
bibkey.(tNc) = 'Stevenson_etal';
end

%% addional data
data.LLb = [ ... %mother length, cm; relative offspring weight, - 
2.76	1
3.41	1.528145695
3.73	1.708609272
3.97	2.084437086
4.27	2.223509934
4.45	2.052980132
4.49	2.054635762
4.53	2.117549669
4.7	    2.233443709
];
data.LLb(:,1) = data.LLb(:,1)/10; % d, time
units.LLb   = {'cm', '-'};  label.LLb = {'length', 'neonate weight relative to first instar offspring'};  
bibkey.LLb = 'Boer1997';
comment.LLb = 'Length data from Figure 1, Offspring weight Figure 2';


%% set weights for all real data
weights = setweights(data, []);

%% set pseudodata and respective weights
[data, units, label, weights] = addpseudodata(data, units, label, weights);

%% pack auxData and txtData for output
auxData.temp = temp;
txtData.units = units;
txtData.label = label;
txtData.bibkey = bibkey;
txtData.comment = comment;

%% Group plots
  set1 = {'tNc1','tNc2','tNc3','tNc4','tNc5','tNc6','tNc7',}; comment1 = {'coal ash'};
  set2 = {'tLc1','tLc2','tLc3','tLc4','tLc5','tLc6','tLc7',}; comment2 = {'coal ash'};
  metaData.grp.sets = {set1, set2};
  metaData.grp.comment = {comment1, comment2};

%% Discussion points
D1 = '-';
metaData.discussion = struct('D1', D1);

%% References
bibkey = 'Wiki'; type = 'Misc'; bib = ...
'howpublished = {\url{http://en.wikipedia.org/wiki/Daphnia_magna}}';
metaData.biblist.(bibkey) = ['''@', type, '{', bibkey, ', ' bib, '}'';'];
%
bibkey = 'Stevenson_etal'; type = 'Article'; bib = [ ... 
'author = {Louise M Stevenson, Andre Gergs, Lea Rahlfes, Ferdinand Pfab, Paul C. Pickhardt, Teresa J Mathews, Natàlia Garcia?Reyero, Cheryl A Murphy, Roger M Nisbet, Philipp Antczak}, ' ... 
'year = {}, ' ...
'title = {Linking molecular responses to organismal outcomes under complex contaminant stress: a systems biology approach for predictive ecotoxicology}, ' ...
'journal = {}, ' ...
'doi = {-}, ' ...
'volume = {-}, ' ...
'pages = {-}'];
metaData.biblist.(bibkey) = ['''@', type, '{', bibkey, ', ' bib, '}'';'];
%
bibkey = 'Boer1997'; type = 'Article'; bib = [ ... 
'author = {Boersma, M. }, ' ... 
'year = {1997}, ' ...
'title = {Offspring size and parental ®tness in Daphnia magna}, ' ...
'journal = {Evolutionary Ecology}, ' ...
'doi = {10.1023/A:1018484824003}, ' ...
'volume = {11}, ' ...
'pages = {439-450}'];
metaData.biblist.(bibkey) = ['''@', type, '{', bibkey, ', ' bib, '}'';'];



