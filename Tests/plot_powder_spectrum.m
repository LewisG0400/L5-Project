function plot_powder_spectrum(interactions, kagome, lower_Q, upper_Q)
    kagome.setmatrix('mat', 1, 'pref', interactions(1));
    kagome.setmatrix('mat', 2, 'pref', interactions(2));
    kagome.setmatrix('mat', 3, 'pref', interactions(3));

    pow_spec = kagome.powspec(lower_Q:0.05:upper_Q, 'Evect', E_buckets, 'nRand', 1e3, 'hermit', true, 'imagChk', false, 'fid', 0, 'tid', 0);
    pow_spec = sw_instrument(pow_spec, 'norm',true, 'dE',0.1, 'dQ',0.05,'Ei',5);
end