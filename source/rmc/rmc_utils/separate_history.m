function [chiSquaredHistory, interactionHistory, intensityHistory] = separate_history(history, experimentalIntensityList)
    arraySizes = size(history, 2);
    chiSquaredHistory = zeros(arraySizes, 1);
    interactionHistory = zeros(arraySizes, size(history(1).exchangeInteractions, 2));
    intensityHistory = zeros(arraySizes, size(history(1).totalIntensities, 2));

    for i = 1:arraySizes
        chiSquaredHistory(i) = history(i).getChiSquared();

        interactions = history(i).getExchangeInteractions();
        interactionHistory(i, :) = interactions(1, :);

        intensities = history(i).getTotalIntensities();
        intensityHistory(i, :) = intensities(1, :);
    end
end