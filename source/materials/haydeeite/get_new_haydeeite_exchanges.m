function newExchanges = get_new_haydeeite_exchanges(oldExchanges)
    newExchanges = oldExchanges;
    
    interactionToChange = 1 + floor((size(oldExchanges, 2)) * rand());
    newExchangeInteraction = rand() * (5 * 2) - 5;

    newExchanges(interactionToChange) = newExchangeInteraction;
end

