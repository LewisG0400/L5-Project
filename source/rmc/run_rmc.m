
function [history, chiSquaredHistory] = run_rmc(material, runtimeParameters)
history = zeros([nExchangeParameters, runtimeParameters.totalIterations]);
chiSquaredHistory = zeros(1, runtimeParameters.totalIterations);

exchangeInteractions = material.createExchangEnergies();

run_count = 0;
done = false;
while ~done
    disp(run_count)
    if run_count >= runtimeParameters.totalIterations
        break;
    end

    newInteractions = material.getNewExchangeEnergies(exchangeInteractions);

    newPowSpecData = PowSpecData(newInteractions, runtimeParameters);
    %newPowSpecData1 = PowSpecData(newInteractions, runtimeParameters);

    % Try calculating a powder spectrum from the new parameters.
    % If it fails, we just repick new parameters.
    try
        newPowSpecData = newPowSpecData.calculatePowderSpectrum();
    catch e
        disp("Error: " + e.message);
        rmcStats.failCount = rmcStats.failCount + 1;
        continue;
    end
    %disp(t)

    run_count = run_count + 1;

    newPowSpecData = newPowSpecData.calculateIntensityList();
    newPowSpecData = newPowSpecData.calculateChiSquared(experimentalIntensityList, experimentalError);

    newChiSquared = newPowSpecData.getChiSquared();% + newPowSpecData1.getChiSquared();

    chiSquaredDifference = newChiSquared - originalChiSquared

    if chiSquaredDifference < 0
        exchangeInteractions = newInteractions;
        originalPowSpecData = newPowSpecData;
        originalChiSquared = newChiSquared;

        history(:, run_count) = exchangeInteractions;
        chiSquaredHistory(1, run_count) = newChiSquared;
    else
        % We accept a certain number of moves with a probability proportional
        % to the difference in chi squared.
        acceptanceProbability = min(1, exp(-chiSquaredDifference * runtimeParameters.acceptanceParameter))

        if rand() < acceptanceProbability
            rmcStats.worseAcceptedCount = rmcStats.worseAcceptedCount + 1;
            if acceptanceProbability < rmcStats.worstAccepted
                rmcStats.worstAccepted = acceptanceProbability;
            end

            exchangeInteractions = newInteractions;
            originalPowSpecData = newPowSpecData;
            originalChiSquared = newChiSquared;

            history(:, run_count) = exchangeInteractions;
            chiSquaredHistory(1, run_count) = newChiSquared;
        else
            rmcStats.worseRejectedCount = rmcStats.worseRejectedCount + 1;
            chiSquaredHistory(1, run_count) = originalPowSpecData.getChiSquared();
        end

    end

end
end