p = PowSpecData([-4.5928, 4.5928, -0.41593, 0.41593, -8.1299, 8.5416], runtimeParameters);
p = p.calculatePowderSpectrum();
p = p.calculateIntensityList();
p = p.calculateChiSquared(experimentalIntensityList, experimentalError);

figure
plot(p.getTotalIntensities());
hold on;
plot(experimentalIntensityList);

p = p.calculatePowderSpectrumInQRange(0.7, 0.8, 10);
p = p.calculateIntensityList();
p = p.calculateChiSquared(experimentalIntensityList1, experimentalError1);

figure
plot(p.getTotalIntensities());
hold on;
plot(experimentalIntensityList1);