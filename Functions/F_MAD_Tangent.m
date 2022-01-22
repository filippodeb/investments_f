function [W] = F_MAD_Tangent(RR)

[T,n] = size(RR);
mu = mean(RR);

    function [Tangent] = MAD_ratio(W,mu)
        
        Tangent = -(mu*W')/((ones(1,T)./T)*(abs((RR-repmat(mu,T,1))*W')));
%         Tangent = -(mu*W')/sqrt((W*sigma*W'));
        
    end

x0 = ones(1,n).*(1/n);

% MS = MultiStart('FunctionTolerance',2e-4,'UseParallel',true);
% GS = GlobalSearch(MS,'Display','off');

Aeq = ones(1,n);
beq = 1;
LB = zeros(1,n);

% problem = createOptimProblem('fmincon', 'objective', @(W)MAD_ratio(W,mu), 'x0', x0, 'Aeq', Aeq, 'beq', beq, 'lb', LB);
% W = run(GS, problem);
options = optimoptions('fmincon', 'Display', 'off', 'Algorithm', 'sqp', 'MaxFunctionEvaluations', 12000);
W = fmincon(@(W)MAD_ratio(W,mu), x0, [], [], Aeq, beq, LB, [], [], options);

W(W<0.001) = 0;
W = W';

end

