% These are parameters that can be changed to control
% aspects of the RMC.
runtimeParameters.Q_centre = 1.5;
runtimeParameters.Q_range = 0.1;
runtimeParameters.acceptanceParameter = 0.15e4;
runtimeParameters.totalIterations = 20000;
runtimeParameters.cutoffEnergy = 3;
runtimeParameters.nRand = 5e3;
% If chi squared is less than this value, take the average
% of 3 measurements to try to counteract the randomness
% in powder spectrums.
runtimeParameters.takeAverageCutoff = 0;
% The function that creates the SpinW objects
runtimeParameters.latticeGenerator = @averievite;
runtimeParameters.newExchangeFunction = @get_new_averievite_exchanges;
runtimeParameters.cutoffIndex = 1;
runtimeParameters.inputEnergy = 20.4;

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

setup_averievite_2_Qs;

runtimeParameters.maxEnergy = max(runtimeParameters.E_buckets);

% Generate the initial exchange parameters
exchangeInteractions = rand(1, nExchangeParameters);
originalChiSquared = Inf;

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
        %disp("Error: " + e.message);
        disp(getReport(e, 'extended'));

        exchangeInteractions = runtimeParameters.newExchangeFunction(exchangeInteractions);

        originalPowSpecData = originalPowSpecData.setExchangeInteractions(exchangeInteractions);
        disp(exchangeInteractions);
    end
end

history = [originalPowSpecData];
chiSquaredHistoryFull = zeros(1, runtimeParameters.totalIterations);

tic;
run_count = 0;
done = false;
while ~done
    disp(run_count)
    if run_count >= runtimeParameters.totalIterations
        break;
    end

    newInteractions = runtimeParameters.newExchangeFunction(exchangeInteractions);

    newPowSpecData = PowSpecData(newInteractions, runtimeParameters);
    newPowSpecData1 = PowSpecData(newInteractions, runtimeParameters);

    % Try calculating a powder spectrum from the new parameters.
    % If it fails, we just repick new parameters.
    try
        newPowSpecData = newPowSpecData.calculatePowderSpectrum();
        newPowSpecData1 = newPowSpecData1.calculatePowderSpectrumInQRange(0.8, 1.0, 10);
    catch e
        disp("Error: " + e.message);
        rmcStats.failCount = rmcStats.failCount + 1;
        continue;
    end
    %disp(t)

    run_count = run_count + 1;

    newPowSpecData = newPowSpecData.calculateIntensityList();
    newPowSpecData = newPowSpecData.calculateChiSquared(experimentalIntensityList, experimentalError);

    newPowSpecData1 = newPowSpecData1.calculateIntensityList();
    newPowSpecData1 = newPowSpecData1.calculateChiSquared(experimentalIntensityList1, experimentalError1);

    newChiSquared = newPowSpecData.getChiSquared() + newPowSpecData1.getChiSquared();

    chiSquaredDifference = newChiSquared - originalChiSquared;

    if chiSquaredDifference < 0
        exchangeInteractions = newInteractions;
        originalPowSpecData = newPowSpecData;
        originalChiSquared = newChiSquared;

        history(end + 1) = newPowSpecData;
        chiSquaredHistoryFull(1, run_count) = newChiSquared;
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
            originalChiSquared = newChiSquared;

            history(end + 1) = newPowSpecData;
            chiSquaredHistoryFull(1, run_count) = newChiSquared;
        else
            rmcStats.worseRejectedCount = rmcStats.worseRejectedCount + 1;
            chiSquaredHistoryFull(1, run_count) = originalPowSpecData.getChiSquared();
        end

    end

end
t = toc

% [chiSquaredHistory, interactionHistory, intensityHistory] = separate_history(history, experimentalIntensityList);
% 
% load("data\chi_squareds_sw_instrument.mat");
% 
% [top10ChiSquared, top10Indices] = mink(chiSquaredHistory, 10);
% plot_exchanges_on_param_space(chi_squareds, interactionHistory, top10ChiSquared, top10Indices);

% plot_chi_squared_history(chiSquaredHistoryFull);
% 
top10 = get_top_10_results(history);
plot_best_matches_2(top10, experimentalIntensityList, experimentalError, [0 2.5], runtimeParameters.Q_centre, runtimeParameters.Q_range, runtimeParameters.cutoffEnergy, runtimeParameters.maxEnergy, runtimeParameters.inputEnergy);
% 
disp("Top 10:")
for i = 1:20
    disp("    Exchange Energies: [" + num2str(top10(i).getExchangeInteractions) + "]" + ", Chi Squared: " + num2str(top10(i).getChiSquared()));
end
newHistory = explore_top_10(top10, experimentalIntensityList, experimentalError, runtimeParameters);
newTop10 = get_top_10_results(newHistory);
% 
plot_best_matches_2(newTop20, experimentalIntensityList, experimentalError, [0 2.5], runtimeParameters.Q_centre, runtimeParameters.Q_range, runtimeParameters.cutoffEnergy, runtimeParameters.maxEnergy, runtimeParameters.inputEnergy);
%   
disp("New Top 10:")
for i = 1:20
    disp("    Exchange Energies: [" + num2str(newTop20(i).getExchangeInteractions) + "]" + ", Chi Squared: " + num2str(newTop20(i).getChiSquared()));
end

%save("../results/with_j2_NaN-fixed/" + total_iterations + "_" + regexprep(num2str(acceptance_parameter), '\.', '-') + "_no-steps_range0-05_centre_0-5_1")