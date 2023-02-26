averieviteData = readmatrix("data\Cu5E20T01.txt");
[averieviteDataMatrix, averieviteErrorMatrix, averieviteQs, averieviteEs] = create_averievite_data(averieviteData);

runtimeParameters.cutoffIndex = find(averieviteEs >= runtimeParameters.cutoffEnergy, 1, 'first');
runtimeParameters.E_buckets = averieviteEs(runtimeParameters.cutoffIndex:end);

averieviteDataMatrix = averieviteDataMatrix(runtimeParameters.cutoffIndex:end, :);
averieviteErrorMatrix = averieviteErrorMatrix(runtimeParameters.cutoffIndex:end, :);

[lower_Q_1, upper_Q_1] = get_q_index_range(runtimeParameters.Q_centre, runtimeParameters.Q_range, averieviteQs);
[lower_Q_2, upper_Q_2] = get_q_index_range(0.75, 0.05, averieviteQs);

Q_buckets = averieviteQs(1, lower_Q_1:upper_Q_1);

experimentalIntensityList = get_total_intensities(averieviteDataMatrix(:, lower_Q_1:upper_Q_1));
experimentalIntensityList1 = get_total_intensities(averieviteDataMatrix(:, lower_Q_2:upper_Q_2));

experimentalError = get_total_errors(averieviteErrorMatrix(:, lower_Q_1:upper_Q_1));
experimentalError1 = get_total_errors(averieviteErrorMatrix(:, lower_Q_2:upper_Q_2));
