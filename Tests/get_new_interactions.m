function newExchangeInteractions = get_new_interactions(oldExchangeInteractions)
    newExchangeInteractions = oldExchangeInteractions;
    
    interactionToChange = 1 + floor((size(oldExchangeInteractions, 2)) * rand());
    newExchangeInteraction = rand() * 10.0 - 5.0;

    newExchangeInteractions(interactionToChange) = newExchangeInteraction;
end

