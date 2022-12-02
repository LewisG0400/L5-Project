% Takes data in the form Q, E, S and converts it into a matrix with each
% element at i,j equal to S in the ith energy bucket and jth Q bucket.
function [data_matrix, Q_buckets, E_buckets] = create_data_matrix_2(data, energy_spacing)
    E_max = max(data(:, 2))
    E_buckets = 0:energy_spacing:E_max;
    Q_buckets = zeros([1 ceil((data(end, 1) - data(1, 1)) * 100)]);

    a = size(E_buckets)

    data_matrix = zeros([size(E_buckets, 2) size(Q_buckets, 2)]);

    Q_index = 0;
    last_Q = -1;
    for i = 1:size(data, 1)
        Q = data(i, 1);
        E = data(i, 2);
        S = max(0, data(i, 3));

        if last_Q ~= Q
            Q_index = Q_index + 1;
            Q_buckets(Q_index) = Q;
            last_Q = Q;
        end

        if E < 0.7
            continue
        end

        E_index = floor((E / E_max) * (size(E_buckets, 1) - 1) + 1);
        data_matrix(E_index, Q_index) = S;
    end
end