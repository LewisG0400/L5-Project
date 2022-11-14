experimental_data = readmatrix("../data/Haydeeite-Tsub-chiqw.dat");

[experimental_data_matrix, Q_buckets, E_buckets] = create_data_matrix(experimental_data, 100);
max_energy = ceil(max(E_buckets));

figure
experimental_data_plot = surf(Q_buckets, E_buckets, experimental_data_matrix, experimental_data_matrix, 'EdgeColor', 'none');
c = colorbar;
c.Label.String = 'Intensity';
c.Label.FontSize = 18;
experiment_data_plot.CDataMapping = 'scaled';
title("Neutron Scattering Data for Haydeeite", 'fontsize', 18)
xlabel("Q (Å)", 'fontsize', 18)
ylabel("E (meV)", 'fontsize', 18)
zlabel("S(Q, ω)")
drawnow()

%set(gca, 'zscale', 'log')


Q_centre = 0.5;
Q_range = 0.05;

[lower_Q, upper_Q] = get_q_index_range(Q_centre, Q_range, Q_buckets);
experimental_data_matrix = experimental_data_matrix(:, lower_Q:upper_Q);

total_intensity_list_experimental = get_total_intensities(Q_buckets, experimental_data_matrix);

% fit_exchange_interactions(total_intensity_list_experimental, Q_buckets, 0.5, 0.05);

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
        orignal_pow_spec = kagome.powspec(Q_centre - Q_range:0.01:Q_centre + Q_range, 'Evect', linspace(0, 3, size(experimental_data_matrix, 1) + 1), 'nRand', 1e3, 'hermit', true, 'imagChk', false);

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
    new_exchange_interaction = rand() * 10.0 - 5.0;
    % new_exchange_interaction = exchange_interactions(interaction_to_change) + rand() - 0.5;
    kagome.setmatrix('mat', interaction_to_change, 'pref', new_exchange_interaction);

    % Try calculating a powder spectrum from the new parameters.
    % If it fails, we just repick new parameters.
    try
        new_pow_spec = kagome.powspec(Q_centre - Q_range:0.01:Q_centre + Q_range, 'Evect', linspace(0, 3, size(experimental_data_matrix, 1) + 1), 'nRand', 1e3, 'hermit', true, 'imagChk', false, 'fid', 0, 'tid', 0);
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
        update_current_interactions(new_total_intensity_list, new_pow_spec, new_chi_squared);

        disp("Better match by changing interaction " + interaction_to_change + " to " + new_exchange_interaction);
        disp("New exchange interactions are: " + exchange_interactions);

        plot_total_intensities(total_intensity_list_experimental, new_total_intensity_list, max_energy, new_chi_squared, exchange_interactions);
        drawnow()

        continue;
    else
        % We accept a certain number of moves with a probability proportional
        % to the difference in chi squared.
        acceptance_probability = min(1, exp(-chi_squared_difference / 2))

        if rand() < acceptance_probability
            disp("Accepting worse match by changing " + interaction_to_change + " to " + new_exchange_interaction)
            disp("New exchange interactions are: " + exchange_interactions);

            exchange_interactions(interaction_to_change) = new_exchange_interaction;
            update_current_interactions(new_total_intensity_list, new_pow_spec, new_chi_squared);
            
            %plot_total_intensities(total_intensity_list_experimental, new_total_intensity_list);
            drawnow()
        else
            disp("Worse match not accepted, reversing")
            disp("Exchange interactions are: " + exchange_interactions);
        end

    end

end

function update_current_interactions(new_intensity_list, new_pow_spec, new_chi_squared)
    original_total_intensity_list = new_intensity_list;
    original_chi_squared = new_chi_squared;
    original_pow_spec = new_pow_spec;

    chi_squared_history(end + 1) = new_chi_squared;
    interaction_history(end + 1, :) = exchange_interactions;

    disp(chi_squared_history);
end