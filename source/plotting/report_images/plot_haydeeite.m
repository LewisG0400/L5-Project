lattice = spinw;
lattice.genlattice('lat_const', [6 6 10], 'angled', [90 90 120], 'spgr', 'P -3')
lattice.addatom('r', [1/2 0 0], 'S', 1/2, 'label', 'MCu1', 'color', 'r')

lattice.gencoupling('maxDistance', 7)

% Set up exchange interactions over the lattice.
lattice.addmatrix('label', 'J1', 'value', exchangeInteractions(1), 'color', 'r')
lattice.addmatrix('label', 'J2', 'value', exchangeInteractions(2), 'color', 'g')
lattice.addmatrix('label', 'J3', 'value', exchangeInteractions(3), 'color', 'yellow')
lattice.addmatrix('label', 'Jd', 'value', exchangeInteractions(4), 'color', 'b')
lattice.addcoupling('mat', 'J1', 'bond', 1)
lattice.addcoupling('mat', 'J2', 'bond', 2)
lattice.addcoupling('mat', 'J3', 'bond', 3)
lattice.addcoupling('mat', 'Jd', 'bond', 4)

plot(lattice, 'range', [3 3 1]);