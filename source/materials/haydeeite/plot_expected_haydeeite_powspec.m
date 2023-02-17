[haydeeiteLattice, bondList] = haydeeite_full_exchanges([-3.275, 0, 0, 0.948]);
%[haydeeiteLattice, bondList] = haydeeite([-2.6427, -0.6099, 1.5546]);

haydeeitePowSpec = haydeeiteLattice.powspec(0:0.025:2.5, 'Evect', 0:0.025:2.5, 'nRand', 5e3, 'hermit', true);
haydeeitePowSpec = sw_instrument(haydeeitePowSpec, 'norm', true, 'dE', 0.1, 'dQ', 0.05, 'Ei', 5);

%plot_total_intensities(experimentalIntensityList, , 2.5, a, [-3.275, 0, 0.948]);
%figure
%sw_plotspec(haydeeitePowSpec);

haydeeitePowSpecData = PowSpecData([-3.275, 0, 0, 0.948], runtimeParameters);
haydeeitePowSpecData = haydeeitePowSpecData.calculatePowderSpectrum();
haydeeitePowSpecData = haydeeitePowSpecData.calculateIntensityList();
haydeeitePowSpecData = haydeeitePowSpecData.calculateChiSquared(experimentalIntensityList, experimentalError);

%plot_total_intensities(experimentalIntensityList, haydeeitePowSpecData.getTotalIntensities(), 5, haydeeitePowSpecData.getChiSquared(), [-3.275, 0, 0, 0.948]);
plot_powder_spectrum_and_intensities(experimentalIntensityList, experimentalError, haydeeitePowSpecData.getTotalIntensities(), 2.5, 0.7, haydeeiteLattice, 0, 2.5, 0.5, 0.05, haydeeitePowSpecData.getChiSquared(), [-3.275, 0, 0, 0.948]);