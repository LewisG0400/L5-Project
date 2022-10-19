# L5-Project
This project aims to calculate exchange interactions in materials by considering the spin wave dispersion.

## General Process

The program will fit exchange interaction values using a Reverse Monte Carlo technique. The main steps are as follows:

1. Pick some arbritary values for each exhange interaction.
2. Use these values to simulate spin wave dispersion from a powder sample using SpinW
3. Compare this calculated spin wave dispersion to data gathered from the material in the lab by calculating some chi squared value.
4. Use the chi squared value to modify the exchange interaction values by following the Reverse Monte Carlo algorithm.
5. Repeat steps 2-4 until we have minimised chi squared, and found the most accurate values for the exchange interactions.

## Experimental Data

Experimental data comes in the form Q, E, S, so needs to be converted into a matrix with the i,j element corresponding to S for the ith energy bucket and jth Q bucket. This is done in the create_data_matrix function.

## Calculation of Chi Squared

Chi squared is currently calculated by calculating the total difference between the total intensities at all Q values (REWRITE). This is done in a two step process:

1. For each value of Q, sum the intensities for every energy level at this Q value and Q values within some tolerance range (+/- 0.1 for now). The result of this is a vector with the ith corresponding to the total intensity for the ith Q bucket. This is done to both the experimental and theoretical data using the get_energy_slices function.

2. Do an element-wise subtraction between the experimental and theoretical vectors and sum over the resultant vector to obtain chi squared (calculate_chi_squared function).