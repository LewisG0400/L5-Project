
function exchange_interactions = fit_exchange_interactions(total_intensity_list_experimental, Q_buckets)
    % Set up the kagome lattice structure
    kagome = spinw;
    kagome.genlattice('lat_const',[6 6 10],'angled',[90 90 120],'spgr','P -3')
    kagome.addatom('r',[1/2 0 0],'S', 1,'label','MCu1','color','r')

    kagome.gencoupling('maxDistance',7)

    % Randomly choose initial exchange interactions
    exchange_interactions = [rand(), rand(), rand()];
    interaction_names = ['J1', 'J2', 'Jd'];
    interaction_to_change = 1;
    same_count = 0;

    % Set up exchange interactions over the lattice.
    kagome.addmatrix('label','J1','value',exchange_interactions(1),'color','r')
    kagome.addmatrix('label','J2','value',exchange_interactions(2),'color','g')
    kagome.addmatrix('label','Jd','value',exchange_interactions(3),'color','b')
    kagome.addcoupling('mat','J1','bond',1)
    kagome.addcoupling('mat','J2','bond',2)
    kagome.addcoupling('mat','Jd','bond',4)

    % Generate lattice spins
    mgIR=[  1   1   1
        0   0   0
        0   0   0];
    kagome.genmagstr('mode','direct','nExt',[1 1 1],'unit','lu','n',[0 0 1],'S',mgIR,'k',[0 0 0]);

    % Calculate the spin wave dispersion of the lattice with the
    % new parameters. Throws some error if the Hamiltonian is not
    % positive definite, so we need to catch those cases and change
    % the exchange interactions again.
    try
        orignal_pow_spec = kagome.powspec(0.15:0.01:2.41 ,'Evect',linspace(0,3,250), 'nRand',1e3,'hermit',false,'imagChk',false);

        original_total_intensity_list = get_total_intensities(orignal_pow_spec.hklA, orignal_pow_spec.swConv);

        % Rescale the theory data
        scale_factor = max(total_intensity_list_experimental) / max(original_total_intensity_list);
        original_total_intensity_list = original_total_intensity_list * scale_factor;

        original_chi_squared = calculate_chi_squared(total_intensity_list_experimental, original_total_intensity_list, 0.5, 0.4, Q_buckets);
    catch e
        disp("Error: " + e.message);
    end

    done = false;
    while ~done
        try
            interaction_to_change = floor(1 + (size(exchange_interactions, 2) - 1) * rand());
            disp(interaction_to_change);
            new_exchange_interaction = exchange_interactions(interaction_to_change) + rand() - 0.5;
            kagome.setmatrix('mat', interaction_to_change, 'pref', new_exchange_interaction);

            new_pow_spec = kagome.powspec(0.15:0.01:2.41 ,'Evect',linspace(0,3,250), 'nRand',1e3,'hermit',false,'imagChk',false);

            new_total_intensity_list = get_total_intensities(new_pow_spec.hklA, new_pow_spec.swConv);

            % Rescale the theory data
            scale_factor = max(total_intensity_list_experimental) / max(new_total_intensity_list);
            new_total_intensity_list = new_total_intensity_list * scale_factor;

            new_chi_squared = calculate_chi_squared(total_intensity_list_experimental, new_total_intensity_list, 0.5, 0.4, Q_buckets);

            chi_squared_difference = new_chi_squared - original_chi_squared
            if chi_squared_difference <= -0.001
                exchange_interactions(interaction_to_change) = new_exchange_interaction;
                original_pow_spec = new_pow_spec;
                original_total_intensity_list = new_total_intensity_list;

                disp("Better match by changing interaction " + interaction_to_change + " to " + new_exchange_interaction);
                disp("New exchange interactions are: " + exchange_interactions);

                continue;
            elseif chi_squared_difference < 0.001
                exchange_interactions(interaction_to_change) = new_exchange_interaction;
                original_pow_spec = new_pow_spec;
                original_total_intensity_list = new_total_intensity_list;

                same_count = same_count + 1;
                disp("Similar matches")
                disp("New exchange interactions are: " + exchange_interactions);
                if same_count == 3
                    break;
                end
            else
                disp("Worse match, reversing")
                disp("Exchange interactions are: " + exchange_interactions);
            end
        catch e
            disp("Error: " + e.message);
        end
    end
end