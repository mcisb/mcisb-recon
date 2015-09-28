function model = blockAllImports(model)
    import_reaction_ids = sum(model.S, 1) .* sum(model.S ~= 0, 1) == 1;
    
    if size(model.rxns(import_reaction_ids), 1)
        model = changeRxnBounds(model, model.rxns(import_reaction_ids), 0, 'u');
    end
    
    import_reaction_ids = sum(model.S, 1) .* sum(model.S ~= 0, 1) == -1;
    
    if size(model.rxns(import_reaction_ids), 1)
        model = changeRxnBounds(model, model.rxns(import_reaction_ids), 0, 'l');
    end
end