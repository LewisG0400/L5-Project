function plot_best_matches_2(history, experimentalIntensityList, Q_buckets, Q_centre, Q_range, cutoffEnergy, maxEnergy)
    lowestQValue = Q_buckets(1);
    highestQValue = Q_buckets(end);

    disp(maxEnergy)

    for i = 1:10
        powSpecData = history(i);
        %plot_powder_spectrum_and_intensities(experimentalIntensityList * powSpecData.scaleFactor, powSpecData.getTotalIntensities(), maxEnergy, cutoffEnergy, kagome, lowestQValue, highestQValue, Q_centre, Q_range, bestMatchChiSquareds(i), powSpecData.getExchangeInteractions())
        plot_powder_spectrum_and_intensities(experimentalIntensityList, powSpecData.getTotalIntensities(), maxEnergy, cutoffEnergy, powSpecData.lattice, lowestQValue, highestQValue, Q_centre, Q_range, powSpecData.getChiSquared(), powSpecData.getExchangeInteractions())
    end
end

