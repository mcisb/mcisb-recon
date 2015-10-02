function writeResult(model,FBAsolution,filename)
    significant_reactions = abs(FBAsolution.x) > 1e-6;
    formulas = printRxnFormula(model,model.rxns(significant_reactions),false,false,false,1,false);
    output = [model.rxns(significant_reactions) ...
        model.rxnNames(significant_reactions) ...
        formulas num2cell(model.lb(significant_reactions)) ...
        num2cell(model.ub(significant_reactions)) ...
        num2cell(FBAsolution.x(significant_reactions)) ...
        model.subSystems(significant_reactions)];
    
    output = sortrows(output, [6 7]);
    
    fileID = fopen(filename, 'w');
    formatSpec = '%s\t%s\t%s\t%d\t%d\t%f\t%s\n';
    [nrows, ~] = size(output);

    fprintf(fileID, '%s\t%s\t%s\t%s\t%s\t%s\t%s\n', 'Reaction id', 'Reaction name', 'Reaction definition', 'Lower bound', 'Upper bound', 'Flux', 'Subsystem');
    
    for row = 1:nrows
        fprintf(fileID,formatSpec,output{row,:});
    end
    
    fclose(fileID);
    
end