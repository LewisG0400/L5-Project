function plot_double_spectrum_and_intensities(cropped_energy_experimental1, experimentalError1, cropped_energy_experimental2, experimentalError2, cropped_energy_theory1, max_energy, input_energy, cutoff_energy, lattice, lower_Q, upper_Q, Q_centre, Q_range, chi_squared, interactions, EBuckets)
%     subplot(2, 1, 1)
%     hold on
%     %errorbar(cropped_energy_experimental, experimentalError)
%     plot(cropped_energy_experimental);
%     plot(cropped_energy_theory)
%     title("Total Intensity for E" )
%     subtitle("Interactions: [" + num2str(interactions) +"], Chi Squared: " + chi_squared)
%     xlabel("E (meV)")
%     ylabel("Intensity")
%     set(gca, 'xtick', linspace(0, size(cropped_energy_experimental, 2), 10), 'xticklabel', linspace(cutoff_energy, max_energy, 10))
%     legend('Experimental Data', 'Theoretical Data')
%     drawnow()
% 
%     subplot(2, 1, 2)

    disp(interactions);
    
    try
        pow_spec = lattice.powspec(lower_Q:0.01:upper_Q, 'Evect', EBuckets, 'nRand', 1e3, 'formfact', true, 'hermit', true, 'imagChk', false);
        pow_spec = sw_instrument(pow_spec, 'norm',true, 'dE',0.1, 'dQ',0.05,'Ei',input_energy);

        figure
        subplot(3, 1, 1)

        title("Total Intensity for E" )
        subtitle("Interactions: [" + num2str(interactions) +"], Chi Squared: " + chi_squared)
        xlabel("E (meV)")
        ylabel("Intensity")

        errorbar(cropped_energy_experimental1, experimentalError1)
                        hold on
        plot(cropped_energy_theory1)

        subplot(3, 1, 2);

        title("Total Intensity for E" )
        xlabel("E (meV)")
        ylabel("Intensity")
        
        [lowerQ, upperQ] = get_q_index_range(0.9, 0.1, lower_Q:0.01:upper_Q)

        errorbar(cropped_energy_experimental2, experimentalError2)
        hold on
        
        totalIntensities2 = get_total_intensities(pow_spec.swConv(:, lowerQ:upperQ));
        totalIntensities2 = (max(cropped_energy_experimental2, [], 'all') / max(totalIntensities2, [], 'all')) * totalIntensities2;
        plot(totalIntensities2);

        subplot(3, 1, 3)

        sw_plotspec(pow_spec);

        swplot.line([Q_centre - Q_range, 0, 100], [Q_centre - Q_range, max_energy, 100]);
        swplot.line([Q_centre + Q_range, 0, 100], [Q_centre + Q_range, max_energy, 100]);

        swplot.line([0.8, 0, 100], [0.8, max_energy, 100]);
        swplot.line([1.0, 0, 100], [1.0, max_energy, 100]);

        drawnow()
    catch e
        disp(e.message);
    end
end
