experimental_data = readmatrix("../data/Haydeeite-Tsub-chiqw.dat");

[experimental_data_matrix, Q_buckets, E_buckets] = create_data_matrix(experimental_data, 100);
[lower_Q, upper_Q] = get_q_index_range(Q_centre, Q_range, Q_buckets);
experimental_data_matrix = experimental_data_matrix(:, lower_Q:upper_Q);

Q_centre = 0.5;
Q_range = 0.05;

total_intensity_list_experimental = get_total_intensities(Q_buckets, experimental_data_matrix);

kagome = spinw;
kagome.genlattice('lat_const', [6 6 10], 'angled', [90 90 120], 'spgr', 'P -3')
kagome.addatom('r', [1/2 0 0], 'S', 1/2, 'label', 'MCu1', 'color', 'r')

kagome.gencoupling('maxDistance', 7)

% Set up exchange interactions over the lattice.
kagome.addmatrix('label', 'J1', 'value', 0, 'color', 'r')
kagome.addmatrix('label', 'J2', 'value', 0, 'color', 'g')
kagome.addmatrix('label', 'Jd', 'value', 0, 'color', 'b')
kagome.addcoupling('mat', 'J1', 'bond', 1)
kagome.addcoupling('mat', 'J2', 'bond', 2)
kagome.addcoupling('mat', 'Jd', 'bond', 4)

% Generate lattice spins
mgIR = [1 1 1
    0 0 0
    0 0 0];
kagome.genmagstr('mode', 'direct', 'nExt', [1 1 1], 'unit', 'lu', 'n', [0 0 1], 'S', mgIR, 'k', [0 0 0]);

chi_squareds = zeros([100 100]);

i = 1;
j = 1;
for j1 = -5.0:0.1:5.0
    j = 1;
    for jd = -5.0:0.1:5.0
        kagome.setmatrix('mat', 1, 'pref', j1);
        kagome.setmatrix('mat', 3, 'pref', jd);

        % Try calculating a powder spectrum from the new parameters.
        % If it fails, we just repick new parameters.
        try
            new_pow_spec = kagome.powspec(Q_centre - Q_range:0.01:Q_centre + Q_range, 'Evect', E_buckets, 'nRand', 1e3, 'hermit', true, 'imagChk', false, 'fid', 0, 'tid', 0);
        catch e
            %disp("Error: " + e.message);
            chi_squareds(i, j) = 10;
            j = j+1;
            continue;
        end

        new_total_intensity_list = get_total_intensities(new_pow_spec.hklA, new_pow_spec.swConv);

        chi_squared = calculate_chi_squared(total_intensity_list_experimental, new_total_intensity_list, E_buckets);
        chi_squareds(i, j) = chi_squared;
        j = j+1;
    end
    i = i+1;
end

figure
surf(-5.0:0.1:5.0, -5.0:0.1:5.0, chi_squareds, chi_squareds);
xlabel('J1 (meV)');
ylabel('Jd (meV)');