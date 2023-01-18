function [data, errors, E_buckets] = create_averievite_data(inputData, nEBuckets)
    E_buckets = linspace(0, 15, nEBuckets);

    data = zeros(nEBuckets, 1);
    errors = zeros(nEBuckets, 1);
    counts = zeros(nEBuckets, 1);
    
    for i = 1:size(inputData, 1)
        E = inputData(i, 1);
        E_index = floor((E / 15) * (nEBuckets - 1) + 1);

        data(E_index) = data(E_index) + inputData(i, 2);
        errors(E_index) = errors(E_index) + inputData(i, 3);
        counts(E_index) = counts(E_index) + 1;
    end
    
    for i = 1:nEBuckets
        if counts(i) == 0
            continue;
        end
        errors(i) = errors(i) / counts(i);
    end
end

