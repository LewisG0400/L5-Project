
% Takes in a matrix of S values and sums the intensities for
% each value of Q
function total_intensities = get_total_intensities(data)
    total_intensities = zeros(1, size(data, 1));

    for i = 1:size(data, 1)
        sliced_data = data(i, 1:end);
        total_energy = sum(sliced_data);

        total_intensities(i) = sum(total_energy);
    end
end