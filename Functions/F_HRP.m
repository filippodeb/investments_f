function [Weights] = F_HRP(RR)

assetCovar = cov(RR);
cr = corrcov(assetCovar); % converts covariance matrix to correlation matrix

% Compute the correlation distance matrix
distCorr = ((1-cr)/2).^0.5;

% Compute the linkage
link = linkage(distCorr, 'single', 'euclidean');

% Quasi - diagonalization
numLeafNodes = size(link, 1) + 1;
rootGroupNodeId = 2*numLeafNodes-1;
sortedIdx = getLeafNodesInGroup(rootGroupNodeId, link);

% Recursive bisection
Weights = helperBisectHRP(assetCovar, sortedIdx);

end

