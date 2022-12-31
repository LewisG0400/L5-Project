function explore_top_10(top10)
explorationHistory = top10;
for i = 1:10
    originalPowSpecData = top10(i);

    run_count = 0;
    done = false;
    while ~done
        disp(run_count)
        if run_count >= runtimeParameters.totalIterations
            break;
        end

        newInteractions = get_new_interactions(exchangeInteractions);
        newPowSpecData = PowSpecData(newInteractions, kagome, runtimeParameters);

        % Try calculating a powder spectrum from the new parameters.
        % If it fails, we just repick new parameters.
        try
            newPowSpecData = newPowSpecData.calculatePowderSpectrum();
        catch e
            disp("Error: " + e.message);
            rmcStats.failCount = rmcStats.failCount + 1;
            continue;
        end

        run_count = run_count + 1;

        newPowSpecData = newPowSpecData.calculateIntensityList();
        newPowSpecData = newPowSpecData.calculateChiSquared(experimentalIntensityList);

        chi_squared_difference = newPowSpecData.getChiSquared() - originalPowSpecData.getChiSquared()

        if chi_squared_difference < 0
            exchangeInteractions = newInteractions;
            originalPowSpecData = newPowSpecData;

            explorationHistory(end + 1) = newPowSpecData;
        else
            % We accept a certain number of moves with a probability proportional
            % to the difference in chi squared.
            acceptanceProbability = min(1, exp(-chi_squared_difference / runtimeParameters.acceptanceParameter))

            if rand() < acceptanceProbability
                rmcStats.worseAcceptedCount = rmcStats.worseAcceptedCount + 1;
                if acceptanceProbability < rmcStats.worstAccepted
                    rmcStats.worstAccepted = acceptanceProbability;
                end

                exchangeInteractions = newInteractions;
                originalPowSpecData = newPowSpecData;

                explorationHistory(end + 1) = newPowSpecData;
            else
                rmcStats.worseRejectedCount = rmcStats.worseRejectedCount + 1;
            end

        end

    end
end
end