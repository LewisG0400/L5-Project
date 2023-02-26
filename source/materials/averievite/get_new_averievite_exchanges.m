function newExchanges = get_new_averievite_exchanges(originalExchanges)
    newExchanges = originalExchanges;
    
    interactionToChange = 1 + floor(4 * rand());
    
    switch interactionToChange
        case 1
            % J1, (J2) in range (-)[0, 5]
            newEnergy = rand() * 20.0 - 10.0;
            newExchanges(1) = -newEnergy;
            newExchanges(2) = newEnergy;
        case 2
            % J3, (J9) in range [-1, 1]
            newEnergy = (rand() * 2.0) - 1.0;
            newExchanges(3) = newEnergy;
            newExchanges(4) = -newEnergy;
        case 3
            % Jd in range [-8, -10]
            %newEnergy = -9 + (rand() * 2.0) - 1.0;
            %newExchanges(5) = newEnergy;

            % Jd in range [-10, 0]
            newEnergy = -(rand() * 10);
            newExchanges(5) = newEnergy;
        case 4
            % Jin in range [6, 10]
            newEnergy = 8 + (rand() * 4.0) - 2.0;
            newExchanges(6) = newEnergy;
    end

end

