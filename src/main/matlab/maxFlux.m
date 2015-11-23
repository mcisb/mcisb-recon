function [flux, model] = maxFlux(modelFilename, carbon_source, objective, normoxic, media)
    
    if regexp(modelFilename, regexptranslate('wildcard', '*.xml'))
        model = readCbModel(modelFilename);
        save model;
    else
        model_obj = load(modelFilename);
        model = model_obj.model;
    end
    
    % Block import reactions:
    model = blockAllImports(model);
    
    % Define carbon source:
    model = changeRxnBounds(model, carbon_source, -1, 'b');
    
    % Define media:
    model = changeRxnBounds(model, media, -1000, 'l');
    
    if normoxic
        model = changeRxnBounds(model, 'EX_o2(e)', -1000, 'l');
    end
    
    % Specify objective and maximise:
    model = changeObjective(model, objective);
    FBAsolution = optimizeCbModel(model, 'max', 'one');
    
    if FBAsolution.f == 0
        fprintf('%s\t%s\t%d\tNo solution found\n', objective, carbon_source, normoxic);
    else
        flux = getFluxValue(model, objective, FBAsolution);
        result_filename_stem = strcat(modelFilename, '_', carbon_source, '_', objective, '_', num2str(normoxic));
        writeResult(model, FBAsolution, strcat(result_filename_stem, '.xls'));
        writeFusionTable(model, FBAsolution, strcat(result_filename_stem, '.txt'));
        fprintf('%s\t%s\t%d\t%.2f\n', objective, carbon_source, normoxic, flux);
    end
end