classdef (Abstract) Material
    properties (Abstract)
        nExchangeParameters
        maxExchangeEnergy
    end

    methods
        [data, errors, Q_buckets, E_buckets] = createData()

        exchangeEnergies = createExchangeEnergies()
        newExchangeEnergies = getNewExchanges(oldExchangeEnergies)
    end
end

