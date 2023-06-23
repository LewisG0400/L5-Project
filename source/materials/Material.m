classdef (Abstract) Material
    methods (Abstract, Static)
        newExchangeEnergies = getNewExchangeEnergies(self, oldExchangeEnergies)

        lattice = generateLattice(self)
        
    end

    methods
        function exchangeEnergies = createExchangeEnergies(self, initialGuess)
            valid = false;

            exchangeEnergies = initialGuess;

            while ~valid
                lattice = self.generateLattice(exchangeEnergies);

                try                    
                    lattice.powspec(0:0.1:1.0, 'Evect', 0:0.1:1.0, 'nRand', 1, 'hermit', true, 'imagChk', false)
                    valid = true;

                    disp("Valid:")
                    disp(num2str(exchangeEnergies))
                catch e
                    disp(e)
                    disp("Invalid:")
                    disp(num2str(exchangeEnergies))

                    exchangeEnergies = self.getNewExchangeEnergies(exchangeEnergies);
                end
            end
        end
    end
end

