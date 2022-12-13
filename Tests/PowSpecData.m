classdef PowSpecData
    %POWSPECDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        exchangeInteractions
        powderSpectrum
        % This holds the total intensities 
        totalIntensities
        chiSquared

        kagome
        runtimeParameters
    end
    
    methods
        function obj = PowSpecData(exchangeInteractions, kagome, runtimeParameters)
            %POWSPECDATA Construct an instance of this class
            obj.exchangeInteractions = exchangeInteractions;
            obj.powderSpectrum = struct([]);
            obj.totalIntensities = [];
            obj.chiSquared = NaN;

            obj.kagome = kagome;
            obj.runtimeParameters = runtimeParameters;
            
            for i = 1:size(exchangeInteractions)
                if i == 3
                    i = 4;
                end
                obj.kagome.setmatrix('mat', i, 'pref', exchangeInteractions(i));
            end
        end

        function obj = calculatePowderSpectrum(obj)
            try
                Q_values = obj.runtimeParameters.Q_centre - obj.runtimeParameters.Q_range:0.05:obj.runtimeParameters.Q_centre + obj.runtimeParameters.Q_range;
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
            scaleFactor = max(experimentalIntensityList, [], 'all') / max(obj.totalIntensities, [], 'all');
            obj.totalIntensities = obj.totalIntensities * scaleFactor;

            chiSquared = calculate_chi_squared(experimentalIntensityList, obj.totalIntensities);

            if chiSquared < obj.runtimeParameters.takeAverageCutoff
                obj.chiSquared = obj.recalculateChiSquared(chiSquared, 3);
            end
        end

        function totalIntensities = getTotalIntensities(obj)
            totalIntensities = obj.totalIntensities;
        end

        function chiSquared = getChiSquared(obj, experimentalIntensityList)
            if isnan(obj.chiSquared)
                obj = calculateChiSquared(obj, experimentalIntensityList);
            end
            chiSquared = obj.chiSquared;
        end

        function exchangeInteractions = getExchangeInteractions(obj)
            exchangeInteractions = obj.exchangeInteractions;
        end

        function obj = setExchangeInteractions(obj, newInteractions)
            obj.exchangeInteractions = newInteractions;

            for i = 1:size(newInteractions)
                obj.kagome.setmatrix('mat', i, 'pref', newInteractions(i));
            end
        end
    end

    methods (Access=private)
        function chiSquared = recalculateChiSquared(obj, initialChiSquared, n)
            totalChiSquared = initialChiSquared;
            for i = 1:n
                obj1 = obj.calculatePowderSpectrum(obj);
                obj1 = obj.calculateIntensityList(obj);
                obj1.chiSquared = NaN;
                totalChiSquared = totalChiSquared + obj1.getChiSquared();
            end
            chiSquared = totalChiSquared / (n + 1);
        end
    end
end

