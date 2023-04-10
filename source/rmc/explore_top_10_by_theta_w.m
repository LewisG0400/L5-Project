function [newHistory, newWeissHistory] = explore_top_10_by_theta_w(top10)
%exploreAcceptanceParameter = runtimeParameters.acceptanceParameter / 50;
iterations = 250; %runtimeParameters.totalIterations / 50;
explorationHistory = zeros(size(top10(1).exchangeInteractions, 2), iterations * size(top10, 2));
newWeissHistory = zeros(1, iterations * size(top10, 2));

size(explorationHistory)

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
        newInteractions = averievite_constraints(newInteractions);

        thetaW = -(4/3) * (1/2) * ((1/2) + 1) * sum(newInteractions * 11.6 * 4);
        run_count = run_count + 1;

        explorationHistory(:, run_count + (i - 1) * iterations) = newInteractions;
        newWeissHistory(1, run_count + (i - 1) * iterations) = thetaW;
    end
end
newHistory = explorationHistory;
end