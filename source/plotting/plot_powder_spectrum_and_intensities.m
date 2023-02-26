function plot_powder_spectrum_and_intensities(cropped_energy_experimental, experimentalError, cropped_energy_theory, max_energy, input_energy, cutoff_energy, lattice, lower_Q, upper_Q, Q_centre, Q_range, chi_squared, interactions, Qs)
    function plot_powder_spectrum_and_intensities(cropped_energy_experimental, cropped_energy_theory, max_energy, cutoff_energy, lattice, lower_Q, upper_Q, Q_centre, Q_range, chi_squared, interactions)
    figure
    subplot(2, 1, 1)
    plot(cropped_energy_experimental)
    hold on
    plot(cropped_energy_theory)
    title("Total Intensity for E" )
    subtitle("Interactions: [" + num2str(interactions) +"], Chi Squared: " + chi_squared)
    xlabel("E (meV)")
    ylabel("Intensity")
    set(gca, 'xtick', linspace(0, size(cropped_energy_experimental, 2), 10), 'xticklabel', linspace(cutoff_energy, max_energy, 10))
    legend('Experimental Data', 'Theoretical Data')
    drawnow()

    subplot(2, 1, 2)

    disp(interactions);
    
    try
        pow_spec = lattice.powspec(lower_Q:0.01:upper_Q, 'Evect', cutoff_energy:0.01:max_energy, 'nRand', 1e3, 'hermit', true, 'imagChk', false, 'fid', 0, 'tid', 0);
        pow_spec = sw_instrument(pow_spec, 'norm',true, 'dE',0.1, 'dQ',0.05,'Ei',5);
    
        sw_plotspec(pow_spec);

        hold on

        swplot.line([Q_centre - Q_range, 0, 100], [Q_centre - Q_range, max_energy, 100]);
        swplot.line([Q_centre + Q_range, 0, 100], [Q_centre + Q_range, max_energy, 100]);
    catch e
        disp(e.message);
    end
end
end