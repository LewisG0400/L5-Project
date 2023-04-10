
nRands = 500:500:10000;
times = zeros(size(nRands));
sds = zeros(size(nRands));

for i = 1:size(nRands, 2)
    runtimeParameters.nRand = nRands(i);
    loopTimes = zeros(5, 1);
    loopChi = zeros(5, 1);
    for j = 1:25
        p = PowSpecData([-3.275, 0, 0, 0.948], runtimeParameters);
        tic
        p = p.calculatePowderSpectrum();
        p = p.calculateIntensityList();
        p = p.calculateChiSquared(experimentalIntensityList, ones(size(experimentalIntensityList)));
        loopTimes(j, 1) = toc;
        loopChi(j, 1) = p.getChiSquared();
    end
    times(1, i) = mean(loopTimes);
    sds(1, i) = std(loopChi);
end

figure
xlabel("nRand")
xticklabels(nRands)

yyaxis left
plot(times)
ylabel("Mean time taken")
hold on
yyaxis right
plot(sds)
ylabel("Chi Squared Standard Deviation")