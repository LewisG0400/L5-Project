function [data, errors, E_buckets] = create_averievite_data_2(inputData, nEBuckets)
    nEBuckets = size(inputData, 1)
    E_buckets = zeros(1, nEBuckets);

    data = zeros(nEBuckets, 1);
    errors = zeros(nEBuckets, 1);
    
    for i = 1:nEBuckets
        E = inputData(i, 1);
        E_buckets(i) = E;

        data(i) = inputData(i, 2);
        errors(i) = inputData(i, 3);
    end
end

