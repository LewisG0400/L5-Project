function [data, E_buckets] = create_averievite_data(inputData, nEBuckets)
    E_buckets = linspace(0, 15, nEBuckets);

    data = zeros(nEBuckets, 1);
    
    for i = 1:size(inputData, 1)
        E = inputData(i, 1);
        E_index = floor((E / 15) * (nEBuckets - 1) + 1);

        data(E_index) = data(E_index) + inputData(i, 2);
    end
end

