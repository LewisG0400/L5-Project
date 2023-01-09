function [first_index, last_index] = get_q_index_range(Q_centre, Q_range, Q_data)
    first_index_t = 1;
    last_index = 1;

    Q_min = Q_centre - Q_range;
    for i = 1:size(Q_data, 2)
        if Q_data(1, i) >= Q_min
            first_index_t = i;
            break;
        end
    end

    Q_max = Q_centre + Q_range;
    for i = first_index_t:size(Q_data, 2)
        if Q_data(1, i) >= Q_max
            last_index = i;
            break;
        end
    end

    first_index = first_index_t;
end