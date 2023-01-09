total_intensity_list_experimental = get_total_intensities(experimentalDataMatrix, runtimeParameters.cutoffIndex);

kagome = spinw;

interactions = [-3.275, 0, 0, 0.948];

powSpecData = PowSpecData(interactions, runtimeParameters);

powSpecData = powSpecData.calculatePowderSpectrum();
powSpecData = powSpecData.calculateIntensityList();
powSpecData = powSpecData.calculateChiSquared(experimentalIntensityList);

plot_powder_spectrum_and_intensities(experimentalIntensityList, powSpecData.getTotalIntensities(), max(runtimeParameters.E_buckets), runtimeParameters.cutoffEnergy, powSpecData.lattice, Q_buckets(1), Q_buckets(end), runtimeParameters.Q_centre, runtimeParameters.Q_range, powSpecData.getChiSquared(), interactions)
