function newExchangeInteractions = get_new_interactions(oldExchangeInteractions, maxValues)
    newExchangeInteractions = oldExchangeInteractions;
    
    interactionToChange = 1 + floor((size(oldExchangeInteractions, 2)) * rand());
    newExchangeInteraction = rand() * (maxValues * 2) - maxValues;

    newExchangeInteractions(interactionToChange) = newExchangeInteraction;
end

