classdef Haydeeite < Material
    properties (Constant)
        nExchangeParameters = 3
        maxExchangeEnergy = 5.0
    end

    methods
        function [data, errors, Q_buckets, E_buckets] = createData(inputData, nEnergyBuckets)
            E_max = max(inputData(:, 2));
            E_buckets = linspace(0, E_max, nEnergyBuckets);
            Q_buckets = zeros([1 ceil((inputData(end, 1) - inputData(1, 1)) * 100)]);

            data = zeros([nEnergyBuckets size(Q_buckets, 2)]);

            Q_index = 0;
            last_Q = -1;
            for i = 1:size(inputData, 1)
                Q = inputData(i, 1);
                E = inputData(i, 2);
                S = max(0, inputData(i, 3));

                if last_Q ~= Q
                    Q_index = Q_index + 1;
                    Q_buckets(Q_index) = Q;
                    last_Q = Q;
                end

                if E < cutoff_energy
                    continue
                end

                E_index = floor((E / E_max) * (nEnergyBuckets - 1) + 1);
                data(E_index, Q_index) = S;
            end
        end

        function lattice = generateLattice()
            lattice = spinw;
            lattice.genlattice('lat_const', [6 6 10], 'angled', [90 90 120], 'spgr', 'P -3')
            lattice.addatom('r', [1/2 0 0], 'S', 1/2, 'label', 'MCu1', 'color', 'r')

            lattice.gencoupling('maxDistance', 7)

            % Set up exchange interactions over the lattice.
            lattice.addmatrix('label', 'J1', 'value', exchangeInteractions(1), 'color', 'r')
            lattice.addmatrix('label', 'J2', 'value', exchangeInteractions(2), 'color', 'g')
            lattice.addmatrix('label', 'J3', 'value', exchangeInteractions(3), 'color', 'yellow')
            lattice.addmatrix('label', 'Jd', 'value', exchangeInteractions(3), 'color', 'b')
            lattice.addcoupling('mat', 'J1', 'bond', 1)
            lattice.addcoupling('mat', 'J2', 'bond', 2)
            lattice.addcoupling('mat', 'J3', 'bond', 3)
            lattice.addcoupling('mat', 'Jd', 'bond', 4)

            % Generate lattice spins
            mgIR = [1 1 1
                0 0 0
                0 0 0];
            lattice.genmagstr('mode', 'direct', 'nExt', [1 1 1], 'unit', 'lu', 'n', [0 0 1], 'S', mgIR, 'k', [0 0 0]);

        end

        function newExchangeEnergies = getNewExchangeEnergies(oldExchangeEnergies)
            newExchanges = oldExchanges;

            interactionToChange = 1 + floor((size(oldExchanges, 2)) * rand());
            newExchangeInteraction = rand() * (5 * 2) - 5;

            newExchanges(interactionToChange) = newExchangeInteraction;
        end

        
    end
end