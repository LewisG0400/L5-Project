function total_energies = get_energy_slices(Q_data, data)
    slice_size = 0.1;
    Q_min = min(Q_data) + slice_size;
    Q_max = max(Q_data) - slice_size;

    total_energies = zeros([1 floor((Q_max-Q_min) / slice_size)]);

    Q_centre = Q_min + slice_size;
    for i = 1:floor((Q_max-Q_min) / slice_size)
        [first_index, last_index] = get_q_index_range(Q_centre, slice_size, Q_data);
        sliced_data = data(:, first_index:last_index);
        total_energy = sum(sliced_data, 2);

        total_energies(i) = sum(total_energy);

        Q_centre = Q_centre + slice_size;
    end
end