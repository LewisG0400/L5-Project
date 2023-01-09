% These are parameters that can be changed to control
% aspects of the RMC.
runtimeParameters.Q_centre = 0.5;
runtimeParameters.Q_range = 0.05;
runtimeParameters.acceptanceParameter = 2.0;
runtimeParameters.totalIterations = 100;
runtimeParameters.n_E_buckets = 50;
runtimeParameters.nQBuckets = 0;
runtimeParameters.cutoffEnergy = 0.7;
runtimeParameters.nRand = 1e3;
% If chi squared is less than this value, take the average
% of 3 measurements to try to counteract the randomness
% in powder spectrums.
runtimeParameters.takeAverageCutoff = 0.075;
% The function that creates the SpinW objects
runtimeParameters.latticeGenerator = @averievite;

% This should correspond to the number of exchange interactions
% input to the lattice generator.
nExchangeParameters = 4;

% The max value the parameters can take - used to generate
% new parameters.
maxInteractionStrength = 10.0;

% This struct has data for monitoring the RMC algorithm.
rmcStats.worstAccepted = 1;
rmcStats.worseAcceptedCount = 0;
rmcStats.worseRejectedCount = 0;
rmcStats.failCount = 0;

setup_averievite;

% Generate the initial exchange parameters
exchangeInteractions = rand(1, nExchangeParameters);

% Calculate the spin wave dispersion of the lattice with the
% iniital parameters. Throws some error if the Hamiltonian is not
% positive definite, so we need to catch those cases and change
% the exchange interactions again.
originalPowSpecData = PowSpecData(exchangeInteractions, runtimeParameters);
valid = false;

while ~valid
    try
        originalPowSpecData = originalPowSpecData.calculatePowderSpectrum();

        valid = true;
    catch e
        disp("Error: " + e.message);

        exchangeInteractions = rand(1, nExchangeParameters) * (maxInteractionStrength * 2) - maxInteractionStrength;

        originalPowSpecData = originalPowSpecData.setExchangeInteractions(exchangeInteractions);
        disp(exchangeInteractions);
    end
end

originalPowSpecData = originalPowSpecData.calculateIntensityList();
originalPowSpecData = originalPowSpecData.calculateChiSquared(experimentalIntensityList);

history = [originalPowSpecData];

run_count = 0;
done = false;
while ~done
    disp(run_count)
    if run_count >= runtimeParameters.totalIterations
        break;
    end

    newInteractions = get_new_interactions(exchangeInteractions, maxInteractionStrength);
    newPowSpecData = PowSpecData(newInteractions, runtimeParameters);

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

    chiSquaredDifference = newPowSpecData.getChiSquared() - originalPowSpecData.getChiSquared()

    if chiSquaredDifference < 0
        exchangeInteractions = newInteractions;
        originalPowSpecData = newPowSpecData;

        history(end + 1) = newPowSpecData;
    else
        % We accept a certain number of moves with a probability proportional
        % to the difference in chi squared.
        acceptanceProbability = min(1, exp(-chiSquaredDifference / runtimeParameters.acceptanceParameter))

        if rand() < acceptanceProbability
            rmcStats.worseAcceptedCount = rmcStats.worseAcceptedCount + 1;
            if acceptanceProbability < rmcStats.worstAccepted
                rmcStats.worstAccepted = acceptanceProbability;
            end

            exchangeInteractions = newInteractions;
            originalPowSpecData = newPowSpecData;

            history(end + 1) = newPowSpecData;
        else
            rmcStats.worseRejectedCount = rmcStats.worseRejectedCount + 1;
        end

    end

end

[chiSquaredHistory, interactionHistory, intensityHistory] = separate_history(history, experimentalIntensityList);

plot_chi_squared_history(chiSquaredHistory);

top10 = get_top_10_results(history);
newHistory = explore_top_10(top10, experimentalIntensityList, runtimeParameters);
newTop10 = get_top_10_results(newHistory);

plot_best_matches_2(newTop10, experimentalIntensityList, Q_buckets, runtimeParameters.Q_centre, runtimeParameters.Q_range, runtimeParameters.cutoffEnergy, maxEnergy);

%save("../results/with_j2_NaN-fixed/" + total_iterations + "_" + regexprep(num2str(acceptance_parameter), '\.', '-') + "_no-steps_range0-05_centre_0-5_1")