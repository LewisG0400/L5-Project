
function plot_exchanges_on_param_space(chi_squareds, interaction_history, best_match_chi_squareds, best_match_indices)
    figure
    surf(-5.0:0.1:5.0, -5.0:0.1:5.0, chi_squareds, LineStyle="none", FaceColor="interp");
    grid on
    ax = gca;
    hold on
    xlabel("Jd")
    ax.XAxisLocation = 'top';
    ylabel("J1")
    title("Top 10 Plotted on Param Space")
    plot3(0.948, -3.275, 15, 'm*')
    for i = 1:size(best_match_indices, 2)
        interactions = interaction_history(best_match_indices(i), :);
        x = interactions(1);
        y = interactions(3);
        disp("x: " + x + ", y: " + y)
        plot3(y, x, 15, 'r+')
        %text(y, x, 15, num2str(best_match_chi_squareds(i)), 'VerticalAlignment','top','HorizontalAlignment','left')
    end
    legend('Parameter Space', 'Expected Values', 'Top 10 Values')
end