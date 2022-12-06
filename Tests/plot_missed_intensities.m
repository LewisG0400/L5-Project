% for i = 1:10
%     plot_total_intensities(total_intensity_list_experimental, intensity_history(best_matches_indices(i), :), max_energy, chi_squared_history(best_matches_indices(i)), interaction_history(best_matches_indices(i), :));
% end

for i = 1:10
    %plot_total_intensities(total_intensity_list_experimental, intensity_history(best_matches_indices(i), :), max_energy, chi_squared_history(best_matches_indices(i)), interaction_history(best_matches_indices(i), :));
    %plot_powder_spectrum(interaction_history(best_matches_indices(i), :), chi_squared_history(best_matches_indices(i)), kagome, lowest_Q_value, highest_Q_value, max_energy);
    plot_powder_spectrum_and_intensities(total_intensity_list_experimental, intensity_history(best_matches_indices(i), :), max_energy, kagome, lowest_Q_value, highest_Q_value, chi_squared_history(best_matches_indices(i)), interaction_history(best_matches_indices(i), :))
end