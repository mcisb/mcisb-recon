function maxGrowth(model_filename)
    model = readCbModel(model_filename);
    solution = optimizeCbModel(model, 'max', 'one');
    writeResult(model, solution, 'growth.xls');