function [lattice, interactionBondList] = averievite(exchangeInteractions)
    lattice = spinw;
    lattice.genlattice('lat_const', [8.3758, 6.3693, 11.0320], 'angled', [90 90 90], 'sym', 14);
    lattice.addatom('r', [0, 0, 0.5], 'S', 0.5, 'label', 'MCu1', 'color', 'r');
    lattice.addatom('r', [0, 0.75, 0.25], 'S', 0.5, 'label', 'MCu1', 'color', 'r');

    lattice.gencoupling('maxDistance', 15);

    lattice.addmatrix('label', 'J1', 'value', exchangeInteractions(1));
    lattice.addcoupling('mat', 'J1', 'bond', [1, 2, 3]);
    lattice.addmatrix('label', 'J2', 'value', -exchangeInteractions(1));
    lattice.addcoupling('mat', 'J2', 'bond', [4, 5, 6]);
    %lattice.addmatrix('label', 'J3', 'value', exchangeInteractions(3));
    %lattice.addcoupling('mat', 'J3', 'bond', [8, 9, 11, 12]);
    lattice.addmatrix('label', 'Jd', 'value', exchangeInteractions(3));
    lattice.addcoupling('mat', 'Jd', 'bond', [7, 10, 13]);
    lattice.addmatrix('label', 'Jin', 'value', exchangeInteractions(4));
    lattice.addcoupling('mat', 'Jin', 'bond', [14, 15]);

    mgIR = [
        [-1, 1, -2, 2, -2, 2, 1,-1, 2, -2, 2, -2];
        [0, 0, -3, -3, -3, -3, 0, 0, 3, 3, 3, 3];
        [-1, 1, -1.75, 1.75, -1.75, 1.75, 1, -1, 1.75, -1.75, 1.75, -1.75]
    ];

    lattice.genmagstr('mode','direct','nExt', [2 1 1], 'unit', 'lu', 'n', [0 0 1], 'S', mgIR, 'k', [0.5 0 0])

    %plot(lattice, 'range', [1 3 3])

    interactionBondList = [ [1, 2, 3, 0];
                            [4, 5, 6, 0];
                           % [8, 9, 11, 12];
                            [7, 10, 13, 0];
                            [14, 15, 0, 0]];
end

