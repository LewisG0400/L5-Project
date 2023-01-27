classdef Haydeeite < Material
    properties
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

        function newExchangeEnergies = getNewExchanges(oldExchangeEnergies)
            newExchangeEnergies = oldExchangeEnergies;
    
            interactionToChange = 1 + floor((size(oldExchangeEnergies, 2)) * rand());
            newExchangeInteraction = rand() * (maxExchangeEnergy * 2) - maxExchangeEnergy;

            newExchangeEnergies(interactionToChange) = newExchangeInteraction;
        end
    end
end