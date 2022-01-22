function W = F_MDP(RR)

sigma = cov(RR);
n = length(sigma);

    function [div_r] = F_Diversification_ratio(W,sigma)

        vol = sqrt(diag(sigma));
        div_r = -(W*vol./(sqrt(W*sigma*W')));

    end

x0 = ones(1,n)./n;

% MS = MultiStart('FunctionTolerance',2e-4,'UseParallel',true);
% GS = GlobalSearch(MS,'Display','off');

Aeq = ones(1,n);
beq = 1;
LB = zeros(1,n);

% problem = createOptimProblem('fmincon', 'objective', @(x)F_Diversification_ratio(x,sigma), 'x0', x0, 'Aeq', Aeq, 'beq', beq, 'lb', LB);
% W = run(GS, problem);


options = optimoptions('fmincon', 'Display', 'off', 'Algorithm', 'sqp', 'MaxFunctionEvaluations', 12000);
W = fmincon(@(W)F_Diversification_ratio(W,sigma), x0, [], [], Aeq, beq, LB, [], [], options);
W(W<0.0001) = 0;
W = W';




end