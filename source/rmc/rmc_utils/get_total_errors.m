function errorList = get_total_errors(errorMatrix)
    errorList = zeros(1, size(errorMatrix, 1));
    for i = 1:size(errorMatrix, 1)
        sliced_data = errorMatrix(i, :);
        totalError = sqrt(sum(sliced_data.^2, 'omitnan'));

        errorList(i) = totalError;
    end
end