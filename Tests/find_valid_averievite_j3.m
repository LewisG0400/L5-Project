latticeGenerator = @averievite;

exchanges = [-2.4619, 2.4619, 0, -7.7824, 9.0653];
valid = zeros(0, 2);

for j3 = -10:0.1:10
    for jd = -10:0.1:10
        exchanges(3) = j3;
        exchanges(4) = jd;
        lattice = latticeGenerator(exchanges);
    
        try
            lattice.powspec(0:0.1:0.1, 'Evect', 0:0.1:0.1, 'nRand', 100, 'hermit', true, 'imagChk', false, 'fid', 0, 'tid', 0);
            valid(end + 1, :) = [j3, jd];
        catch e
            %disp(e.message);
        end
    end
end

disp(valid);