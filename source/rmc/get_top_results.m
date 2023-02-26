function top10 = get_top_results(history, n)
    chiSquaredHistory = zeros(size(history, 2), 1);

    for i = 1:size(history, 2)
        chiSquaredHistory(i) = history(i).getChiSquared();
    end

    [bestMatchChiSquareds, bestMatchesIndices] = mink(chiSquaredHistory, n);

    top10 = history(bestMatchesIndices);
end