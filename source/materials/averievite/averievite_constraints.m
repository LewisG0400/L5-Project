function newExchangeInteractions = averievite_constraints(originalExchangeInteractions)
    newExchangeInteractions = originalExchangeInteractions;
    newExchangeInteractions(2) = -newExchangeInteractions(1);
    %newExchangeInteractions(4) = -newExchangeInteractions(3);
end