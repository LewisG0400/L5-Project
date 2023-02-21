% Takes data in the form Q, E, S and converts it into a matrix with each
% element at i,j equal to S in the ith energy bucket and jth Q bucket.
% function [dataMatrix, QBuckets, EBuckets] = create_haydeeite_data_matrix(data)
%     EBuckets = unique(data(:, 2)).';
%     QBuckets = unique(data(:, 1)).';
%     intensities = zeros(1, size(EBuckets, 2) * size(QBuckets, 2));
% 
%     nEBuckets = size(EBuckets, 2);
% 
%     EIndex = 1;
%     intensityIndex = 1;
%     for i = 1:size(data, 1)
%         if(data(i, 2) ~= EBuckets(1, EIndex))
%             intensityIndex = intensityIndex + (nEBuckets - EIndex);
%             EIndex = 1;
%         else
%             EIndex = EIndex + 1;
%             if EIndex > nEBuckets
%                 EIndex = 1;
%             end
%         end
%         intensities(intensityIndex) = data(i, 3);
%         intensityIndex = intensityIndex + 1;
%     end
% 
%     size(intensities)
% 
%     dataMatrix = reshape(intensities, [size(EBuckets, 2) size(QBuckets, 2)])
% end
function [data_matrix, error_matrix, Q_buckets, E_buckets] = create_haydeeite_data_matrix(data)
    E_max = max(data(:, 2));
    E_buckets = unique(data(:, 2)).';
    Q_buckets = unique(data(:, 1)).';

    n_energy_buckets = size(E_buckets, 2);

    data_matrix = zeros([n_energy_buckets size(Q_buckets, 2)]);
    error_matrix = ones(size(data_matrix));

    Q_index = 0;
    last_Q = -1;
    for i = 1:size(data, 1)
        Q = data(i, 1);
        E = data(i, 2);
        S = max(0, data(i, 3));

        if last_Q ~= Q
            Q_index = Q_index + 1;
            last_Q = Q;
        end

        E_index = floor((E / E_max) * (n_energy_buckets - 1) + 1);
        data_matrix(E_index, Q_index) = S;
    end
end