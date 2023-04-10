function plot_experimental_data(experimental_data_matrix, runtimeParameters, Q_buckets, maxEnergy)
    figure
    experimental_data_plot = pcolor(Q_buckets, runtimeParameters.E_buckets, experimental_data_matrix);
    colormap(turbo)
    c = colorbar;
    c.Label.String = 'Intensity (mbarn/meV/cell)';
    c.Label.FontSize = 18;
    experiment_data_plot.CDataMapping = 'scaled';
    title("Experimental powder spectrum", 'fontsize', 18)
    xlabel("Momentum transfer (Å^-1)", 'fontsize', 18)
    ylabel("Energy transfer (meV)", 'fontsize', 18)
    zlabel("S(Q, ω)")
    hold on
    plot([runtimeParameters.Q_centre - runtimeParameters.Q_range, runtimeParameters.Q_centre - runtimeParameters.Q_range], [0 maxEnergy])
    plot([runtimeParameters.Q_centre + runtimeParameters.Q_range, runtimeParameters.Q_centre + runtimeParameters.Q_range], [0 maxEnergy])
    drawnow()
end

