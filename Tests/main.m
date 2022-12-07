Q_centre = 0.5;
Q_range = 0.2;
acceptance_parameter = 2.0;
total_iterations = 2500;

load("../data/chi_squareds_sw_instrument.mat")

experimental_data = readmatrix("../data/Haydeeite-Tsub-chiqw.dat");

[experimental_data_matrix, Q_buckets, E_buckets] = create_data_matrix(experimental_data, 100);
max_energy = max(experimental_data(:, 2));

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

[lower_Q, upper_Q] = get_q_index_range(Q_centre, Q_range, Q_buckets);
experimental_data_matrix = experimental_data_matrix(:, lower_Q:upper_Q);

total_intensity_list_experimental = get_total_intensities(experimental_data_matrix);
experimental_scale_factor = 1 / max(total_intensity_list_experimental, [], 'all');
total_intensity_list_experimental = total_intensity_list_experimental * experimental_scale_factor;
total_intensity_list_experimental(end) = [];

% fit_exchange_interactions(total_intensity_list_experimental, Q_buckets, 0.5, 0.05);

interaction_to_change = 1;

chi_squared_history = [];
interaction_history = zeros([1 3]);
intensity_history = zeros([1 99]);
worst_accepted = 1;
worse_accepted_count = 0;
worse_rejected_count = 0;
fail_count = 0;

% Set up the kagome lattice structure
[kagome, exchange_interactions] = create_spinw_kagome(3);
exchange_interactions(2) = 0;
kagome.setmatrix('mat', 2, 'pref', 0);

interaction_indices = [1, 3];

% Calculate the spin wave dispersion of the lattice with the
% iniital parameters. Throws some error if the Hamiltonian is not
% positive definite, so we need to catch those cases and change
% the exchange interactions again.
valid = false;

while ~valid

    try
        orignal_pow_spec = kagome.powspec(Q_centre - Q_range:0.05:Q_centre + Q_range, 'Evect', E_buckets, 'nRand', 1e3, 'hermit', true, 'imagChk', false);

        valid = true;
    catch e
        disp("Error: " + e.message);

        interaction_to_change = 1 + floor((size(exchange_interactions, 2)) * rand());
        %interaction_to_change = interaction_indices(round(rand()) + 1);
        % new_exchange_interaction = exchange_interactions(interaction_to_change) + rand() - 0.5;
        new_exchange_interaction = rand() * 10.0 - 5.0;
        exchange_interactions(interaction_to_change) = new_exchange_interaction;
        kagome.setmatrix('mat', interaction_to_change, 'pref', new_exchange_interaction);

        disp(exchange_interactions);
    end

end

original_total_intensity_list = get_total_intensities(orignal_pow_spec.swConv);

% Rescale the theory data
% I have taken out the scaling as, for the correct interactions, SpinW's
% intensity range is the same as the experimental data's
%scale_factor = max(total_intensity_list_experimental, 1) / max(original_total_intensity_list, 1);
%original_total_intensity_list = original_total_intensity_list * scale_factor;

original_chi_squared = calculate_chi_squared(total_intensity_list_experimental, original_total_intensity_list, E_buckets);
chi_squared_history(1) = original_chi_squared;
interaction_history(1, :) = exchange_interactions;

plot_total_intensities(total_intensity_list_experimental, original_total_intensity_list, max_energy, original_chi_squared, exchange_interactions);

