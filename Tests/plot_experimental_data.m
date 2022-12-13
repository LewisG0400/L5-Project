function plot_experimental_data(experimental_data_matrix, runtimeParameters, Q_buckets, maxEnergy)
    figure
    experimental_data_plot = surf(Q_buckets, runtimeParameters.E_buckets, experimental_data_matrix, experimental_data_matrix, 'EdgeColor', 'none');
    c = colorbar;
    c.Label.String = 'Intensity';
    c.Label.FontSize = 18;
    experiment_data_plot.CDataMapping = 'scaled';
    title("Neutron Scattering Data for Haydeeite", 'fontsize', 18)
    xlabel("Q (Å)", 'fontsize', 18)
    ylabel("E (meV)", 'fontsize', 18)
    zlabel("S(Q, ω)")
    hold on
    plot([runtimeParameters.Q_centre - runtimeParameters.Q_range, runtimeParameters.Q_centre - runtimeParameters.Q_range], [0 maxEnergy])
    plot([runtimeParameters.Q_centre + runtimeParameters.Q_range, runtimeParameters.Q_centre + runtimeParameters.Q_range], [0 maxEnergy])
    drawnow()
end

