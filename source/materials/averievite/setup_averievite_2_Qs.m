averieviteData = readmatrix("data\Cu5E20T01.txt");
[averieviteDataMatrix, averieviteQs, averieviteEs] = create_averievite_data_matrix(averieviteData, 100, 5);

runtimeParameters.cutoffIndex = find(averieviteEs >= runtimeParameters.cutoffEnergy, 1, 'first');
runtimeParameters.E_buckets = averieviteEs(runtimeParameters.cutoffIndex:end);

averieviteDataMatrix = averieviteDataMatrix(runtimeParameters.cutoffIndex:end, :);

[lower_Q_1, upper_Q_1] = get_q_index_range(runtimeParameters.Q_centre, runtimeParameters.Q_range, averieviteQs);
[lower_Q_2, upper_Q_2] = get_q_index_range(0.75, 0.05, averieviteQs);

Q_buckets = averieviteQs(1, lower_Q_1:upper_Q_1);

experimentalIntensityList = get_total_intensities(averieviteDataMatrix(:, lower_Q_1:upper_Q_1), runtimeParameters.cutoffIndex);
experimentalIntensityList(end) = [];
experimentalIntensityList1 = get_total_intensities(averieviteDataMatrix(:, lower_Q_2:upper_Q_2), runtimeParameters.cutoffIndex);
experimentalIntensityList1(end) = [];

experimentalError = ones(1, size(experimentalIntensityList, 2));
experimentalError1 = ones(1, size(experimentalIntensityList1, 2));
