function W = F_MaxSharpe(RR)

sigma = cov(RR);
mu = mean(RR);
n = length(sigma);

    function [Sharpe] = Sharpe_ratio(W,sigma,mu)
        
        Sharpe = -(mu*W')/sqrt((W*sigma*W'));
        
    end

x0 = ones(1,n)./n;

MS = MultiStart('FunctionTolerance',2e-4,'UseParallel',true);
GS = GlobalSearch(MS,'Display','off');

Aeq = ones(1,n);
beq = 1;
LB = zeros(1,n);

problem = createOptimProblem('fmincon', 'objective', @(W)Sharpe_ratio(W,sigma,mu), 'x0', x0, 'Aeq', Aeq, 'beq', beq, 'lb', LB);
W = run(GS, problem);
W(W<0.00001) = 0;
W = W';

end

