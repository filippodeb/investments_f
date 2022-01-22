function [Weights, CVaR] = F_CVaR_gamma(RR,epsilon,gamma)
% RR = return matrix
% epsilon = confidence level
% gamma = (0, 1/3, 2/3, 1)

[T, n] = size(RR);
mu = mean(RR);

% computing ptf with minimum CVaR
f = [zeros(1,n) ones(1,T)/(T*epsilon) 1];
A = [-RR -eye(T) -ones(T,1)];
b = zeros(T,1);
Aeq = [ones(1,n) zeros(1,T) 0];
beq = 1;
LB = [zeros(n+T,1); -inf];
UB = [];
options = optimoptions(@linprog,'Display','off');

X = linprog(f,A,b,Aeq,beq,LB,UB,[],options);
        
etamin = mu*X(1:n);
etamax = max(mu);
        
% computing the portfolio at new level of expected return (gamma)
eta_chosen = etamin + gamma*(etamax-etamin); 
        
Aeq_ = [   mu,       zeros(1,T) 0;
        ones(1,n),   zeros(1,T) 0];
beq_ = [eta_chosen;
            1  ];
[X_, CVaR] = linprog(f,A,b,Aeq_,beq_,LB,UB,[],options);
        
Weights = X_(1:n);

end

