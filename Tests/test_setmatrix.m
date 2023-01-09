exchangeInteractions = [0, 0, 0, 0];

[lattice, exchangeIndices] = averievite(exchangeInteractions);

lattice.setmatrix('bond', 1, 'pref', 0.1);
lattice.setmatrix('bond', 2, 'pref', 0.2);