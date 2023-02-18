% Takes data in the form Q, E, S and converts it into a matrix with each
% element at i,j equal to S in the ith energy bucket and jth Q bucket.
function [dataMatrix, errorMatrix, QBuckets, EBuckets] = create_averievite_data(data)
    EBuckets = unique(data(:, 1)).';
    QBuckets = unique(data(:, 2)).';

    dataMatrix = reshape(data(:, 3), [size(EBuckets, 2) size(QBuckets, 2)]);
    errorMatrix = reshape(data(:, 4), [size(EBuckets, 2) size(QBuckets, 2)]);
end