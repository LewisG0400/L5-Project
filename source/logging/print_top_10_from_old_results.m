disp("Top 10:")
for i = 1:10
    currentIndex = best_matches_indices(i);
    disp("    Exchange Energies: [" + num2str(interaction_history(currentIndex, :)) + "]" + ", Chi Squared: " + num2str(chi_squared_history(currentIndex)));
end