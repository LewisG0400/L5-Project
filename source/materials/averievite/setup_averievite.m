experimentalData = readmatrix("data/Cu5E20T01_Escan_Q1_5.dat")

[experimentalIntensityList, experimentalError, runtimeParameters.E_buckets] = create_averievite_data(experimentalData, runtimeParameters.n_E_buckets);
experimentalIntensityList = get_total_intensities(experimentalData(:, 3).');
experimentalError = get_total_errors(experimentalData(:, 4).');

[lower_Q, upper_Q] = 

runtimeParameters.E_buckets = experimentalData(:, 1).';

disp(runtimeParameters.E_buckets)

runtimeParameters.cutoffIndex = find(runtimeParameters.E_buckets >= runtimeParameters.cutoffEnergy, 1, 'first');
runtimeParameters.E_buckets = runtimeParameters.E_buckets(runtimeParameters.cutoffIndex:end);
experimentalIntensityList = experimentalIntensityList(runtimeParameters.cutoffIndex:end);
experimentalError = experimentalError(runtimeParameters.cutoffIndex:end);

runtimeParameters.n_E_buckets = size(experimentalError, 2);

errorbar(experimentalIntensityList, experimentalError);