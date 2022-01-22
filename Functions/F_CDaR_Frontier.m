function [XX,Risk_CDaR,eta] = F_CDaR_Frontier(RR,alpha,NN)
% AvgDD = 0
% CDaR = 0.95
% MaxDD = 0.9999999999999999

nAssets = size(RR,2);
w = [zeros(1,nAssets); RR];
y = cumsum(w); % every uncompounded cumulative asset return on DL
    
[TT,nn] = size(y);
mu = mean(RR); 
uno = ones(TT-1,1);
        
% computing ptf with minimum CDaR(alpha)
f = [zeros(1,nn),   1/((1-alpha)*TT)*ones(1,TT),  zeros(1,TT),            1];
A = [     -y,                -eye(TT),              +eye(TT),         -ones(TT,1);
           y,            zeros(TT,TT),              -eye(TT),         zeros(TT,1);
     zeros(TT,nn),       zeros(TT,TT),        -eye(TT)+diag(uno,1),   zeros(TT,1)];
b = zeros(TT*3,1);
        
Aeq = [ones(1,nn), zeros(1,TT*2), 0];
beq = 1;
        
LB = [zeros(1,nn), zeros(1,TT), -inf(1,TT+1)];
UB = [];
        
options = optimoptions(@linprog,'Display','off');

X = linprog(f,A,b,Aeq,beq,LB,UB,[],options);
        
% computing the efficient frontier
etamin = mu*X(1:nn);
etamax = max(mu);
eta = linspace(etamin,etamax,NN);

Risk_CDaR = NaN(1,length(eta));
Aeq_=[    mu,      zeros(1,TT*2) 0;
      ones(1,nn),  zeros(1,TT*2) 0];
XX = NaN(nn,length(eta));
        
        for k=1:NN
            
            beq_ = [eta(k);
                      1  ];
            [X_,FX_] = linprog(f,A,b,Aeq_,beq_,LB,UB,[],options);
            XX(:,k) = X_(1:nn);
            Risk_CDaR(k) = FX_;
            
        end
        
% triggers the negative element to be 0
XX(XX < 0) = 0;

end

