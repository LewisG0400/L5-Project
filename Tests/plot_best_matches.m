function plot_best_matches(chiSquaredHistory, interactionHistory, intensityHistory, experimentalIntensityList, kagome, Q_buckets, Q_centre, Q_range, cutoffEnergy, maxEnergy)
    lowestQValue = Q_buckets(1);
    highestQValue = Q_buckets(end);
    [bestMatchChiSquareds, bestMatchesIndices] = mink(chiSquaredHistory, 10);

    %disp(bestMatchesIndices)

    for i = 1:10
        %plot_total_intensities(total_intensity_list_experimental, intensity_history(best_matches_indices(i), :), max_energy, chi_squared_history(best_matches_indices(i)), interaction_history(best_matches_indices(i), :));
        %plot_powder_spectrum(interaction_history(best_matches_indices(i), :), chi_squared_history(best_matches_indices(i)), kagome, lowest_Q_value, highest_Q_value, max_energy);
        disp(interactionHistory(bestMatchesIndices(i), :))
        plot_powder_spectrum_and_intensities(experimentalIntensityList, intensityHistory(bestMatchesIndices(i), :), maxEnergy, cutoffEnergy, kagome, lowestQValue, highestQValue, Q_centre, Q_range, bestMatchChiSquareds(i), interactionHistory(bestMatchesIndices(i), :))
    end
end

