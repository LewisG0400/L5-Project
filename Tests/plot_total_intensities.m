function plot_total_intensities(cropped_energy_experimental, cropped_energy_theory, max_energy, chi_squared, interactions)
    figure
    %subplot(2, 1, 1)
    plot(cropped_energy_experimental)
    hold on
    plot(cropped_energy_theory)
    title("Total Intensity for E" )
    subtitle("Interactions: [" + num2str(interactions) +"], Chi Squared: " + chi_squared)
    xlabel("E (meV)")
    ylabel("Intensity")
    set(gca, 'xtick', linspace(0, size(cropped_energy_experimental, 2), 10), 'xticklabel', linspace(0, max_energy, 10))
    legend('Experimental Data', 'Theoretical Data')
    drawnow()
end