function newHistory = explore_top_10(top10, experimentalIntensityList, experimentalError, runtimeParameters)
iterations = 100; %runtimeParameters.totalIterations / 50;
explorationHistory = top10;
for i = 1:10
    originalPowSpecData = top10(i);
    exchangeInteractions = originalPowSpecData.getExchangeInteractions();

    run_count = 0;
    done = false;
    while ~done
        disp(run_count)
        if run_count >= iterations
            break;
        end

        newInteractions = get_new_interactions_close(exchangeInteractions);
        newInteractions(2) = -newInteractions(1);
        newPowSpecData = PowSpecData(newInteractions, runtimeParameters);

        % Try calculating a powder spectrum from the new parameters.
        % If it fails, we just repick new parameters.
        try
            newPowSpecData = newPowSpecData.calculatePowderSpectrum();
        catch e
            disp("Error: " + e.message);
            continue;
        end

        run_count = run_count + 1;

        newPowSpecData = newPowSpecData.calculateIntensityList();
        newPowSpecData = newPowSpecData.calculateChiSquared(experimentalIntensityList, experimentalError);

        explorationHistory(end + 1) = newPowSpecData;
    end
end
newHistory = explorationHistory;
end