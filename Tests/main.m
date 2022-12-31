% These are parameters that can be changed to control
% aspects of the RMC.
runtimeParameters.Q_centre = 0.5;
runtimeParameters.Q_range = 0.05;
runtimeParameters.acceptanceParameter = 2.0;
runtimeParameters.totalIterations = 50000;
runtimeParameters.n_E_buckets = 100;
runtimeParameters.nQBuckets = 0;
runtimeParameters.cutoffEnergy = 0.7;
runtimeParameters.nRand = 10e3;
% If chi squared is less than this value, take the average
% of 3 measurements to try to counteract the randomness
% in powder spectrums.
runtimeParameters.takeAverageCutoff = 0.075;

% This struct has data for monitoring the RMC algorithm.
rmcStats.worstAccepted = 1;
rmcStats.worseAcceptedCount = 0;
rmcStats.worseRejectedCount = 0;
rmcStats.failCount = 0;

% Load in the experimental data
experimental_data = readmatrix("../data/Haydeeite-Tsub-chiqw.dat");

% Convert it into a useable form.
[experimental_data_matrix, Q_buckets, runtimeParameters.E_buckets] = create_data_matrix(experimental_data, runtimeParameters.n_E_buckets, runtimeParameters.cutoffEnergy);
maxEnergy = max(experimental_data(:, 2));
runtimeParameters.cutoffIndex = find(runtimeParameters.E_buckets >= runtimeParameters.cutoffEnergy, 1, 'first');

plot_experimental_data(experimental_data_matrix, runtimeParameters, Q_buckets, maxEnergy);

[lower_Q, upper_Q] = get_q_index_range(runtimeParameters.Q_centre, runtimeParameters.Q_range, Q_buckets);
experimental_data_matrix = experimental_data_matrix(:, lower_Q:upper_Q);
runtimeParameters.nQBuckets = upper_Q - lower_Q;

experimentalIntensityList = get_total_intensities(experimental_data_matrix, runtimeParameters.cutoffIndex);
experimentalIntensityList(end) = [];
%experimentalIntensityList = experimentalIntensityList * (1.0 / max(experimentalIntensityList));

% Set up the kagome lattice structure
[kagome, exchangeInteractions] = create_spinw_kagome(4);

% Calculate the spin wave dispersion of the lattice with the
% iniital parameters. Throws some error if the Hamiltonian is not
% positive definite, so we need to catch those cases and change
% the exchange interactions again.
originalPowSpecData = PowSpecData(exchangeInteractions, kagome, runtimeParameters);
valid = false;

while ~valid
    try
        originalPowSpecData = originalPowSpecData.calculatePowderSpectrum();

        valid = true;
    catch e
        disp("Error: " + e.message);

        exchangeInteractions = rand(1, 4) * 10 - 5;

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

        history(end + 1) = newPowSpecData;
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

            history(end + 1) = newPowSpecData;
        else
            rmcStats.worseRejectedCount = rmcStats.worseRejectedCount + 1;
        end

    end

end

[chiSquaredHistory, interactionHistory, intensityHistory] = separate_history(history, experimentalIntensityList);

plot_chi_squared_history(chiSquaredHistory);
plot_best_matches_2(history, experimentalIntensityList, kagome, Q_buckets, runtimeParameters.Q_centre, runtimeParameters.Q_range, runtimeParameters.cutoffEnergy, maxEnergy);
%plot_best_matches_2(history, experimentalIntensityList, kagome, Q_buckets, runtimeParameters.Q_centre, runtimeParameters.Q_range, runtimeParameters.cutoffEnergy, maxEnergy);


%plot_exchanges_on_param_space(chi_squareds, interaction_history, best_match_chi_squareds, best_matches_indices);
%save("../results/with_j2_NaN-fixed/" + total_iterations + "_" + regexprep(num2str(acceptance_parameter), '\.', '-') + "_no-steps_range0-05_centre_0-5_1")