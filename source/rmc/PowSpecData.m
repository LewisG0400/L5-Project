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

            [obj.lattice, obj.interactionBondList] = runtimeParameters.latticeGenerator(exchangeInteractions);
            obj.runtimeParameters = runtimeParameters;
        end

        function obj = calculatePowderSpectrum(obj)
            try
                Q_values = obj.runtimeParameters.Q_centre - obj.runtimeParameters.Q_range:0.05:obj.runtimeParameters.Q_centre + obj.runtimeParameters.Q_range;
                %Q_values = linspace(obj.runtimeParameters.Q_centre - obj.runtimeParameters.Q_range, obj.runtimeParameters.Q_centre + obj.runtimeParameters.Q_range, obj.runtimeParameters.nQBuckets);
                obj.powderSpectrum = obj.lattice.powspec(Q_values, 'Evect', obj.runtimeParameters.E_buckets, 'nRand', obj.runtimeParameters.nRand, 'hermit', true, 'imagChk', false, 'fid', 0, 'tid', 0);
                obj.powderSpectrum = sw_instrument(obj.powderSpectrum, 'norm',true, 'dE',0.1, 'dQ',0.05,'Ei',obj.runtimeParameters.maxEnergy);
            catch e
                rethrow(e);
            end
        end

        function obj = calculateIntensityList(obj)
            totalIntensityList = get_total_intensities(obj.powderSpectrum.swConv, obj.runtimeParameters.cutoffIndex);

            obj.totalIntensities = totalIntensityList;
        end
        
        function obj = calculateChiSquared(obj, experimentalIntensityList, experimentalError)
            % Rescale the theory data before we calculate chi squared
            obj.scaleFactor = max(experimentalIntensityList, [], 'all') / max(obj.getTotalIntensities(), [], 'all');

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
            obj.scaleFactor = max(experimentalIntensityMatrix, [], 'all') / max(obj.powderSpectrum.swConv, [], 'all');

            obj.chiSquared = calculate_chi_squared_matrix(obj.powderSpectrum.swConv * obj.scaleFactor, experimentalIntensityMatrix);
        end

        function totalIntensities = getTotalIntensities(obj)
            totalIntensities = obj.totalIntensities;
        end

        function chiSquared = getChiSquared(obj)
            chiSquared = obj.chiSquared;
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

