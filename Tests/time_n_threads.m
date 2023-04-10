%meanTimes = zeros(6, 1);

maxNumCompThreads(32);
nThreads = [1, 2, 4, 8];
for threadIndex = 1:6
    pool = parpool("Threads", nThreads(threadIndex));
    times = zeros(25, 1);
    for i = 1:25
        tic
        p = PowSpecData([-3.275, 0, 0.948], runtimeParameters);
        p = p.calculatePowderSpectrum();
        times(i) = toc;
    end
    meanTimes(threadIndex) = mean(times, 'all');
    delete(pool);
end

plot(meanTimes);