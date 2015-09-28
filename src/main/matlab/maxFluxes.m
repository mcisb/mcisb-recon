function maxFluxes(modelFilename)
    
    changeCobraSolver('gurobi5');

    model = readCbModel(modelFilename);
    
    % Allow unlimited pi, h in mitochondria:
    model = addReaction(model, 'pi_transport_c_m', 'pi[c] <=> pi[m]');
    
    save model;
    modelFilename = 'model.mat';
    
    % Media:
    media = [ {'EX_ca2(e)'} {'EX_cl(e)'} {'EX_fe2(e)'} {'EX_fe3(e)'} {'EX_h(e)'} {'EX_h2o(e)'} {'EX_k(e)'} {'EX_na1(e)'} {'EX_nh4(e)'} {'EX_so4(e)'} {'EX_pi(e)'} ];
    
    % Objective:
    objective = 'DM_atp_c_';
    
    % Normoxic:
    normoxic = 1;
    maxAllFluxes(modelFilename, objective, normoxic, media);
    
    % Anaerobic:
    normoxic = 0;
    maxAllFluxes(modelFilename, objective, normoxic, media);
    
end


function maxAllFluxes(modelFilename, objective, normoxic, media)
    
    % Sugars:
    maxFlux(modelFilename, 'EX_glc(e)', objective, normoxic, media);
    maxFlux(modelFilename, 'EX_fru(e)', objective, normoxic, media);
    
    % Fatty acids:
    % maxFlux(modelFilename, 'EX_ppa(e)', objective, normoxic, media); % C3:0
    maxFlux(modelFilename, 'EX_but(e)', objective, normoxic, media); % C4:0
    maxFlux(modelFilename, 'EX_hx(e)', objective, normoxic, media); % C6:0
    maxFlux(modelFilename, 'EX_octa(e)', objective, normoxic, media); % C8:0
    maxFlux(modelFilename, 'EX_dca(e)', objective, normoxic, media); % C10:0
    maxFlux(modelFilename, 'EX_ddca(e)', objective, normoxic, media); % C12:0
    maxFlux(modelFilename, 'EX_ttdca(e)', objective, normoxic, media); % C14:0
    maxFlux(modelFilename, 'EX_hdca(e)', objective, normoxic, media); % C16:0
    maxFlux(modelFilename, 'EX_ocdca(e)', objective, normoxic, media); % C18:0
    maxFlux(modelFilename, 'EX_arach(e)', objective, normoxic, media); % C20:0
    maxFlux(modelFilename, 'EX_docosac(e)', objective, normoxic, media); % C22:0
    maxFlux(modelFilename, 'EX_lgnc(e)', objective, normoxic, media); % C24:0
    maxFlux(modelFilename, 'EX_hexc(e)', objective, normoxic, media); % C26:0
    
    % Amino acids:
    maxFlux(modelFilename, 'EX_ala_L(e)', objective, normoxic, media);
    maxFlux(modelFilename, 'EX_arg_L(e)', objective, normoxic, media);
    maxFlux(modelFilename, 'EX_asn_L(e)', objective, normoxic, media);
    maxFlux(modelFilename, 'EX_asp_L(e)', objective, normoxic, media);
    maxFlux(modelFilename, 'EX_cys_L(e)', objective, normoxic, media);
    maxFlux(modelFilename, 'EX_gln_L(e)', objective, normoxic, media);
    maxFlux(modelFilename, 'EX_glu_L(e)', objective, normoxic, media);
    maxFlux(modelFilename, 'EX_gly(e)', objective, normoxic, media);
    maxFlux(modelFilename, 'EX_his_L(e)', objective, normoxic, media);
    maxFlux(modelFilename, 'EX_ile_L(e)', objective, normoxic, media);
    maxFlux(modelFilename, 'EX_leu_L(e)', objective, normoxic, media);
    maxFlux(modelFilename, 'EX_lys_L(e)', objective, normoxic, media);
    maxFlux(modelFilename, 'EX_met_L(e)', objective, normoxic, media);
    maxFlux(modelFilename, 'EX_phe_L(e)', objective, normoxic, media);
    maxFlux(modelFilename, 'EX_pro_L(e)', objective, normoxic, media);
    maxFlux(modelFilename, 'EX_ser_L(e)', objective, normoxic, media);
    maxFlux(modelFilename, 'EX_thr_L(e)', objective, normoxic, media);
    maxFlux(modelFilename, 'EX_trp_L(e)', objective, normoxic, media);
    maxFlux(modelFilename, 'EX_tyr_L(e)', objective, normoxic, media);
    maxFlux(modelFilename, 'EX_val_L(e)', objective, normoxic, media);
    
end