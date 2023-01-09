
% Takes in a matrix of S values and sums the intensities for
% each value of Q
function total_intensities = get_total_intensities(data, cutoff_index)
    total_intensities = zeros(1, size(data, 1) - cutoff_index);

    for i = cutoff_index:size(data, 1)
        sliced_data = data(i, 1:end);
        total_energy = sum(sliced_data, 'omitnan');

        total_intensities(i - cutoff_index + 1) = sum(total_energy);
    end

%     total_intensities = zeros(1, size(data, 1));
% 
%     for i = 1:size(data, 1)
%         sliced_data = data(i, 1:end);
%         total_energy = sum(sliced_data, 'omitnan');
% 
%         total_intensities(i) = sum(total_energy);
%     end
end