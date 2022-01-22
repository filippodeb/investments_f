function [XX,Risk_Var,eta] = F_Markowitz_Frontier(RR,NN)

    nn = size(RR,2);
    mu = mean(RR);
    sigma = cov(RR);


    H = 2*sigma; % because sigma is already simmetric
    f = [];
    A = [];
    b = [];
    Aeq = ones(1,nn);
    beq = 1;
    LB = zeros(nn,1);
    UB = [];
    
    options = optimoptions(@quadprog,'Display','off');
    x_min = quadprog(H,f,A,b,Aeq,beq,LB,UB,[],options);

    eta_min = mu*x_min;
    eta_max = max(mu);

    eta = linspace(eta_min,eta_max,NN);

    % for each value of eta we perform the markowtiz problem

    Risk_Var = NaN(1,length(eta));
    XX = NaN(nn,length(eta)); % weight for every variance
    Aeq_ = [ones(1,nn); mu];

    for k = 1:length(eta)

        beq_ = [1;eta(k)];
        [x_,var_] = quadprog(H,f,A,b,Aeq_,beq_,LB,UB,[],options);
        Risk_Var(k) = var_;
        XX(:,k) = x_;

    end

	% triggers the negative element to be 0
        XX(XX < 0) = 0;

end

