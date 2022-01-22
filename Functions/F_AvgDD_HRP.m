function [W] = F_AvgDD_HRP(RR)

nAssets = size(RR,2);
w = [zeros(1,nAssets); RR];
y = cumsum(w); % every uncompounded cumulative asset return on DL

[TT,nn] = size(y);
mu = mean(RR); 
uno = ones(TT-1,1);
        
% computing ptf with minimum CDaR(alpha)
f = [zeros(1,nn),        1/((1)*TT)*ones(1,TT), zeros(1,TT),         1];
A = [     -y,            -eye(TT),              +eye(TT),       -ones(TT,1);
           y,          zeros(TT,TT),            -eye(TT),       zeros(TT,1);
     zeros(TT,nn),     zeros(TT,TT),      -eye(TT)+diag(uno,1),  zeros(TT,1)];
b = zeros(TT*3,1);
        
Aeq = [ones(1,nn), zeros(1,TT*2) 0];
beq = 1;
        
LB = [zeros(1,nn), zeros(1,TT), -inf(1,TT+1)];
UB = [];
        
options = optimoptions(@linprog,'Display','off');

X = linprog(f,A,b,Aeq,beq,LB,UB,[],options);

etamin = mu*X(1:nn);
etamax = max(mu);
        
% computing the portfolio at new level of expected return (gamma)
eta_chosen = etamin + (2/3)*(etamax-etamin); 
        
Aeq_ = [mu,           zeros(1,TT*2) 0;
        ones(1,nn),  zeros(1,TT*2) 0];
beq_ = [eta_chosen;
            1  ];
XX = linprog(f,A,b,Aeq_,beq_,LB,UB,[],options);

% triggers the negative element to be 0
XX(XX < 0) = 0;

% find only selected assets
X_ = XX(1:nn);
X_(X_>0) = 1;
selection = find(X_==1);
RR_New = RR(:,selection);

[Weights] = F_HRP(RR_New);
W = zeros(nAssets,1);
for j = 1:length(selection)
    W(selection(j)) = Weights(j);
end

end

