% These are parameters that can be changed to control
% aspects of the RMC.
runtimeParameters.Q_centre = 1.5;
runtimeParameters.Q_range = 0.1;
runtimeParameters.acceptanceParameter = 10e4;
runtimeParameters.totalIterations = 5000;
runtimeParameters.n_E_buckets = 30;
runtimeParameters.nQBuckets = 0;
runtimeParameters.cutoffEnergy = 5;
runtimeParameters.nRand = 2.5e3;
% If chi squared is less than this value, take the average
% of 3 measurements to try to counteract the randomness
% in powder spectrums.
runtimeParameters.takeAverageCutoff = 0;
% The function that creates the SpinW objects
runtimeParameters.latticeGenerator = @averievite;
runtimeParameters.cutoffIndex = 1;

% This should correspond to the number of exchange interactions
% input to the lattice generator.
nExchangeParameters = 6;

% The max value the parameters can take - used to generate
% new parameters.
maxInteractionStrength = 10.0;

% This struct has data for monitoring the RMC algorithm.
rmcStats.worstAccepted = 1;
rmcStats.worseAcceptedCount = 0;
rmcStats.worseRejectedCount = 0;
rmcStats.failCount = 0;

setup_averievite;

runtimeParameters.maxEnergy = max(runtimeParameters.E_buckets);

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
        %disp(getReport(e, 'extended'));

        exchangeInteractions = rand(1, nExchangeParameters) * (maxInteractionStrength * 2) - maxInteractionStrength;
        exchangeInteractions(2) = -exchangeInteractions(1);
        exchangeInteractions(6) = -exchangeInteractions(3);

        originalPowSpecData = originalPowSpecData.setExchangeInteractions(exchangeInteractions);
        disp(exchangeInteractions);
    end
end

originalPowSpecData = originalPowSpecData.calculateIntensityList();
originalPowSpecData = originalPowSpecData.calculateChiSquared(experimentalIntensityList, experimentalError);

history = [originalPowSpecData];

run_count = 0;
done = false;
while ~done
    disp(run_count)
    if run_count >= runtimeParameters.totalIterations
        break;
    end

    newInteractions = get_new_interactions(exchangeInteractions, maxInteractionStrength);
    newInteractions(2) = -newInteractions(1);
    newInteractions(6) = -newInteractions(3);

    newPowSpecData = PowSpecData(newInteractions, runtimeParameters);

    % Try calculating a powder spectrum from the new parameters.
    % If it fails, we just repick new parameters.
    tic
    try
        newPowSpecData = newPowSpecData.calculatePowderSpectrum();
    catch e
        disp("Error: " + e.message);
        rmcStats.failCount = rmcStats.failCount + 1;
        continue;
    end
    t = toc;
    disp(t)

    run_count = run_count + 1;

    newPowSpecData = newPowSpecData.calculateIntensityList();
    newPowSpecData = newPowSpecData.calculateChiSquared(experimentalIntensityList, experimentalError);

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
plot_best_matches_2(top10, experimentalIntensityList, experimentalError, [0 2.5], runtimeParameters.Q_centre, runtimeParameters.Q_range, runtimeParameters.cutoffEnergy, 15);

disp("Top 10:")
for i = 1:10
    disp("    Exchange Energies: [" + num2str(top10(i).getExchangeInteractions) + "]" + ", Chi Squared: " + num2str(top10(i).getChiSquared()));
end
newHistory = explore_top_10(top10, experimentalIntensityList, experimentalError, runtimeParameters);
newTop10 = get_top_10_results(newHistory);

plot_best_matches_2(newTop10, experimentalIntensityList, experimentalError, [0 2.5], runtimeParameters.Q_centre, runtimeParameters.Q_range, runtimeParameters.cutoffEnergy, 15);

disp("New Top 10:")
for i = 1:10
    disp("    Exchange Energies: [" + num2str(newTop10(i).getExchangeInteractions) + "]" + ", Chi Squared: " + num2str(newTop10(i).getChiSquared()));
end

%save("../results/with_j2_NaN-fixed/" + total_iterations + "_" + regexprep(num2str(acceptance_parameter), '\.', '-') + "_no-steps_range0-05_centre_0-5_1")