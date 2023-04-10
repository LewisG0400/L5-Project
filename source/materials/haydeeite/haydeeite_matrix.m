haydeeiteData = readmatrix("data\Haydeeite-Tsub-chiqw.dat");
[haydeeiteIntensities, haydeeiteErrors, hayQ, hayE] = create_haydeeite_data_matrix(haydeeiteData);
cutoffEnergy = 0.4;
cutoffIndex = find(hayE >= cutoffEnergy, 1, 'first');

[avLowerQ, avUpperQ] = get_q_index_range(1.25, 1.25, hayQ);

figure
pcolor(hayQ, hayE(cutoffIndex:end), haydeeiteIntensities(cutoffIndex:end, :))
colormap(turbo)
    c = colorbar;
    c.Label.String = 'Intensity (mbarn/meV/cell)';
    c.Label.FontSize = 18;
    title("Experimental powder spectrum", 'fontsize', 18)
    xlabel("Momentum transfer (Å^-1)", 'fontsize', 18)
    ylabel("Energy transfer (meV)", 'fontsize', 18)
%colormap(turbo)