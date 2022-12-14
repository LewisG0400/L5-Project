kagome = spinw;
kagome.genlattice('lat_const', [6 6 10], 'angled', [90 90 120], 'spgr', 'P -3')
kagome.addatom('r', [1/2 0 0], 'S', 1/2, 'label', 'MCu1', 'color', 'r')

kagome.gencoupling('maxDistance', 7)

% Set up exchange interactions over the lattice.
kagome.addmatrix('label', 'J1', 'value', -3.275, 'color', 'r')
kagome.addmatrix('label', 'J2', 'value', 0, 'color', 'g')
kagome.addmatrix('label', 'Jd', 'value', 0.948, 'color', 'b')
kagome.addcoupling('mat', 'J1', 'bond', 1)
kagome.addcoupling('mat', 'J2', 'bond', 2)
kagome.addcoupling('mat', 'Jd', 'bond', 4)

% Generate lattice spins
mgIR = [1 1 1
    0 0 0
    0 0 0];
kagome.genmagstr('mode', 'direct', 'nExt', [1 1 1], 'unit', 'lu', 'n', [0 0 1], 'S', mgIR, 'k', [0 0 0]);

% This is 10 values for nRand, storing nRand, average time taken, average chi
% squared, chi squared standard deviation
sw_nRand_param_data = zeros([10, 4]);

tic
for i = 1:10

    loop_chi_squareds = zeros([5 1]);
    loop_times = zeros([5 1]);

    nRand_value = 50 * i * 1e3;
    
    for j = 1:5

        tic
        sw_pow_spec = kagome.powspec(Q_centre - Q_range:0.05:Q_centre + Q_range, 'Evect', E_buckets, 'nRand', nRand_value, 'hermit', true, 'imagChk', false);

        sw_pow_spec = sw_instrument(sw_pow_spec, 'norm',true, 'dE',0.1, 'dQ',0.05,'Ei',5);

        pow_spec_time_taken = toc

        loop_times(j) = pow_spec_time_taken;

        sw_intensities = get_total_intensities(sw_pow_spec.swConv, cutoff_index);

        scale_factor = max(total_intensity_list_experimental, [], 'all') / max(sw_intensities, [], 'all');
        sw_intensities = sw_intensities * scale_factor;

        sw_chi_squared = calculate_chi_squared(total_intensity_list_experimental, sw_intensities);

        loop_chi_squareds(j) = sw_chi_squared;
    end

    mean_time_taken = mean(loop_times);
    mean_chi_squared = mean(loop_chi_squareds);
    sd_chi_squared = std(loop_chi_squareds);

    sw_nRand_param_data(i, 1) = nRand_value;
    sw_nRand_param_data(i, 2) = mean_time_taken;
    sw_nRand_param_data(i, 3) = mean_chi_squared;
    sw_nRand_param_data(i, 4) = sd_chi_squared

    % plot_total_intensities(total_intensity_list_experimental, sw_intensities, 2.5, sw_chi_squared, [-3.275, 0, 0.948]);
end
toc