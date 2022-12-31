function plot_powder_spectrum(interactions, chi_squared, kagome, lower_Q, upper_Q, E_max)
    kagome.setmatrix('mat', 1, 'pref', interactions(1));
    kagome.setmatrix('mat', 2, 'pref', interactions(2));
    kagome.setmatrix('mat', 3, 'pref', interactions(3));
    
    disp(interactions);
    
    try
        pow_spec = kagome.powspec(lower_Q:0.01:upper_Q, 'Evect', 0:0.01:E_max, 'nRand', 1e3, 'hermit', true, 'imagChk', false, 'fid', 0, 'tid', 0);
        pow_spec = sw_instrument(pow_spec, 'norm',true, 'dE',0.1, 'dQ',0.05,'Ei',5);
    
    
        figure
        sw_plotspec(pow_spec)
        subtitle("Interactions: [" + num2str(interactions) +"], Chi Squared: " + chi_squared)
    catch e
        disp(e.message);
    end
end