
function plot_exchanges_on_param_space(interaction_history, best_match_indices)
    for i = 1:size(best_match_indices, 2)
        interactions = interaction_history(best_match_indices(i), :);
        x = interactions(1);
        y = interactions(3);
        disp("x: " + x + ", y: " + y)
        plot3(y, x, 15, 'r+')
    end
end