exchanges = [-3.3462, 3.3462, -0.58304, 0.58304, -6.1176, 7.9344];

times = zeros(10);
i = 1;
for n = 5:5:50
    tic
    l = averievite(exchanges);
    Qs = linspace(0, 2.5, n);
    l.powspec(Qs, 'Evect', runtimeParameters.E_buckets, 'nRand', runtimeParameters.nRand, 'formfact', true, 'hermit', true, 'imagChk', false, 'fid', 0, 'tid', 0);
    times(i) = toc;
    i = i + 1;
end

disp(times);