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

        kagome
        runtimeParameters
    end
    
    methods
        function obj = PowSpecData(exchangeInteractions, ~, runtimeParameters)
            %POWSPECDATA Construct an instance of this class
            obj.exchangeInteractions = exchangeInteractions;
            obj.powderSpectrum = struct([]);
            obj.totalIntensities = [];
            obj.chiSquared = NaN;

            obj = obj.create_kagome(exchangeInteractions);
            obj.runtimeParameters = runtimeParameters;
        end

        function obj = calculatePowderSpectrum(obj)
            try
                Q_values = obj.runtimeParameters.Q_centre - obj.runtimeParameters.Q_range:0.05:obj.runtimeParameters.Q_centre + obj.runtimeParameters.Q_range;
                %Q_values = linspace(obj.runtimeParameters.Q_centre - obj.runtimeParameters.Q_range, obj.runtimeParameters.Q_centre + obj.runtimeParameters.Q_range, obj.runtimeParameters.nQBuckets);
                obj.powderSpectrum = obj.kagome.powspec(Q_values, 'Evect', obj.runtimeParameters.E_buckets, 'nRand', obj.runtimeParameters.nRand, 'hermit', true, 'imagChk', false, 'fid', 0, 'tid', 0);
                obj.powderSpectrum = sw_instrument(obj.powderSpectrum, 'norm',true, 'dE',0.1, 'dQ',0.05,'Ei',5);
            catch e
                rethrow(e);
            end
        end

        function obj = calculateIntensityList(obj)
            totalIntensityList = get_total_intensities(obj.powderSpectrum.swConv, obj.runtimeParameters.cutoffIndex);

            obj.totalIntensities = totalIntensityList;
        end
        
        function obj = calculateChiSquared(obj, experimentalIntensityList)
            % Rescale the theory data before we calculate chi squared
            obj.scaleFactor = max(experimentalIntensityList, [], 'all') / max(obj.getTotalIntensities(), [], 'all');
            obj.totalIntensities = obj.totalIntensities * obj.scaleFactor;

            chiSquared = calculate_chi_squared(experimentalIntensityList, obj.getTotalIntensities());

            if chiSquared < obj.runtimeParameters.takeAverageCutoff
                chiSquared = obj.recalculateChiSquared(chiSquared, experimentalIntensityList, 5);
            end

            obj.chiSquared = chiSquared;
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
            for i = 1:size(obj.exchangeInteractions)
                obj.kagome.setmatrix('mat', i, 'pref', obj.exchangeInteractions(i));
            end
        end
    end

    methods (Access=private)
        function chiSquared = recalculateChiSquared(obj, initialChiSquared, experimentalIntensityList, n)
            totalChiSquared = initialChiSquared;
            for i = 1:n
                obj1 = obj.calculatePowderSpectrum();
                obj1 = obj1.calculateIntensityList();
                loopChiSquared = obj1.calculateChiSquaredNoMean(experimentalIntensityList);
                totalChiSquared = totalChiSquared + loopChiSquared;
            end
            chiSquared = totalChiSquared / (n + 1);
        end

        function chiSquared = calculateChiSquaredNoMean(obj, experimentalIntensityList)
            chiSquared = calculate_chi_squared(experimentalIntensityList, obj.scaleFactor * obj.getTotalIntensities());
        end

        function obj = create_kagome(obj, exchangeInteractions)
            k = spinw;
            k.genlattice('lat_const', [6 6 10], 'angled', [90 90 120], 'spgr', 'P -3')
            k.addatom('r', [1/2 0 0], 'S', 1/2, 'label', 'MCu1', 'color', 'r')

            k.gencoupling('maxDistance', 7)

            % Set up exchange interactions over the lattice.
            k.addmatrix('label', 'J1', 'value', exchangeInteractions(1), 'color', 'r')
            k.addmatrix('label', 'J2', 'value', exchangeInteractions(2), 'color', 'g')
            k.addmatrix('label', 'J3', 'value', exchangeInteractions(3))
            k.addmatrix('label', 'Jd', 'value', exchangeInteractions(4), 'color', 'b')
            k.addcoupling('mat', 'J1', 'bond', 1)
            k.addcoupling('mat', 'J2', 'bond', 2)
            k.addcoupling('mat', 'J3', 'bond', 3)
            k.addcoupling('mat', 'Jd', 'bond', 4)

            % Generate lattice spins
            mgIR = [1 1 1
                0 0 0
                0 0 0];
            k.genmagstr('mode', 'direct', 'nExt', [1 1 1], 'unit', 'lu', 'n', [0 0 1], 'S', mgIR, 'k', [0 0 0]);

            obj.kagome = k;
        end
    end
end

