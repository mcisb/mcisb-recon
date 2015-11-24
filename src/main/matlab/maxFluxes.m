function maxFluxes(modelFilename)
    
    model = readCbModel(modelFilename);
    
    save model;
    modelFilename = 'model.mat';
    
    % Carbon sources:
    carbon_sources = {'EX_glc(e)'; 'EX_fru(e)'; 'EX_but(e)';
        'EX_hx(e)'; 'EX_octa(e)'; 'EX_dca(e)'; 'EX_ddca(e)';
        'EX_ttdca(e)'; 'EX_hdca(e)'; 'EX_ocdca(e)'; 'EX_arach(e)';
        'EX_docosac(e)'; 'EX_lgnc(e)'; 'EX_hexc(e)'; 'EX_ala_L(e)';
        'EX_arg_L(e)'; 'EX_asn_L(e)'; 'EX_asp_L(e)'; 'EX_cys_L(e)';
        'EX_gln_L(e)'; 'EX_glu_L(e)'; 'EX_gly(e)'; 'EX_his_L(e)';
        'EX_ile_L(e)'; 'EX_leu_L(e)'; 'EX_lys_L(e)'; 'EX_met_L(e)';
        'EX_phe_L(e)'; 'EX_pro_L(e)'; 'EX_ser_L(e)'; 'EX_thr_L(e)';
        'EX_trp_L(e)'; 'EX_tyr_L(e)'; 'EX_val_L(e)'};
    
    % Normoxia:
    normoxia = [1; 0];
    
    % Media:
    simple_media = {'EX_ca2(e)'; 'EX_cl(e)'; 'EX_fe2(e)'; 'EX_fe3(e)';
        'EX_h(e)'; 'EX_h2o(e)'; 'EX_k(e)'; 'EX_na1(e)'; 'EX_nh4(e)';
        'EX_so4(e)'; 'EX_pi(e)'};
    
    complex_media = {'EX_ca2(e)'; 'EX_cl(e)'; 'EX_fe2(e)'; 'EX_fe3(e)';
        'EX_h(e)'; 'EX_h2o(e)'; 'EX_k(e)'; 'EX_na1(e)'; 'EX_nh4(e)';
        'EX_so4(e)'; 'EX_pi(e)'};
    
    % Objective: target compounds, growth on glucose, aerobic:
    target_compounds = {'pmtcoa[c]'; 'chsterol[c]'; 'tag_hs[c]'; 'dag_hs[c]';
        'mag_hs[c]'; 'crm_hs[c]'; 'pa_hs[c]'; 'pe_hs[c]'; 'ps_hs[c]'; 'ala_L[c]';
        'arg_L[c]'; 'asn_L[c]'; 'asp_L[c]'; 'gln_L[c]'; 'glu_L[c]'; 'gly[c]';
        'pro_L[c]'; 'ser_L[c]'; 'ctp[c]'; 'utp[c]'; '3pg[c]'; 'accoa[m]'; 'akg[m]';
        'e4p[c]'; 'f6p[c]'; 'g3p[c]'; 'g6p[c]'; 'oaa[m]'; 'pep[c]'; 'pyr[c]';
        'r5p[c]'; 'succoa[m]'};
    
    for i = 1:size(target_compounds,1)
        target_compound = target_compounds{i};
        reaction_def = sprintf('%s --> ', target_compound);
        reaction_name = target_compound;
        model = addReaction(model, reaction_name, reaction_def);
        maxFlux(0, 'EX_glc(e)', reaction_name, 1, simple_media, model);
        model = removeRxns(model, reaction_name);
    end
    
    % Objective: growth:
    objective = 'biomass_reaction';
    
    % Growth maximisation:
    maxAllFluxes(modelFilename, objective, carbon_sources, normoxia, complex_media);

    % Objective: ATP maximisation:
    objective = 'DM_atp_c_';
    
    % ATP maximisation:
    maxAllFluxes(modelFilename, objective, carbon_sources, normoxia, simple_media);
    

    
end


function maxAllFluxes(modelFilename, objective, carbon_sources, normoxia, media)

    for i = 1:size(normoxia,1)
        for j = 1:size(carbon_sources,1)
            maxFlux(modelFilename, carbon_sources{j}, objective, normoxia(i), media);
        end
    end
    
end