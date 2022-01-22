function W = F_MostDiversifiedPortfolio( RR )
%F_MDP Computes the Most-Diversified Portfolio
%   Detailed explanation goes here

Sigma=cov(RR);
sigma_i=std(RR);

n=length(Sigma);

Aeq=sigma_i;
beq=1;

lb=zeros(1,n);
options = optimoptions(@quadprog,'Display','off');
[y, ~]=quadprog(Sigma,[],[],[],Aeq,beq,lb,[],[],options);

W=y/sum(y);

end

%    X = quadprog(H,f,A,b,Aeq,beq,LB,UB,X0,OPTIONS) 