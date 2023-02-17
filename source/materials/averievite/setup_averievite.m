experimentalData = readmatrix("data/Cu5E20T01_Escan_Q1_5.dat")

%[experimentalIntensityList, experimentalError, runtimeParameters.E_buckets] = create_averievite_data(experimentalData, runtimeParameters.n_E_buckets);
experimentalIntensityList = experimentalData(:, 2).';
experimentalError = experimentalData(:, 3).';

runtimeParameters.E_buckets = experimentalData(:, 1).';

disp(runtimeParameters.E_buckets)

runtimeParameters.cutoffIndex = find(runtimeParameters.E_buckets >= runtimeParameters.cutoffEnergy, 1, 'first');
runtimeParameters.E_buckets = runtimeParameters.E_buckets(runtimeParameters.cutoffIndex:end);
experimentalIntensityList = experimentalIntensityList(runtimeParameters.cutoffIndex:end);
experimentalError = experimentalError(runtimeParameters.cutoffIndex:end);

runtimeParameters.n_E_buckets = size(experimentalError, 2);

errorbar(experimentalIntensityList, experimentalError);