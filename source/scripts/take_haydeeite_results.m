% These are parameters that can be changed to control
% aspects of the RMC.
runtimeParameters.Q_centre = 0.5;
runtimeParameters.Q_range = 0.05;
runtimeParameters.acceptanceParameter = 4.0;%2.5e4;
runtimeParameters.totalIterations = 5000;
runtimeParameters.n_E_buckets = 100;
runtimeParameters.nQBuckets = 0;
runtimeParameters.cutoffEnergy = 0.7;
runtimeParameters.nRand = 5e3;
% If chi squared is less than this value, take the average
% of 3 measurements to try to counteract the randomness
% in powder spectrums.
runtimeParameters.takeAverageCutoff = 0.05;
% The function that creates the SpinW objects
runtimeParameters.latticeGenerator = @haydeeite;
runtimeParameters.cutoffIndex = 1;
runtimeParameters.inputEnergy = 5.0;
 
setup_haydeeite;
%
runtimeParameters.maxEnergy = max(runtimeParameters.E_buckets);

% This should correspond to the number of exchange interactions
% input to the lattice generator.
nExchangeParameters = 3;

% The max value the parameters can take - used to generate
% new parameters.
maxInteractionStrength = 5.0;

rmcStats.worstAccepted = 1;
rmcStats.worseAcceptedCount = 0;
rmcStats.worseRejectedCount = 0;
rmcStats.failCount = 0;

run_count = 1;

main;
save("results/haydeeite/report_data/haydeeite_3_param_set2_1");


% This struct has data for monitoring the RMC algorithm.
rmcStats.worstAccepted = 1;
rmcStats.worseAcceptedCount = 0;
rmcStats.worseRejectedCount = 0;
rmcStats.failCount = 0;
run_count = 1;

main;
save("results/haydeeite/report_data/haydeeite_3_param_set2_2");

rmcStats.worstAccepted = 1;
rmcStats.worseAcceptedCount = 0;
rmcStats.worseRejectedCount = 0;
rmcStats.failCount = 0;

run_count = 1;

main;
save("results/haydeeite/report_data/haydeeite_3_param_set2_3");

% rmcStats.worstAccepted = 1;
% rmcStats.worseAcceptedCount = 0;
% rmcStats.worseRejectedCount = 0;
% rmcStats.failCount = 0;
% 
% runtimeParameters.latticeGenerator = @haydeeite_full_exchanges;
% nExchangeParameters = 3;
% 
% run_count = 1;
% 
% main;
% save("results/haydeeite/report_data/haydeeite_4_param_1");
% 
% rmcStats.worstAccepted = 1;
% rmcStats.worseAcceptedCount = 0;
% rmcStats.worseRejectedCount = 0;
% rmcStats.failCount = 0;
% 
% run_count = 1;
% 
% main;
% save("results/haydeeite/report_data/haydeeite_4_param_2");
% 
% rmcStats.worstAccepted = 1;
% rmcStats.worseAcceptedCount = 0;
% rmcStats.worseRejectedCount = 0;
% rmcStats.failCount = 0;
% 
% run_count = 1;
% 
% main;
% save("results/haydeeite/report_data/haydeeite_4_param_3");