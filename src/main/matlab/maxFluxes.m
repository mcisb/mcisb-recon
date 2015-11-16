function maxFluxes(modelFilename)
    
    model = readCbModel(modelFilename);
    
    % Allow unlimited pi, h in mitochondria:
    model = addReaction(model, 'pi_transport_c_m', 'pi[c] <=> pi[m]');
    
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
    
    % Objective: growth:
    % objective = 'biomass_reaction';
    
    % Growth maximisation:
    % maxAllFluxes(modelFilename, objective, carbon_sources, normoxia, complex_media);

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