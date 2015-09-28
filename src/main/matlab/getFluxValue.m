function flux_value = getFluxValue(model, reaction_names, FBAsolution)
    flux_value = FBAsolution.x(ismember(model.rxns, reaction_names));
end