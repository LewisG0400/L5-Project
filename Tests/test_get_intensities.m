p = PowSpecData([0.502135681843017,-0.502135681843017,-1.059725698853338,1.749884237217241], runtimeParameters);

p = p.calculatePowderSpectrum();
p = p.calculateIntensityList();
p = p.calculateChiSquared(experimentalIntensityList, experimentalError);

disp(p.getTotalIntensities());

c = p.getChiSquared()