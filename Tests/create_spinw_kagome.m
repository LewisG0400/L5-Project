
function [kagome, exchange_interactions] = create_spinw_kagome(n_interactions)
    kagome = spinw;
    kagome.genlattice('lat_const', [6 6 10], 'angled', [90 90 120], 'spgr', 'P -3')
    kagome.addatom('r', [1/2 0 0], 'S', 1, 'label', 'MCu1', 'color', 'r')

    kagome.gencoupling('maxDistance', 7)

    % Randomly choose initial exchange interactions
    exchange_interactions = rand(1, n_interactions);
    interaction_names = ['J1', 'J2', 'Jd'];

    % Set up exchange interactions over the lattice.
    kagome.addmatrix('label', 'J1', 'value', exchange_interactions(1), 'color', 'r')
    kagome.addmatrix('label', 'J2', 'value', exchange_interactions(2), 'color', 'g')
    kagome.addmatrix('label', 'Jd', 'value', exchange_interactions(3), 'color', 'b')
    kagome.addcoupling('mat', 'J1', 'bond', 1)
    kagome.addcoupling('mat', 'J2', 'bond', 2)
    kagome.addcoupling('mat', 'Jd', 'bond', 4)

    % Generate lattice spins
    mgIR = [1 1 1
        0 0 0
        0 0 0];
    kagome.genmagstr('mode', 'direct', 'nExt', [1 1 1], 'unit', 'lu', 'n', [0 0 1], 'S', mgIR, 'k', [0 0 0]);
end