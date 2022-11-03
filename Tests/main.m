experimental_data = readmatrix("../data/Haydeeite-Tsub-chiqw.dat");

[experimental_data_matrix, Q_buckets, E_buckets] = create_data_matrix(experimental_data, 150);

figure
experimental_data_plot = surf(Q_buckets, E_buckets, experimental_data_matrix, experimental_data_matrix, 'EdgeColor','none');
c = colorbar;
c.Label.String = 'Intensity';
c.Label.FontSize  = 18;
experiment_data_plot.CDataMapping = 'scaled';
title("Neutron Scattering Data for Haydeeite", 'fontsize', 18)
xlabel("Q (Å)", 'fontsize', 18)
ylabel("E (meV)", 'fontsize', 18)
zlabel("S(Q, ω)")

%set(gca, 'zscale', 'log')

total_intensity_list_experimental = get_total_intensities(Q_buckets, experimental_data_matrix);

%fit_exchange_interactions(total_intensity_list_experimental, Q_buckets);
