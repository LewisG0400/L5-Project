classdef (Abstract) Material
    methods (Abstract, Static)
        newExchangeEnergies = getNewExchangeEnergies(oldExchangeEnergies)

        lattice = generateLattice()

        function exchangeEnergies = createExchangeEnergies(initialGuess)

        end
        
    end

    methods (Static)
        function exchangeEnergies = createExchangeEnergies(initialGuess, latticeFunction, exchangeFunction)
            valid = false;
            instance = SingleInstance.getInstance();
            lattice = latticeFunction();

            exchangeEnergies = initialGuess;

            while ~valid
                exchangeEnergies = exchangeFunction(exchangeEnergies);
                try
                    quickham(lattice, exchangeEnergies);
                    valid = true;

                    print("Valid:")
                    print(exchangeEnergies)
                catch e
                    print("Invalid:")
                    print(exchangeEnergies)
                end
            end
        end
    end
end

