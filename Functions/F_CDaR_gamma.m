function [Weights, CDaR] = F_CDaR_gamma(RR,alpha,gamma)
% RR = return matrix
% alpha = (0, 0.95, 0.9999999999999999)
% gamma = (0, 1/3, 2/3, 1)

n = size(RR,2);
y_ = cumsum(RR);
y = [zeros(1,n); y_];
w = cumsum(y);
T = size(w,1);
    
mu = mean(RR); 
uno = ones(T-1,1);
        
% computing ptf with minimum CDaR(alpha)
f = [zeros(1,n),        1/((1-alpha)*T)*ones(1,T), zeros(1,T),         1];
A = [    -w,          -eye(T),              + eye(T),       -ones(T,1);
          w,         zeros(T,T),             -eye(T),       zeros(T,1);
     zeros(T,n),     zeros(T,T),      -eye(T)+diag(uno,1),  zeros(T,1)];
b = zeros(T*3,1);
        
Aeq = [ones(1,n), zeros(1,T*2) 0];
beq = 1;
        
LB = [zeros(1,n), zeros(1,T), -inf(1,T+1)];
UB = [];
        
options = optimoptions(@linprog,'Display','off');

X = linprog(f,A,b,Aeq,beq,LB,UB,[],options);
        
etamin = mu*X(1:n);
etamax = max(mu);
        
% computing the portfolio at new level of expected return (gamma)
eta_chosen = etamin + gamma*(etamax-etamin); 
        
Aeq_ = [mu,           zeros(1,T*2) 0;
        ones(1,n),  zeros(1,T*2) 0];
beq_ = [eta_chosen;
           1  ];
[X_, CDaR] = linprog(f,A,b,Aeq_,beq_,LB,UB,[],options);
Weights = X_(1:n);

end

