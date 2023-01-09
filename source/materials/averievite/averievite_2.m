function [lattice, interactionBondList] = averievite_2(exchangeInteractions)
    lattice = spinw;
    lattice.genlattice('lat_const', [8.3758, 6.3693, 11.0320], 'angled', [90 90 90], 'sym', 14);
    lattice.addatom('r', [0, 0, 0.5], 'S', 0.5, 'label', 'MCu1', 'color', 'r');
    lattice.addatom('r', [0, 0.75, 0.25], 'S', 0.5, 'label', 'MCu1', 'color', 'r');

    lattice.gencoupling('maxDistance', 15);

    lattice.addmatrix('label', 'J1', 'value', exchangeInteractions(1));
    lattice.addcoupling('mat', 'J1', 'bond', 1);
    lattice.addmatrix('label', 'J2', 'value', exchangeInteractions(2));
    lattice.addcoupling('mat', 'J2', 'bond', 2);
    lattice.addmatrix('label', 'J3', 'value', exchangeInteractions(3));
    lattice.addcoupling('mat', 'J3', 'bond', 3);

    lattice.addmatrix('label', 'J4', 'value', exchangeInteractions(4));
    lattice.addcoupling('mat', 'J4', 'bond', 4);
    lattice.addmatrix('label', 'J5', 'value', exchangeInteractions(5));
    lattice.addcoupling('mat', 'J5', 'bond', 5);
    lattice.addmatrix('label', 'J6', 'value', exchangeInteractions(6));
    lattice.addcoupling('mat', 'J6', 'bond', 4);

    lattice.addmatrix('label', 'J8', 'value', exchangeInteractions(7));
    lattice.addcoupling('mat', 'J8', 'bond', 8);
    lattice.addmatrix('label', 'J9', 'value', exchangeInteractions(8));
    lattice.addcoupling('mat', 'J9', 'bond', 9);
    lattice.addmatrix('label', 'J11', 'value', exchangeInteractions(9));
    lattice.addcoupling('mat', 'J11', 'bond', 11);
    lattice.addmatrix('label', 'J12', 'value', exchangeInteractions(10));
    lattice.addcoupling('mat', 'J12', 'bond', 12);

    lattice.addmatrix('label', 'J7', 'value', exchangeInteractions(11));
    lattice.addcoupling('mat', 'J7', 'bond', 7);
    lattice.addmatrix('label', 'J10', 'value', exchangeInteractions(12));
    lattice.addcoupling('mat', 'J10', 'bond', 10);
    lattice.addmatrix('label', 'J13', 'value', exchangeInteractions(13));
    lattice.addcoupling('mat', 'J13', 'bond', 13);

    lattice.addmatrix('label', 'Jin', 'value', exchangeInteractions(14));
    lattice.addcoupling('mat', 'Jin', 'bond', 14);
    lattice.addmatrix('label', 'Jin2', 'value', exchangeInteractions(15));
    lattice.addcoupling('mat', 'Jin2', 'bond', 15);

    mgIR = [
        [-1, 1, -2, 2, -2, 2, 1,-1, 2, -2, 2, -2];
        [0, 0, -3, -3, -3, -3, 0, 0, 3, 3, 3, 3];
        [-1, 1, -1.75, 1.75, -1.75, 1.75, 1, -1, 1.75, -1.75, 1.75, -1.75]
    ];
    lattice.genmagstr('mode','direct','nExt', [2 1 1], 'unit', 'lu', 'n', [0 0 1], 'S', mgIR, 'k', [0.5 0 0])

    plot(lattice, 'range', [1 3 3])

%     interactionBondList = [ [1, 2, 3, 0];
%                             [4, 5, 6, 0];
%                             [8, 9, 11, 12];
%                             [7, 10, 13, 0];
%                             [14, 15, 0, 0]];
    interactionBondList = ["J1" "J2" "J3" "J4" "J5" "J6" "J7" "J8" "J9" "J10" "J11" "J12" "J13" "Jin" "Jin2"];
end
