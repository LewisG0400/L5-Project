function newHistory = explore_top_10(top10, experimentalIntensityList, experimentalError, targetThetaW, runtimeParameters)
%exploreAcceptanceParameter = runtimeParameters.acceptanceParameter / 50;
iterations = 250; %runtimeParameters.totalIterations / 50;
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
        run_count = run_count + 1;

        newInteractions = get_new_interactions_close(exchangeInteractions, 1.0);
        newPowSpecData = PowSpecData(newInteractions, runtimeParameters);

        newPowSpecData = newPowSpecData.calculateWeissTemperature(1/2);

        if abs(targetThetaW - newPowSpecData.getWeissTemperature()) > 20.0
            continue;
        end

        % Try calculating a powder spectrum from the new parameters.
        % If it fails, we just repick new parameters.
        try
            newPowSpecData = newPowSpecData.calculatePowderSpectrum();
        catch e
            disp("Error: " + e.message);
            continue;
        end

        newPowSpecData = newPowSpecData.calculateIntensityList();
        newPowSpecData = newPowSpecData.calculateChiSquared(experimentalIntensityList, experimentalError);

        explorationHistory(end + 1) = newPowSpecData;
    end
end
newHistory = explorationHistory;
end