% Load in the experimental data
experimentalData = readmatrix("data\Haydeeite-Tsub-chiqw.dat");

% Convert it into a useable form.
[experimentalDataMatrixFull, errorMatrixFull, Q_bucketsFull, runtimeParameters.E_buckets] = create_haydeeite_data_matrix(experimentalData);
maxEnergy = runtimeParameters.E_buckets(end);

runtimeParameters.cutoffIndex = find(runtimeParameters.E_buckets >= runtimeParameters.cutoffEnergy, 1, 'first');
runtimeParameters.E_buckets = runtimeParameters.E_buckets(runtimeParameters.cutoffIndex:end);
experimentalDataMatrixFull = experimentalDataMatrixFull(runtimeParameters.cutoffIndex:end, :);
%plot_experimental_data(experimentalDataMatrixFull, runtimeParameters, Q_bucketsFull, maxEnergy);

figure
pcolor(Q_bucketsFull, runtimeParameters.E_buckets, experimentalDataMatrixFull);
colormap("turbo")
    c = colorbar;
    c.Label.String = 'Intensity (mbarn/meV/cell)';
    c.Label.FontSize = 18;
    title("Experimental powder spectrum", 'fontsize', 18)
    xlabel("Momentum transfer (Å^-1)", 'fontsize', 18)
    ylabel("Energy transfer (meV)", 'fontsize', 18)

[lower_Q, upper_Q] = get_q_index_range(runtimeParameters.Q_centre, runtimeParameters.Q_range, Q_bucketsFull);
Q_buckets = Q_bucketsFull(1, lower_Q:upper_Q);
%experimentalDataMatrix = experimentalDataMatrix(runtimeParameters.cutoffIndex:end, lower_Q:upper_Q);
experimentalDataMatrix = experimentalDataMatrixFull(:, lower_Q:upper_Q);
runtimeParameters.nQBuckets = upper_Q - lower_Q;

figure
pcolor(Q_buckets, runtimeParameters.E_buckets, experimentalDataMatrix);
colormap("turbo");
    c = colorbar;
    c.Label.String = 'Intensity (mbarn/meV/cell)';
    c.Label.FontSize = 18;
    title("Experimental powder spectrum", 'fontsize', 18)
    xlabel("Momentum transfer (Å^-1)", 'fontsize', 18)
    ylabel("Energy transfer (meV)", 'fontsize', 18)

experimentalIntensityList = get_total_intensities(experimentalDataMatrix);
%experimentalIntensityList = experimentalIntensityList * (1.0 /
%max(experimentalIntensityList)); 