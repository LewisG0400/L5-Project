function plot_powder_spectrum_and_intensities(cropped_energy_experimental, cropped_energy_theory, max_energy, kagome, lower_Q, upper_Q, chi_squared, interactions)
    figure
    subplot(2, 1, 1)
    plot(cropped_energy_experimental)
    hold on
    plot(cropped_energy_theory)
    title("Total Intensity for E" )
    subtitle("Interactions: [" + num2str(interactions) +"], Chi Squared: " + chi_squared)
    xlabel("E (meV)")
    ylabel("Intensity")
    set(gca, 'xtick', linspace(0, size(cropped_energy_experimental, 2), 10), 'xticklabel', linspace(0, max_energy, 10))
    legend('Experimental Data', 'Theoretical Data')
    drawnow()

    subplot(2, 1, 2)
    kagome.setmatrix('mat', 1, 'pref', interactions(1));
    kagome.setmatrix('mat', 2, 'pref', interactions(2));
    kagome.setmatrix('mat', 3, 'pref', interactions(3));
    
    disp(interactions);
    
    try
        pow_spec = kagome.powspec(lower_Q:0.01:upper_Q, 'Evect', 0:0.01:max_energy, 'nRand', 1e3, 'hermit', true, 'imagChk', false, 'fid', 0, 'tid', 0);
        pow_spec = sw_instrument(pow_spec, 'norm',true, 'dE',0.1, 'dQ',0.05,'Ei',5);
    
        sw_plotspec(pow_spec)
    catch e
        disp(e.message);
    end
end