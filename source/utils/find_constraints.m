latticeGenerator = @averievite;

nExchangeParameters = 5;
maxExchanges = 10.0;

%exchangeInteractions = zeros(nExchangeParameters, 1);
exchangeInteractions = [1.0 -1.0 0 0 4];
valid = zeros(20 * 2, 20 * 2, 20 * 2);

i = 1;
j = 1;
k = 1;
for j3 = -10:0.5:10
    for jd = -10:0.5:10
        for jin = -10:0.5:10
            exchangeInteractions(3) = j3;
            exchangeInteractions(4) = jd;
            exchangeInteractions(5) = jin;

            lattice = latticeGenerator(exchangeInteractions);

            try
                lattice.powspec(0:0.1:0.1, 'Evect', 0:1:1, 'nRand', 100, 'hermit', true, 'imagChk', false, 'fid', 0, 'tid', 0);
                valid(i, j, k) = 1;
            catch e
                valid(i, j, k) = 0;
                disp(e.message);
            end
            k = k + 1;
        end
        k = 0;
        j = j + 1;
    end
    j = 0;
    i = i + 1;
end

scatter3(valid)