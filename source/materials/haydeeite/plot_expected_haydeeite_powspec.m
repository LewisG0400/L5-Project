[haydeeiteLattice, bondList] = haydeeite_full_exchanges([-3.275, 0, 0, 0.948]);
%[haydeeiteLattice, bondList] = haydeeite([-2.6427, -0.6099, 1.5546]);

haydeeitePowSpec = haydeeiteLattice.powspec(0:0.01:2.5, 'Evect', 0:0.01:2.5, 'nRand', 5e3, 'formfact', true, 'hermit', true);
haydeeitePowSpec = sw_instrument(haydeeitePowSpec, 'norm', true, 'dE', 0.1, 'dQ', 0.05, 'Ei', 5);

%plot_total_intensities(experimentalIntensityList, , 2.5, a, [-3.275, 0, 0.948]);
figure
sw_plotspec(haydeeitePowSpec);
subtitle("Taken with exchanges J1 = -3.275, Jd = 0.948")
colormap('turbo');

intensities = get_total_intensities(haydeeitePowSpec.swConv);
experimentalIntensities = get_total_intensities(experimentalDataMatrix);

intensities = intensities * (max(experimentalIntensities, [], 'all') / max(intensities, [], 'all'));

figure
plot(experimentalIntensities);
hold on
plot(intensities);
title("Total Intensity for E" )
xlabel("E (meV)")
ylabel("Intensity")
set(gca, 'xticklabel', runtimeParameters.E_buckets(1:floor(size(runtimeParameters.E_buckets, 2) / 10):size(runtimeParameters.E_buckets, 2)))
set(gca, 'YTickLabel', intensities)

% 
% haydeeitePowSpecData = PowSpecData([-3.275, 0, 0, 0.948], runtimeParameters);
% haydeeitePowSpecData = haydeeitePowSpecData.calculatePowderSpectrum();
% haydeeitePowSpecData = haydeeitePowSpecData.calculateIntensityList();
% haydeeitePowSpecData = haydeeitePowSpecData.calculateChiSquared(experimentalIntensityList, experimentalError);
% 
% %plot_total_intensities(experimentalIntensityList, haydeeitePowSpecData.getTotalIntensities(), 5, haydeeitePowSpecData.getChiSquared(), [-3.275, 0, 0, 0.948]);
% plot_powder_spectrum_and_intensities(experimentalIntensityList, experimentalError, haydeeitePowSpecData.getTotalIntensities(), 2.5, 0.7, haydeeiteLattice, 0, 2.5, 0.5, 0.05, haydeeitePowSpecData.getChiSquared(), [-3.275, 0, 0, 0.948]);