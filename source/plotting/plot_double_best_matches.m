function plot_double_best_matches(history, experimentalIntensityList1, experimentalError1, experimentalIntensityList2, experimentalError2, Q_buckets, Q_centre, Q_range, cutoffEnergy, cutoffIndex, maxEnergy, inputEnergy, EBuckets)
    %lowestQValue = Q_buckets(1);
    %highestQValue = Q_buckets(end);

    [lowestQIndex, highestQIndex] = get_q_index_range(Q_centre, Q_range, Q_buckets);
    lowestQValue = Q_buckets(lowestQIndex);
    highestQValue = Q_buckets(highestQIndex);

    disp(maxEnergy)

    for i = 1:size(history, 2)
        powSpecData = history(i);
        %plot_powder_spectrum_and_intensities(experimentalIntensityList * powSpecData.scaleFactor, powSpecData.getTotalIntensities(), maxEnergy, cutoffEnergy, kagome, lowestQValue, highestQValue, Q_centre, Q_range, bestMatchChiSquareds(i), powSpecData.getExchangeInteractions())
        plot_double_spectrum_and_intensities(experimentalIntensityList1, experimentalError1, experimentalIntensityList2, experimentalError2, powSpecData.getTotalIntensities(), maxEnergy, inputEnergy, cutoffEnergy, powSpecData.lattice, lowestQValue, highestQValue, Q_centre, Q_range, powSpecData.getChiSquared(), powSpecData.getExchangeInteractions(), EBuckets)
    end
end