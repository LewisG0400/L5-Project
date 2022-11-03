% Calculates the chi squared value between 2 lists of energies.
function chi_squared = calculate_chi_squared(total_energies_experimental, total_energies_theory, q_centre, q_range, Q_buckets)
    [q_min_index, q_max_index] = get_q_index_range(q_centre, q_range, Q_buckets);

    cropped_energy_experimental = total_energies_experimental(q_min_index:q_max_index);
    cropped_energy_theory = total_energies_theory(q_min_index:q_max_index);

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
    
    chi_squared = sum(cropped_energy_experimental - cropped_energy_theory)^2;
end