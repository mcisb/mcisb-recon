function writeFusionTable(model,FBAsolution,filename)
    significant_reactions = find(abs(FBAsolution.x) > 1e-6);
    significant_model = model.S(:, significant_reactions);
    [met_index, significant_rxn_index, stoich] = find(significant_model);
    
    from = [];
    to = [];
    flux = [];
    compartments = [];
    connectivity = [];
    subsystem = [];
    
    for i = 1:size(met_index)
        rxn_index = significant_reactions(significant_rxn_index(i));
        this_flux = FBAsolution.x(rxn_index) * stoich(i);
        reaction_name = model.rxns(rxn_index);
        
        if this_flux < 0
           this_from = model.mets(met_index(i));
           this_to = reaction_name;
           this_compartment = regexp(this_from, '(?<=\[)[a-z](?=\])', 'match');
        else
           this_from = reaction_name;
           this_to = model.mets(met_index(i));
           this_compartment = regexp(this_to, '(?<=\[)[a-z](?=\])', 'match');
        end
        
        from = [from; this_from];
        to = [to; this_to];
        flux = [flux; abs(this_flux)];
        compartments = [compartments; this_compartment{1}];
        connectivity = [connectivity; size(met_index(met_index == met_index(i)), 1)];
        subsystem = [subsystem; model.subSystems(rxn_index)];
    end
    
    output = [from to num2cell(flux) compartments num2cell(connectivity) subsystem];
    
    fileID = fopen(filename, 'w');
    formatSpec = '%s\t%s\t%f\t%s\t%d\t%s\n';
    [nrows, ~] = size(output);

    fprintf(fileID, '%s\t%s\t%s\t%s\t%s\t%s\n', 'From', 'To', 'Flux', 'Compartment(s)', 'Connectivity', 'Subsystem');
    
    for row = 1:nrows
        fprintf(fileID,formatSpec,output{row,:});
    end
    
    fclose(fileID);
    
end