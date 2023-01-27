experimentalData = readmatrix("data/Cu5E20T01_Escan_Q1_5.dat");

[experimentalIntensityList, experimentalError, runtimeParameters.E_buckets] = create_averievite_data(experimentalData, runtimeParameters.n_E_buckets);
runtimeParameters.n_E_buckets = size(experimentalError, 1);

disp(runtimeParameters.E_buckets)

runtimeParameters.cutoffIndex = find(runtimeParameters.E_buckets >= runtimeParameters.cutoffEnergy, 1, 'first');
runtimeParameters.E_buckets = runtimeParameters.E_buckets(runtimeParameters.cutoffIndex:end);
experimentalIntensityList = experimentalIntensityList(runtimeParameters.cutoffIndex:end);
experimentalError = experimentalError(runtimeParameters.cutoffIndex:end);

errorbar(experimentalIntensityList, experimentalError);