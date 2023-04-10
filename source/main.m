% These are parameters that can be changed to control
% aspects of the RMC.
runtimeParameters.Q_centre = 1.0;
runtimeParameters.Q_range = 0.1;
runtimeParameters.acceptanceParameter = 1.0;
runtimeParameters.totalIterations = 25;
runtimeParameters.cutoffEnergy = 0.7;
runtimeParameters.nRand = 5e3;
% If chi squared is less than this value, take the average
% of 3 measurements to try to counteract the randomness
% in powder spectrums.
runtimeParameters.takeAverageCutoff = 0;
% The function that creates the SpinW objects
runtimeParameters.latticeGenerator = @haydeeite;
runtimeParameters.newExchangeFunction = @get_new_haydeeite_exchanges;
runtimeParameters.cutoffIndex = 1;
runtimeParameters.inputEnergy = 5;

% This should correspond to the number of exchange interactions
% input to the lattice generator.
nExchangeParameters = 4;

% The max value the parameters can take - used to generate
% new parameters.
maxInteractionStrength = 5.0;

% This struct has data for monitoring the RMC algorithm.
rmcStats.worstAccepted = 1;
rmcStats.worseAcceptedCount = 0;
rmcStats.worseRejectedCount = 0;
rmcStats.failCount = 0;

%setup_averievite_2_Qs;
setup_haydeeite;

runtimeParameters.maxEnergy = max(runtimeParameters.E_buckets);

% Generate the initial exchange parameters
exchangeInteractions = zeros(1, nExchangeParameters);%rand(1, nExchangeParameters);
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

% history = [originalPowSpecData];
history = zeros([nExchangeParameters, runtimeParameters.totalIterations]);
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
    %newPowSpecData1 = PowSpecData(newInteractions, runtimeParameters);

    % Try calculating a powder spectrum from the new parameters.
    % If it fails, we just repick new parameters.
    try
        newPowSpecData = newPowSpecData.calculatePowderSpectrum();
        %newPowSpecData1 = newPowSpecData1.calculatePowderSpectrumInQRange(0.8, 1.0, 10);
    catch e
        disp("Error: " + e.message);
        rmcStats.failCount = rmcStats.failCount + 1;
        continue;
    end
    %disp(t)

    run_count = run_count + 1;

    newPowSpecData = newPowSpecData.calculateIntensityList();
    newPowSpecData = newPowSpecData.calculateChiSquared(experimentalIntensityList, experimentalError);

    %newPowSpecData1 = newPowSpecData1.calculateIntensityList();
    %newPowSpecData1 = newPowSpecData1.calculateChiSquared(experimentalIntensityList1, experimentalError1);

    newChiSquared = newPowSpecData.getChiSquared();% + newPowSpecData1.getChiSquared();

    chiSquaredDifference = newChiSquared - originalChiSquared

    if chiSquaredDifference < 0
        exchangeInteractions = newInteractions;
        originalPowSpecData = newPowSpecData;
        originalChiSquared = newChiSquared;

        history(:, run_count) = exchangeInteractions;
        chiSquaredHistoryFull(1, run_count) = newChiSquared;
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
            chiSquaredHistoryFull(1, run_count) = newChiSquared;
        else
            rmcStats.worseRejectedCount = rmcStats.worseRejectedCount + 1;
            chiSquaredHistoryFull(1, run_count) = originalPowSpecData.getChiSquared();
        end

    end

end
t = toc