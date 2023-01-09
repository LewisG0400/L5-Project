% Load in the experimental data
experimentalData = readmatrix("data\Haydeeite-Tsub-chiqw.dat");

% Convert it into a useable form.
[experimentalDataMatrix, Q_buckets, runtimeParameters.E_buckets] = create_haydeeite_data_matrix(experimentalData, runtimeParameters.n_E_buckets, runtimeParameters.cutoffEnergy);
maxEnergy = max(experimentalData(:, 2));
runtimeParameters.cutoffIndex = find(runtimeParameters.E_buckets >= runtimeParameters.cutoffEnergy, 1, 'first');

plot_experimental_data(experimentalDataMatrix, runtimeParameters, Q_buckets, maxEnergy);

[lower_Q, upper_Q] = get_q_index_range(runtimeParameters.Q_centre, runtimeParameters.Q_range, Q_buckets);
%experimentalDataMatrix = experimentalDataMatrix(runtimeParameters.cutoffIndex:end, lower_Q:upper_Q);
experimentalDataMatrix = experimentalDataMatrix(:, lower_Q:upper_Q);
runtimeParameters.nQBuckets = upper_Q - lower_Q;

experimentalIntensityList = get_total_intensities(experimentalDataMatrix, runtimeParameters.cutoffIndex);
experimentalIntensityList(end) = [];
%experimentalIntensityList = experimentalIntensityList * (1.0 / max(experimentalIntensityList));