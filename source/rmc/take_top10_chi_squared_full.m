function chiSquareds = take_top10_chi_squared_full(top10, experimentalDataMatrix, QBuckets, QCentre, QRange, runtimeParameters)
    chiSquareds = zeros(1, 10);
    [lowerQ, upperQ] = get_q_index_range(QCentre, QRange, QBuckets);
    experimentalDataMatrixCropped = experimentalDataMatrix(:, lowerQ:upperQ);

    plot_experimental_data(experimentalDataMatrixCropped, runtimeParameters, QBuckets(lowerQ:upperQ), 2.5);
    
    for i = 1:10
        top10(1, i).runtimeParameters= runtimeParameters;
        top10(1, i) = top10(1, i).calculatePowderSpectrumInQRange(QCentre - QRange, QCentre + QRange, size(experimentalDataMatrixCropped, 2));
        figure
        sw_plotspec(top10(1, i).powderSpectrumFull);
        top10(1, i) = top10(1, i).calculateMatrixChiSquared(experimentalDataMatrixCropped);
        chiSquareds(1, i) = top10(1, i).getMatrixChiSquared();
    end
end