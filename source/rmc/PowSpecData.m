classdef PowSpecData
    %POWSPECDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        exchangeInteractions
        powderSpectrum
        % This holds the total intensities 
        totalIntensities
        scaleFactor
        chiSquared
        matrixChiSquared
        thetaW

        % The bonds that each interaction works on
        lattice
        interactionBondList

        runtimeParameters
    end
    
    methods
        function obj = PowSpecData(exchangeInteractions, runtimeParameters)
            %POWSPECDATA Construct an instance of this class
            obj.exchangeInteractions = exchangeInteractions;
            obj.powderSpectrum = struct([]);
            obj.totalIntensities = [];
            obj.chiSquared = NaN;
            obj.matrixChiSquared = NaN;
            obj.thetaW = NaN;

            [obj.lattice, obj.interactionBondList] = runtimeParameters.latticeGenerator(exchangeInteractions);
            obj.runtimeParameters = runtimeParameters;
        end

        function obj = calculatePowderSpectrum(obj)
            try
                Q_values = obj.runtimeParameters.Q_centre - obj.runtimeParameters.Q_range:0.05:obj.runtimeParameters.Q_centre + obj.runtimeParameters.Q_range;
                %Q_values = linspace(obj.runtimeParameters.Q_centre - obj.runtimeParameters.Q_range, obj.runtimeParameters.Q_centre + obj.runtimeParameters.Q_range, obj.runtimeParameters.nQBuckets);
                obj.powderSpectrum = obj.lattice.powspec(Q_values, 'Evect', obj.runtimeParameters.E_buckets, 'nRand', obj.runtimeParameters.nRand, 'formfact', true, 'hermit', true, 'imagChk', false, 'fid', 0, 'tid', 0);
                obj.powderSpectrum = sw_instrument(obj.powderSpectrum, 'norm',true, 'dE',0.1, 'dQ',0.05,'Ei',obj.runtimeParameters.inputEnergy);
            catch e
                rethrow(e);
            end
        end

        function obj = calculatePowderSpectrumInQRange(obj, lowerQ, upperQ, nQs)
            try
                Q_values = linspace(lowerQ, upperQ, nQs);
                %Q_values = linspace(obj.runtimeParameters.Q_centre - obj.runtimeParameters.Q_range, obj.runtimeParameters.Q_centre + obj.runtimeParameters.Q_range, obj.runtimeParameters.nQBuckets);
                obj.powderSpectrum = obj.lattice.powspec(Q_values, 'Evect', obj.runtimeParameters.E_buckets, 'nRand', obj.runtimeParameters.nRand, 'formfact', true, 'hermit', true, 'imagChk', false, 'fid', 0, 'tid', 0);
                obj.powderSpectrum = sw_instrument(obj.powderSpectrum, 'norm',true, 'dE',0.1, 'dQ',0.05,'Ei',obj.runtimeParameters.inputEnergy);
            catch e
                rethrow(e);
            end
        end

        function obj = calculateIntensityList(obj)
            totalIntensityList = get_total_intensities(obj.powderSpectrum.swConv);

            obj.totalIntensities = totalIntensityList;
        end
        
        function obj = calculateChiSquared(obj, experimentalIntensityList, experimentalError)
            % Rescale the theory data before we calculate chi squared
            obj.scaleFactor = max(experimentalIntensityList, [], 'all') / max(obj.getTotalIntensities(), [], 'all');
            %obj.scaleFactor = mean(experimentalIntensityList, 'all') / mean(obj.getTotalIntensities(), 'all');

            if obj.scaleFactor == Inf
                obj.chiSquared = Inf;
                return;
            end

            obj.totalIntensities = obj.totalIntensities * obj.scaleFactor;

            chiSquared = calculate_chi_squared(experimentalIntensityList, experimentalError, obj.getTotalIntensities());

            if chiSquared < obj.runtimeParameters.takeAverageCutoff
                chiSquared = obj.recalculateChiSquared(chiSquared, experimentalIntensityList, experimentalError, 5);
            end

            obj.chiSquared = chiSquared;
        end

        function obj = calculateMatrixChiSquared(obj, experimentalIntensityMatrix)
            scaleFactor = max(experimentalIntensityMatrix, [], 'all') / max(obj.powderSpectrum.swConv, [], 'all');

            obj.matrixChiSquared = calculate_chi_squared_matrix(obj.powderSpectrum.swConv * scaleFactor, experimentalIntensityMatrix);
        end

%       Theta_w = -4/3*S(S+1)*sum(z*J_ij)
%          
%       where
%       Theta_w is the Weiss temperature
%       S is the spin value
%       z is the number of nearest neighbours
%       J_ij is the exchange interaction
        function obj = calculateWeissTemperature(obj, spin)
            % Multiply by 11.6 to convert from meV to K.
            % 4 nearest neighbours
            sum(obj.interactionBondList ~= 0, 2)
            obj.thetaW = -2/3 * spin * (spin + 1) * sum(obj.exchangeInteractions * 11.6 * sum(obj.interactionBondList ~= 0, 2));
        end

        function plot_powder_spectrum(obj)
            figure
            sw_plotspec(obj.powderSpectrum);
            subtitle("Interactions: [" + num2str(obj.exchangeInteractions) +"], Chi Squared: " + obj.chiSquared);
        end

        function plot_powder_spectrum_and_intensities(obj)
            
        end

        function totalIntensities = getTotalIntensities(obj)
            totalIntensities = obj.totalIntensities;
        end

        function chiSquared = getChiSquared(obj)
            chiSquared = obj.chiSquared;
        end

        function matrixChiSquared = getMatrixChiSquared(obj)
            matrixChiSquared = obj.matrixChiSquared;
        end

        function weissTemperature = getWeissTemperature(obj)
            weissTemperature = obj.thetaW;
        end

        function exchangeInteractions = getExchangeInteractions(obj)
            exchangeInteractions = obj.exchangeInteractions;
        end

        function obj = setExchangeInteractions(obj, newInteractions)
            obj.exchangeInteractions = newInteractions;
            for i = 1:size(obj.exchangeInteractions, 2)
%                 for bond = obj.interactionBondList(i, :)
%                     if bond == 0
%                         break;
%                     end
%                     setmatrix(obj.lattice, 'bond', bond, 'pref', {obj.exchangeInteractions(i)});
%                 end
                setmatrix(obj.lattice, 'bond', obj.interactionBondList(i, 1), 'pref', obj.exchangeInteractions(i));
                %setmatrix(obj.lattice, 'label', obj.interactionBondList(1, i), 'pref', {obj.exchangeInteractions(i)});
            end
        end
    end

    methods (Access=private)
        function chiSquared = recalculateChiSquared(obj, initialChiSquared, experimentalIntensityList, experimentalError, n)
            totalChiSquared = initialChiSquared;
            for i = 1:n
                obj1 = obj.calculatePowderSpectrum();
                obj1 = obj1.calculateIntensityList();
                loopChiSquared = obj1.calculateChiSquaredNoMean(experimentalIntensityList, experimentalError);
                totalChiSquared = totalChiSquared + loopChiSquared;
            end
            chiSquared = totalChiSquared / (n + 1);
        end

        function chiSquared = calculateChiSquaredNoMean(obj, experimentalIntensityList, experimentalError)
            chiSquared = calculate_chi_squared(experimentalIntensityList, experimentalError, obj.scaleFactor * obj.getTotalIntensities());
        end
    end
end

