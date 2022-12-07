experimental_data = readmatrix("../data/Haydeeite-Tsub-chiqw.dat");

[experimental_data_matrix, Q_buckets, E_buckets] = create_data_matrix(experimental_data, 100, cutoff_energy);
[lower_Q, upper_Q] = get_q_index_range(Q_centre, Q_range, Q_buckets);
experimental_data_matrix = experimental_data_matrix(:, lower_Q:upper_Q);

% figure
% experimental_data_plot = surf(Q_buckets(lower_Q:upper_Q), E_buckets, experimental_data_matrix, experimental_data_matrix, 'EdgeColor', 'none');
% c = colorbar;
% c.Label.String = 'Intensity';
% c.Label.FontSize = 18;
% experiment_data_plot.CDataMapping = 'scaled';
% title("Neutron Scattering Data for Haydeeite", 'fontsize', 18)
% xlabel("Q (Å)", 'fontsize', 18)
% ylabel("E (meV)", 'fontsize', 18)
% zlabel("S(Q, ω)")
% drawnow()

total_intensity_list_experimental = get_total_intensities(experimental_data_matrix, cutoff_index);

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

pow_spec = kagome.powspec(Q_centre - Q_range:0.05:Q_centre + Q_range, 'Evect', E_buckets, 'nRand', 1e3, 'hermit', true, 'imagChk', false);
pow_spec = sw_instrument(pow_spec, 'norm',true, 'dE',0.1, 'dQ',0.05,'Ei',5);
% 
% figure
% sw_plotspec(pow_spec, 'axLim', [0 500], 'colorbar', true)
total_intensity_list_theory = get_total_intensities(pow_spec.swConv, cutoff_index);

%scale_factor = total_intensity_list_experimental(1) / total_intensity_list_theory(1)
scale_factor = max(total_intensity_list_experimental, [], 'all') / max(total_intensity_list_theory, [], 'all')
total_intensity_list_theory = total_intensity_list_theory * scale_factor;

total_intensity_list_experimental(end) = [];

chi_squared = calculate_chi_squared(total_intensity_list_experimental, total_intensity_list_theory);
%plot_total_intensities(total_intensity_list_experimental, total_intensity_list_theory, max(E_buckets), chi_squared, [-3.275, 0, 0.948]);
plot_powder_spectrum_and_intensities(total_intensity_list_experimental, total_intensity_list_theory, max(E_buckets), cutoff_energy, kagome, lowest_Q_value, highest_Q_value, Q_centre, Q_range, chi_squared, [-3.275, 0, 0.948])
