% Calculates the chi squared value between 2 lists of energies.
function chi_squared = calculate_chi_squared(calculation_intensities_experimental, experimental_errors, calculation_intensities_theory)
    sigma_2 = 1.0;

    diff = zeros([1 size(calculation_intensities_theory,2)]);
    for i = 1:size(calculation_intensities_theory, 2)
        if isnan(calculation_intensities_theory(i))
            diff(i) = 0;
            continue
        end
        diff(i) = ((calculation_intensities_experimental(i) - calculation_intensities_theory(i))^2) / experimental_errors(i)^2;
    end
    sum_diff = sum(diff);
    
    chi_squared = sum_diff;
end
