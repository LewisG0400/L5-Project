function newExchangeInteractions = get_new_interactions_close(oldExchangeInteractions, range)
    newExchangeInteractions = oldExchangeInteractions;
    
    %interactionToChange = 1 + floor((size(oldExchangeInteractions, 2)) * rand());
    %newExchangeInteraction = oldExchangeInteractions(interactionToChange) + (rand() - 0.5) * 0.1;

    %newExchangeInteractions(interactionToChange) = newExchangeInteraction;

    randomOffset = (rand(1, size(newExchangeInteractions, 2)) * range - (range / 2));
    newExchangeInteractions = newExchangeInteractions + randomOffset;
end

