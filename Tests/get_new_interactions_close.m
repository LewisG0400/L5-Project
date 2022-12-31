function newExchangeInteractions = get_new_interactions(oldExchangeInteractions)
    newExchangeInteractions = oldExchangeInteractions;
    
    interactionToChange = 1 + floor((size(oldExchangeInteractions, 2)) * rand());
    newExchangeInteraction = oldExchangeInteractions(interactionToChange) + (rand() - 0.5) * 0.1;

    newExchangeInteractions(interactionToChange) = newExchangeInteraction;
end

