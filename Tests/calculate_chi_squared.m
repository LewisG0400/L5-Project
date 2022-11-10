% Calculates the chi squared value between 2 lists of energies.
function chi_squared = calculate_chi_squared(total_energies_experimental, total_energies_theory)
    plotting = false;

    if plotting
    figure
    subplot(2, 1, 1)
    plot(cropped_energy_experimental)
    title("Total Intensity for Q (experimental data)")
    xlabel("Q (Å)")
    ylabel("Intensity")
    set(gca, 'xtick', 1:2:q_max_index-q_min_index)
    set(gca, 'xticklabel', q_centre-q_range:0.02:q_centre+q_range)
    subplot(2, 1, 2)
    plot(cropped_energy_theory)
    title("Total Intensity for Q (theoretical data)")
    xlabel("Q (Å)")
    ylabel("Intensity")
    set(gca, 'xtick', 1:2:q_max_index-q_min_index)
    set(gca, 'xticklabel', q_centre-q_range:0.02:q_centre+q_range)
    end
    
    chi_squared = sum(total_energies_experimental - total_energies_theory)^2;
end