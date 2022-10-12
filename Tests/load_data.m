data = readmatrix("../data/Haydeeite-Tsub-chiqw.dat");

[data_matrix, Q_buckets, E_buckets] = create_data_matrix(data, 150);

total_energy_list = get_energy_slices(Q_buckets, data_matrix)
%chi_squared = calculate_chi_squared_value()

function [first_index, last_index] = get_index_range(Q_centre, Q_range, Q_data)
    first_index_t = 1;
    last_index = 1;

    Q_min = Q_centre - Q_range;
    for i = 1:size(Q_data)
        if Q_data(i) >= Q_min
            first_index_t = i;
            break;
        end
    end

    Q_max = Q_centre + Q_range;
    for i = first_index_t:size(Q_data)
        if Q_data(i) >= Q_max
            last_index = i;
            break;
        end
    end

    first_index = first_index_t;
end

function total_energies = get_energy_slices(Q_data, data)
    slice_size = 0.1;
    Q_min = min(Q_data) + slice_size;
    Q_max = max(Q_data) - slice_size;

    total_energies = zeros([1 floor((Q_max-Q_min) / slice_size)]);

    Q_centre = Q_min + slice_size;
    for i = 1:floor((Q_max-Q_min) / slice_size)
        [first_index, last_index] = get_index_range(Q_centre, slice_size, Q_data);
        sliced_data = data(:, first_index:last_index);
        total_energy = sum(sliced_data, 2);

        total_energies(i) = sum(total_energy);

        Q_centre = Q_centre + slice_size;
    end
end

function chi_squared = calculate_chi_squared_value(total_energies_1, total_energies_2)
    chi_squared = sum(total_energies_1 - total_energies_2);
end

function [data_matrix, Q_buckets, E_buckets] = create_data_matrix(data, n_energy_buckets)
    E_max = max(data(:, 2));
    E_buckets = linspace(0, E_max, n_energy_buckets);
    Q_buckets = zeros([ceil((data(end, 1) - data(1, 1)) * 100) 1]);

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