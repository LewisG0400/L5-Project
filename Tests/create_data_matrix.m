
function [data_matrix, Q_buckets, E_buckets] = create_data_matrix(data, n_energy_buckets)
    E_max = max(data(:, 2));
    E_buckets = linspace(0, E_max, n_energy_buckets);
    Q_buckets = zeros([1 ceil((data(end, 1) - data(1, 1)) * 100)]);

    data_matrix = zeros([n_energy_buckets size(Q_buckets, 1)]);

    disp(size(data_matrix))

    Q_index = 0;
    last_Q = -1;
    for i = 1:size(data, 1)
        Q = data(i, 1);
        E = data(i, 2);
        S = data(i, 3);

        if last_Q ~= Q
            Q_index = Q_index + 1;
            Q_buckets(Q_index) = Q;
            last_Q = Q;
        end

        E_index = floor((E / E_max) * (n_energy_buckets - 1)) + 1;
        data_matrix(E_index, Q_index) = S;
    end

    %figure
    %heatmap(Q_index, E_index, data_matrix);
end