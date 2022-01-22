function [Weights_HI, min_HI] = F_Choose_HI(XX)
% XX is a matrix [n,NN] where n is the number of assets and NN is the
% number of points in the frontier
% Weights_HH is the ptf with min Herfindhal

NN = size(XX,2);
ci = table;

for j = 1:NN
    ci(j,:) = concentrationIndices(XX(:,j));
end

HI = table2array(ci(:,5));
[min_HI, Ind_minHI] = min(HI);
Weights_HI = XX(:,Ind_minHI);

end
