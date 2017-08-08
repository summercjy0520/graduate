% Compiles the MIToolbox functions

mex MIToolboxMex.c MutualInformation.c Entropy.c CalculateProbability.c ArrayOperations.c -g
mex RenyiMIToolboxMex.c RenyiMutualInformation.c RenyiEntropy.c CalculateProbability.c ArrayOperations.c -g
mex WeightedMIToolboxMex.c WeightedMutualInformation.c WeightedEntropy.c CalculateProbability.c ArrayOperations.c -g
