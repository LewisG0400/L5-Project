function chiSquared = calculate_chi_squared_matrix(experimentalData, theoreticalData)
    diff = zeros(size(experimentalData));

    for i = 1:size(experimentalData, 1)
        for j = 1:size(experimentalData, 2)
            if isnan(theoreticalData(i, j))
                diff(i, j) = 0;
                continue
            end
            diff(i, j) = ((experimentalData(i, j) - theoreticalData(i, j))^2);
        end
    end
    chiSquared = sum(diff, 'all');
end