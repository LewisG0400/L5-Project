experimentalData = readmatrix("data\Cu5E20T01_Escan_Q1_5.dat");

[experimentIntensityList, runtimeParameters.E_buckets] = create_averievite_data(experimentalData, runtimeParameters.n_E_buckets);

plot(experimentIntensityList);