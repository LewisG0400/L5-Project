% Calculates the chi squared value between 2 lists of energies.
function chi_squared = calculate_chi_squared(total_energies_1, total_energies_2)
    chi_squared = sum(total_energies_1 - total_energies_2);
end