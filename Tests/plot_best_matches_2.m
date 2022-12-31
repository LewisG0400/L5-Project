function plot_best_matches_2(history, experimentalIntensityList, kagome, Q_buckets, Q_centre, Q_range, cutoffEnergy, maxEnergy)
    lowestQValue = Q_buckets(1);
    highestQValue = Q_buckets(end);

    chiSquaredHistory = zeros(size(history, 2), 1);

    for i = 1:size(history, 2)
        chiSquaredHistory(i) = history(i).getChiSquared();
    end

    [bestMatchChiSquareds, bestMatchesIndices] = mink(chiSquaredHistory, 10)

    %disp(bestMatchesIndices)

    for i = 1:10
        powSpecData = history(bestMatchesIndices(i));
        %plot_powder_spectrum_and_intensities(experimentalIntensityList * powSpecData.scaleFactor, powSpecData.getTotalIntensities(), maxEnergy, cutoffEnergy, kagome, lowestQValue, highestQValue, Q_centre, Q_range, bestMatchChiSquareds(i), powSpecData.getExchangeInteractions())
        plot_powder_spectrum_and_intensities(experimentalIntensityList, powSpecData.getTotalIntensities(), maxEnergy, cutoffEnergy, powSpecData.kagome, lowestQValue, highestQValue, Q_centre, Q_range, bestMatchChiSquareds(i, 1), powSpecData.getExchangeInteractions())
    end
end