run_count = 0;
done = false;
while ~done
    if run_count > total_iterations
        break;
    end

    % Pick a random exchange interaction to change. It's new value is sampled from
    % (-5, 5)
    interaction_to_change = 1 + floor((size(exchange_interactions, 2)) * rand());
    %interaction_to_change = interaction_indices(round(rand()) + 1);
    if true %original_chi_squared > 1
        new_exchange_interaction = rand() * 10.0 - 5.0;
    else
        new_exchange_interaction = exchange_interactions(interaction_to_change) + rand() - 0.5;
    end
    kagome.setmatrix('mat', interaction_to_change, 'pref', new_exchange_interaction);

    % Try calculating a powder spectrum from the new parameters.
    % If it fails, we just repick new parameters.
    try
        % new_pow_spec = kagome.powspec(Q_centre - Q_range:0.05:Q_centre + Q_range, 'Evect', E_buckets, 'nRand', 5e3, 'hermit', true, 'imagChk', false, 'fid', 0, 'tid', 0);
        new_pow_spec = kagome.powspec(Q_centre - Q_range:0.05:Q_centre + Q_range, 'Evect', E_buckets, 'nRand', 1e3, 'hermit', true, 'imagChk', false, 'fid', 0, 'tid', 0);
        new_pow_spec = sw_instrument(new_pow_spec, 'norm',true, 'dE',0.1, 'dQ',0.05,'Ei',5);
    catch e
        disp("Error: " + e.message);
        fail_count = fail_count + 1;
        continue;
    end

    run_count = run_count + 1;

    new_total_intensity_list = get_total_intensities(new_pow_spec.swConv);

    % Rescale the theory data before we calculate chi squared
    scale_factor = max(total_intensity_list_experimental) / max(new_total_intensity_list);
    new_total_intensity_list = new_total_intensity_list * scale_factor;

    new_chi_squared = calculate_chi_squared(total_intensity_list_experimental, new_total_intensity_list, E_buckets);

    chi_squared_difference = new_chi_squared - original_chi_squared

    if chi_squared_difference < 0
        exchange_interactions(interaction_to_change) = new_exchange_interaction;
        %update_current_interactions(new_total_intensity_list, new_pow_spec, new_chi_squared);

        original_total_intensity_list = new_total_intensity_list;
        original_chi_squared = new_chi_squared;
        original_pow_spec = new_pow_spec;

        chi_squared_history(end + 1) = new_chi_squared;
        interaction_history(end + 1, :) = exchange_interactions;
        intensity_history(end + 1, :) = new_total_intensity_list;

        disp(chi_squared_history);

        disp("Better match by changing interaction " + interaction_to_change + " to " + new_exchange_interaction);
        disp("New exchange interactions are: " + num2str(exchange_interactions));

        %plot_total_intensities(total_intensity_list_experimental, new_total_intensity_list, max_energy, new_chi_squared, exchange_interactions);

        continue;
    else
        % We accept a certain number of moves with a probability proportional
        % to the difference in chi squared.
        acceptance_probability = min(1, exp(-chi_squared_difference / acceptance_parameter))

        if rand() < acceptance_probability
            worse_accepted_count = worse_accepted_count + 1;
            if acceptance_probability < worst_accepted
                worst_accepted = acceptance_probability;
            end

            disp("Accepting worse match by changing " + interaction_to_change + " to " + new_exchange_interaction)
            disp("New exchange interactions are: " + num2str(exchange_interactions));

            exchange_interactions(interaction_to_change) = new_exchange_interaction;
            %update_current_interactions(new_total_intensity_list, new_pow_spec, new_chi_squared);

            original_total_intensity_list = new_total_intensity_list;
            original_chi_squared = new_chi_squared;
            original_pow_spec = new_pow_spec;

            chi_squared_history(end + 1) = new_chi_squared;
            interaction_history(end + 1, :) = exchange_interactions;
            intensity_history(end + 1, :) = new_total_intensity_list;

            disp(chi_squared_history);

            %plot_total_intensities(total_intensity_list_experimental, new_total_intensity_list);
        else
            disp("Worse match not accepted, reversing")
            disp("Exchange interactions are: " + exchange_interactions);

            %chi_squared_history(end + 1) = original_chi_squared;
            %interaction_history(end + 1, :) = exchange_interactions;
            %intensity_history(end + 1, :) = new_total_intensity_list;

            worse_rejected_count = worse_rejected_count + 1;
        end

    end

end

figure
plot(chi_squared_history)
title("History of chi squared values")
xlabel("Iteration")
ylabel("Chi Squared")
% 
disp("Interaction History:")
disp(interaction_history)

lowest_Q_value = Q_buckets(1);
highest_Q_value = Q_buckets(end);
[best_match_chi_squareds, best_matches_indices] = mink(chi_squared_history, 10);
for i = 1:10
    %plot_total_intensities(total_intensity_list_experimental, intensity_history(best_matches_indices(i), :), max_energy, chi_squared_history(best_matches_indices(i)), interaction_history(best_matches_indices(i), :));
    %plot_powder_spectrum(interaction_history(best_matches_indices(i), :), chi_squared_history(best_matches_indices(i)), kagome, lowest_Q_value, highest_Q_value, max_energy);
    plot_powder_spectrum_and_intensities(total_intensity_list_experimental, intensity_history(best_matches_indices(i), :), max_energy, kagome, lowest_Q_value, highest_Q_value, chi_squared_history(best_matches_indices(i)), interaction_history(best_matches_indices(i), :))
end

plot_exchanges_on_param_space(chi_squareds, interaction_history, best_match_chi_squareds, best_matches_indices);
save("../results/with_j2/" + total_iterations + "_" + regexprep(num2str(acceptance_parameter), '\.', '-') + "_no-steps_range0-2_centre_0-5_1")