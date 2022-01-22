function [Weights, MAD] = F_MAD_gamma(RR,gamma)
% RR = return matrix
% gamma = (0, 1/3, 2/3, 1)

[T,n] = size(RR);
mu = mean(RR); 
        
% computing ptf with minimum CVaR
f = [zeros(1,n) ones(1,T)/(T)];
A = [   RR-repmat(mu,T,1)  -eye(T)
     -(RR-repmat(mu,T,1)) -eye(T)];
b = zeros(2*T,1);

Aeq = [ones(1,n) zeros(1,T)];
beq = 1;

LB = zeros(n+T,1);
UB = [];

options = optimoptions(@linprog,'Display','off');
X = linprog(f,A,b,Aeq,beq,LB,UB,[],options);
        
etamin = mu*X(1:n);
etamax = max(mu);
        
% computing the portfolio at new level of expected return (gamma)
eta_chosen = etamin + gamma*(etamax-etamin); 
        
Aeq_ = [    mu,       zeros(1,T);
        ones(1,n),   zeros(1,T)];
beq_ = [eta_chosen;
                  1  ];
[X_,MAD] = linprog(f,A,b,Aeq_,beq_,LB,UB,[],options);
        
Weights = X_(1:n);

end

