function exchange_interactions = fit_exchange_interactions(total_intensity_list_experimental, Q_buckets, Q_centre, Q_range)
    [lower_Q, upper_Q] = get_q_index_range(Q_centre, Q_range, Q_buckets);
    total_intensity_list_experimental = total_intensity_list_experimental(1, lower_Q:upper_Q);

    interaction_to_change = 1;

    chi_squared_history = [];
    interaction_history = zeros([1 3]);

    % Set up the kagome lattice structure
    [kagome, exchange_interactions] = create_spinw_kagome(3);

    % Calculate the spin wave dispersion of the lattice with the
    % iniital parameters. Throws some error if the Hamiltonian is not
    % positive definite, so we need to catch those cases and change
    % the exchange interactions again.
    valid = false;
    while ~valid

        try
            orignal_pow_spec = kagome.powspec(Q_centre - Q_range:0.01:Q_centre + Q_range, 'Evect', linspace(0, 3, 250), 'nRand', 1e3, 'hermit', true, 'imagChk', false);

            valid = true;
        catch e
            disp("Error: " + e.message);

            interaction_to_change = 1 + floor((size(exchange_interactions, 2)) * rand());
            % new_exchange_interaction = exchange_interactions(interaction_to_change) + rand() - 0.5;
            new_exchange_interaction = rand() * 10.0 - 5.0;
            exchange_interactions(interaction_to_change) = new_exchange_interaction;
            kagome.setmatrix('mat', interaction_to_change, 'pref', new_exchange_interaction);

            disp(exchange_interactions);
        end

    end

    original_total_intensity_list = get_total_intensities(orignal_pow_spec.hklA, orignal_pow_spec.swConv);

    % Rescale the theory data
    scale_factor = max(total_intensity_list_experimental, 1) / max(original_total_intensity_list, 1);
    original_total_intensity_list = original_total_intensity_list * scale_factor;

    original_chi_squared = calculate_chi_squared(total_intensity_list_experimental, original_total_intensity_list);
    chi_squared_history(1) = original_chi_squared;
    interaction_history(1, :) = exchange_interactions;

    done = false;

    while ~done
        % Pick a random exchange interaction to change. It's new value is sampled from
        % (-5, 5)
        interaction_to_change = 1 + floor((size(exchange_interactions, 2)) * rand());
        % new_exchange_interaction = exchange_interactions(interaction_to_change) + rand() - 0.5;
        new_exchange_interaction = rand() * 10.0 - 5.0;
        kagome.setmatrix('mat', interaction_to_change, 'pref', new_exchange_interaction);

        % Try calculating a powder spectrum from the new parameters.
        % If it fails, we just repick new parameters.
        try
            new_pow_spec = kagome.powspec(Q_centre - Q_range:0.01:Q_centre + Q_range, 'Evect', linspace(0, 3, 250), 'nRand', 1e3, 'hermit', true, 'imagChk', false, 'fid', 0, 'tid', 0);
        catch e
            %disp("Error: " + e.message);
            continue;
        end

        new_total_intensity_list = get_total_intensities(new_pow_spec.hklA, new_pow_spec.swConv);

        % Rescale the theory data before we calculate chi squared
        scale_factor = max(total_intensity_list_experimental) / max(new_total_intensity_list);
        new_total_intensity_list = new_total_intensity_list * scale_factor;

        new_chi_squared = calculate_chi_squared(total_intensity_list_experimental, new_total_intensity_list);

        chi_squared_difference = new_chi_squared - original_chi_squared

        if chi_squared_difference < 0
            exchange_interactions(interaction_to_change) = new_exchange_interaction;
            original_pow_spec = new_pow_spec;
            original_total_intensity_list = new_total_intensity_list;
            original_chi_squared = new_chi_squared;

            disp("Better match by changing interaction " + interaction_to_change + " to " + new_exchange_interaction);
            disp("New exchange interactions are: " + exchange_interactions);

            chi_squared_history(end + 1) = new_chi_squared
            interaction_history(end + 1, :) = exchange_interactions

            plot_total_intensities(total_intensity_list_experimental, new_total_intensity_list, Q_centre, Q_range, new_chi_squared, exchange_interactions);
            drawnow()

            continue;
        else
            % We accept a certain number of moves with a probability proportional
            % to the difference in chi squared.
            acceptance_probability = min(1, exp(-chi_squared_difference / 2));
            if rand() < acceptance_probability
                disp("Accepting worse match")

                exchange_interactions(interaction_to_change) = new_exchange_interaction;
                original_total_intensity_list = new_total_intensity_list;
                original_chi_squared = new_chi_squared;
                original_pow_spec = new_pow_spec;

                chi_squared_history(end + 1) = new_chi_squared;
                interaction_history(end + 1, :) = exchange_interactions;

                disp(chi_squared_history);
                %plot_total_intensities(total_intensity_list_experimental, new_total_intensity_list);
                drawnow()

                disp("New exchange interactions are: " + exchange_interactions);
            else
                disp("Worse match not accepted, reversing")
                disp("Exchange interactions are: " + exchange_interactions);
            end

        end

    end

end
