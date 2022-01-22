function [XX,Risk_MAD,eta] = F_MAD_Frontier(RR,NN)

        [TT,nn] = size(RR);
        mu = mean(RR); 
        
        % computing ptf with minimum MAD
        f = [zeros(1,nn) ones(1,TT)/(TT)];
        A = [   RR-repmat(mu,TT,1)  -eye(TT)
              -(RR-repmat(mu,TT,1)) -eye(TT)];
        b = zeros(2*TT,1);
        Aeq = [ones(1,nn) zeros(1,TT)];
        beq = 1;
        LB = zeros(nn+TT,1);
        UB = [];
        options = optimoptions(@linprog,'Display','off');

        X = linprog(f,A,b,Aeq,beq,LB,UB,[],options);
        
        % computing the efficient frontier
        etamin = mu*X(1:nn);
        etamax = max(mu);
        eta = linspace(etamin,etamax,NN);

        Risk_MAD = NaN(1,length(eta));
        Aeq_ = [mu,          zeros(1,TT);
                ones(1,nn),  zeros(1,TT)];
        XX = NaN(nn,length(eta));
        
        for k=1:NN
            
            beq_ = [eta(k);
                      1  ];
            [X_,FX_] = linprog(f,A,b,Aeq_,beq_,LB,UB,[],options);
            XX(:,k) = X_(1:nn);
            Risk_MAD(k) = FX_;
            
        end

	% triggers the negative element to be 0
        XX(XX < 0) = 0;

end

