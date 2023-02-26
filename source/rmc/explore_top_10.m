function newHistory = explore_top_10(top10, experimentalIntensityList, experimentalError, runtimeParameters)
%exploreAcceptanceParameter = runtimeParameters.acceptanceParameter / 50;
iterations = 50; %runtimeParameters.totalIterations / 50;
explorationHistory = [top10];
for i = 1:size(top10, 2)
    originalPowSpecData = top10(1, i);
    exchangeInteractions = originalPowSpecData.getExchangeInteractions();

    run_count = 0;
    done = false;
    while ~done
        disp(run_count)
        if run_count >= iterations
            break;
        end

        newInteractions = get_new_interactions_close(exchangeInteractions, 2.0);
        newInteractions = runtimeParameters.constraintFunction(newInteractions);
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