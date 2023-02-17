% Load in the experimental data
experimentalData = readmatrix("data\Haydeeite-Tsub-chiqw.dat");
experimentalError = ones(runtimeParameters.n_E_buckets);

% Convert it into a useable form.
[experimentalDataMatrixFull, Q_bucketsFull, runtimeParameters.E_buckets] = create_haydeeite_data_matrix(experimentalData, runtimeParameters.n_E_buckets, runtimeParameters.cutoffEnergy);
plot_experimental_data(experimentalDataMatrixFull, runtimeParameters, Q_bucketsFull, maxEnergy);

maxEnergy = max(experimentalData(:, 2));
runtimeParameters.cutoffIndex = find(runtimeParameters.E_buckets >= runtimeParameters.cutoffEnergy, 1, 'first');
runtimeParameters.E_buckets = runtimeParameters.E_buckets(runtimeParameters.cutoffIndex:end);

experimentalDataMatrixFull = experimentalDataMatrixFull(runtimeParameters.cutoffIndex:end, :);

[lower_Q, upper_Q] = get_q_index_range(runtimeParameters.Q_centre, runtimeParameters.Q_range, Q_bucketsFull);
Q_buckets = Q_bucketsFull(1, lower_Q:upper_Q);
%experimentalDataMatrix = experimentalDataMatrix(runtimeParameters.cutoffIndex:end, lower_Q:upper_Q);
experimentalDataMatrix = experimentalDataMatrixFull(:, lower_Q:upper_Q);
runtimeParameters.nQBuckets = upper_Q - lower_Q;

experimentalIntensityList = get_total_intensities(experimentalDataMatrix, runtimeParameters.cutoffIndex);
experimentalIntensityList(end) = [];
%experimentalIntensityList = experimentalIntensityList * (1.0 / max(experimentalIntensityList));