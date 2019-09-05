%%% This Tutorial will help you to generate condition/tissue specific models using gene expression data %%%
%% Load expressionData:  mRNA expression Data structure
%% Locus Vector containing GeneIDs
%% Data Presence/Absence Calls
 
expressionData = tdfread('expressionData_wt.txt');

%%% Read the FPKM expression data file for each week/condition/Tissue

expressionData.gene = cellstr(expressionData.gene)
[expressionRxns parsedGPR] = mapExpressionToReactions(c57Model_liver, expressionData);

options.expressionRxns=expressionRxns;
options.threshold = 10 % Set the threshold for expression data,. You can set threshold depending upon your experimental conditions. setting 1 is the lowest threshold for FPKM, you can set for the reaction to be active
options.solver = 'GIMME'
funcModel=1; %% 1 - Build a functional model having only reactions that can carry a flux (using FVA), 0 - skip this step (Default = 0)
exRxnRemove={}; %% Names of exchange reactions to remove (Default = [])

trt10Model_liver = createTissueSpecificModel(c57Model_liver, options,funcModel,exRxnRemove)

sol_trt10Model_liver = optimizeCbModel(trt10Model_liver);