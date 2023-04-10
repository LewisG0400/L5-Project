function [lattice, interactionBondList] = averievite_full(exchangeInteractions)
    lattice = spinw;
    lattice.genlattice('lat_const', [8.3758, 6.3693, 11.0320], 'angled', [90 90 90], 'sym', 14);
    lattice.addatom('r', [0, 0, 0.5], 'S', 0.5, 'label', 'MCu1', 'color', 'r');
    lattice.addatom('r', [0, 0.75, 0.25], 'S', 0.5, 'label', 'MCu1', 'color', 'r');

    lattice.gencoupling('maxDistance', 15);

    % J1 in the original setup
%     lattice.addmatrix('label', 'J1', 'value', exchangeInteractions(1), 'color', 'red');
%     lattice.addcoupling('mat', 'J1', 'bond', 1);
%     lattice.addmatrix('label', 'J2', 'value', exchangeInteractions(1), 'color', 'green');
%     lattice.addcoupling('mat', 'J2', 'bond', 2);
%     lattice.addmatrix('label', 'J3', 'value', exchangeInteractions(1), 'color', 'blue');
%     lattice.addcoupling('mat', 'J3', 'bond', 3);

    % J2 in the original setup
%     lattice.addmatrix('label', 'J4', 'value', exchangeInteractions(2), 'color', 'r');
%     lattice.addcoupling('mat', 'J4', 'bond', 4);
%     lattice.addmatrix('label', 'J5', 'value', exchangeInteractions(2), 'color', 'g');
%     lattice.addcoupling('mat', 'J5', 'bond', 5);
%     lattice.addmatrix('label', 'J6', 'value', exchangeInteractions(2), 'color', 'b');
%     lattice.addcoupling('mat', 'J6', 'bond', 6);
% 
%     % J3 in the original setup (and J9)
%     lattice.addmatrix('label', 'J8', 'value', exchangeInteractions(3), 'color', 'r');
%     lattice.addcoupling('mat', 'J8', 'bond', 8);
%     lattice.addmatrix('label', 'J9', 'value', exchangeInteractions(3), 'color', 'g');
%     lattice.addcoupling('mat', 'J9', 'bond', 9);
%     lattice.addmatrix('label', 'J11', 'value', exchangeInteractions(3), 'color', 'b');
%     lattice.addcoupling('mat', 'J11', 'bond', 11);
%     lattice.addmatrix('label', 'J12', 'value', exchangeInteractions(3), 'color', 'y');
%     lattice.addcoupling('mat', 'J12', 'bond', 12);
% 
    lattice.addmatrix('label', 'Jd1', 'value', exchangeInteractions(3), 'color', 'r');
    lattice.addcoupling('mat', 'Jd1', 'bond', 7);
    lattice.addmatrix('label', 'Jd2', 'value', exchangeInteractions(3), 'color', 'g');
    lattice.addcoupling('mat', 'Jd2', 'bond', 10);
    lattice.addmatrix('label', 'Jd3', 'value', exchangeInteractions(3), 'color', 'b');
    lattice.addcoupling('mat', 'Jd3', 'bond', 13);

%     lattice.addmatrix('label', 'Jin1', 'value', exchangeInteractions(4), 'color', 'r');
%     lattice.addcoupling('mat', 'Jin1', 'bond', 14);
%     lattice.addmatrix('label', 'Jin2', 'value', exchangeInteractions(4), 'color', 'g');
%     lattice.addcoupling('mat', 'Jin2', 'bond', 15);
% 
%     %lattice.addmatrix('label', 'J8', 'value', exchangeInteractions(3));
%     %lattice.addcoupling('mat', 'J8', 'bond', 8);
% 
%      %lattice.addmatrix('label', 'J11', 'value', exchangeInteractions(3));
%      %lattice.addcoupling('mat', 'J11', 'bond', 11);

     %lattice.addmatrix('label', 'J12', 'value', exchangeInteractions(3));
     %lattice.addcoupling('mat', 'J12', 'bond', 12);

    mgIR = [
        [-1, 1, -2, 2, -2, 2, 1,-1, 2, -2, 2, -2];
        [0, 0, -3, -3, -3, -3, 0, 0, 3, 3, 3, 3];
        [-1, 1, -1.75, 1.75, -1.75, 1.75, 1, -1, 1.75, -1.75, 1.75, -1.75]
    ];

    lattice.genmagstr('mode','direct','nExt', [2 1 1], 'unit', 'lu', 'n', [0 0 1], 'S', mgIR, 'k', [0.5 0 0])

    plot(lattice, 'range', [1 2 1])

    interactionBondList = [ [1, 2, 3, 0];
                            [4, 5, 6, 0];
                            [7, 10, 13, 0];
                            [14, 15, 0, 0];
                            ];
end

