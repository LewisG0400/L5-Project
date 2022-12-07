% Takes data in the form Q, E, S and converts it into a matrix with each
% element at i,j equal to S in the ith energy bucket and jth Q bucket.
function [data_matrix, Q_buckets, E_buckets] = create_data_matrix(data, n_energy_buckets, cutoff_energy)
    E_max = max(data(:, 2));
    E_buckets = linspace(0, E_max, n_energy_buckets);
    Q_buckets = zeros([1 ceil((data(end, 1) - data(1, 1)) * 100)]);

    data_matrix = zeros([n_energy_buckets size(Q_buckets, 2)]);

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

        if E < cutoff_energy
            continue
        end

        E_index = floor((E / E_max) * (n_energy_buckets - 1) + 1);
        data_matrix(E_index, Q_index) = S;
    end
end