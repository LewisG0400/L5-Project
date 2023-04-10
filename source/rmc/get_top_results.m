function top10 = get_top_results(chiSquaredHistory, exchangeHistory, experimentalIntensityList, experimentalErrors, runtimeParameters, n)
    [bestMatchChiSquareds, bestMatchesIndices] = mink(chiSquaredHistory, n);

    size(exchangeHistory(:, bestMatchesIndices))

    top10 = create_powspecdatas_from_exchanges(exchangeHistory(:, bestMatchesIndices), experimentalIntensityList, experimentalErrors, runtimeParameters);
end