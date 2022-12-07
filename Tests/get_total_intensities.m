
% Takes in a matrix of S values and sums the intensities for
% each value of Q
function total_intensities = get_total_intensities(data, cutoff_index)
    % We cut all the data for E < 0.7 out of the experimental data
    % as it is full of elastic scattering data, which isn't calculated
    % by SpinW.
    total_intensities = zeros(1, size(data, 1) - cutoff_index);

    for i = cutoff_index:size(data, 1)
        sliced_data = data(i, 1:end);
        total_energy = sum(sliced_data, 'omitnan');

        total_intensities(i - cutoff_index + 1) = sum(total_energy);
    end
end