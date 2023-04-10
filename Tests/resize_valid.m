realValid = zeros(40, 40, 40);

% for i = 1:40
%     for j = 1:1617
%         for k = 1:66297
%             real_j = mod(j, 40) + 1; % 40;
%             real_k = mod(k, 40) + 1;
% 
%             realValid(i, real_j, real_k) = valid(i, j, k);
%         end
%     end
% end

for i = 1:35
    for j = 1:35
        for k = 1:35
            original_j = 40 * i + j;
            original_k = 40 * i + 40 * j + k;

            realValid(i, j, k) = valid(i, original_j, original_k);
        end
    end
end