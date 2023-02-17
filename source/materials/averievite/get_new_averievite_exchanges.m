function newExchanges = get_new_averievite_exchanges(originalExchanges)
    newExchanges = originalExchanges;
    
    interactionToChange = 1 + floor(4 * rand());
    
    switch interactionToChange
        case 1
            newEnergy = rand() * 5.0;
            newExchanges(1) = newEnergy;
            newExchanges(2) = -newEnergy;
        case 2
            newEnergy = (rand() * 2.0) - 1.0;
            newExchanges(3) = newEnergy;
            newExchanges(4) = -newEnergy;
        case 3
            newEnergy = -9 + (rand() * 2.0) - 1.0;
            newExchanges(5) = newEnergy;
        case 4
            newEnergy = 8 + (rand() * 4.0) - 2.0;
            newExchanges(6) = newEnergy;
    end

end

