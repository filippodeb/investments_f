function [XX,Risk_CVaR,eta] = F_CVaR_Frontier(RR,epsilon,NN)

        [TT,nn]=size(RR);
        mu = mean(RR); 
        
        % computing ptf with minimum CVaR
        f=[zeros(1,nn) ones(1,TT)/(TT*epsilon) 1];
        A=[-RR -eye(TT) -ones(TT,1)];
        b=zeros(TT,1);
        Aeq=[ones(1,nn) zeros(1,TT) 0];
        beq=1;
        LB=[zeros(nn+TT,1); -inf];
        UB=[];
        options=optimoptions(@linprog,'Display','off');

        X = linprog(f,A,b,Aeq,beq,LB,UB,[],options);
        
        % computing the efficient frontier
        etamin = mu*X(1:nn);
        etamax = max(mu);
        eta = linspace(etamin,etamax,NN);

        Risk_CVaR = NaN(1,length(eta));
        Aeq_ = [mu,           zeros(1,TT) 0;
                ones(1,nn),  zeros(1,TT) 0];
        XX = NaN(nn,length(eta));
        
        for k=1:NN
            
            beq_ = [eta(k);
                      1  ];
            [X_,FX_] = linprog(f,A,b,Aeq_,beq_,LB,UB,[],options);
            XX(:,k) = X_(1:nn);
            Risk_CVaR(k) = FX_;
            
        end

	% triggers the negative element to be 0
        XX(XX < 0) = 0;


end

