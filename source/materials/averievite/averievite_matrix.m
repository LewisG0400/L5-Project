averieviteData = readmatrix("data\Cu5E20T01.txt");
[averieviteIntensities, avierieviteErrors, avQ, avE] = create_averievite_data(averieviteData);
cutoffEnergy = 3;
cutoffIndex = find(avE >= cutoffEnergy, 1, 'first');

[avLowerQ, avUpperQ] = get_q_index_range(1.25, 1.25, avQ);

figure
pcolor(avQ(avLowerQ:avUpperQ), avE(cutoffIndex:end), averieviteIntensities(cutoffIndex:end, avLowerQ:avUpperQ))
colormap(turbo)
    c = colorbar;
    c.Label.String = 'Intensity (mbarn/meV/cell)';
    c.Label.FontSize = 18;
    title("Experimental powder spectrum", 'fontsize', 18)
    xlabel("Momentum transfer (Å^-1)", 'fontsize', 18)
    ylabel("Energy transfer (meV)", 'fontsize', 18)
%colormap(turbo)