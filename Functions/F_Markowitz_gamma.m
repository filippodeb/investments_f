function [Weights,Variance] = F_Markowitz_gamma(RR,gamma)
% RR = return matrix
% gamma = (0, 1/3, 2/3, 1)

n = size(RR,2);
mu = mean(RR); 
sigma = cov(RR);
        
% computing ptf with minimum CDaR(alpha)
H = 2*sigma; % because sigma is already simmetric
f = [];
A = [];
b = [];
Aeq = ones(1,n);
beq = 1;
LB = zeros(n,1);
UB = [];
        
options = optimoptions(@quadprog,'Display','off');
X = quadprog(H,f,A,b,Aeq,beq,LB,UB,[],options);
        
etamin = mu*X;
etamax = max(mu);
        
% computing the portfolio at new level of expected return (gamma)
eta_chosen = etamin + gamma*(etamax-etamin); 
        
Aeq_ = [    mu;
        ones(1,n)];
beq_ = [eta_chosen;
           1  ];
[Weights,Variance] = quadprog(H,f,A,b,Aeq_,beq_,LB,UB,[],options);

end

