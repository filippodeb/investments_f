function [w, Area] = F_MaxArea(returns, step, max_iter, stopping_criterion)
% RR = return matrix
% step = step-size for the algorithm
% max_iter = maximum number of iterations for the algorithm
% stopping_criterion = tolerance

if exist('step')
else step = 0.02;    
end

if exist('max_iter') 
else max_iter = 1e4;  
end

if exist('stopping_criterion')
else stopping_criterion = 1e-5;    
end

[Risk_ref, Gain_ref] = F_Nadir_MaxArea(returns);

gamma = mean(returns);
rho = cov(returns);

% COMPUTING THE ALGORITHM
n = size(returns,2);
w = ones(1,n)/n;

for i=1:max_iter
    w_old = w;
    Area = (gamma*w' - Gain_ref)*(Risk_ref - sqrt(w*rho*w')) * 1e4;
    Gradient = (gamma*(Risk_ref - sqrt(w*rho*w')) + (gamma*w' - Gain_ref)*(-w*rho/sqrt(w*rho*w'))) * 1e4;
    w_int = w + step*Gradient;
    
    bget = false;
    s = sort(w_int,'descend'); tmpsum = 0;
    for ii = 1:n-1
        tmpsum = tmpsum + s(ii);
        tmax = (tmpsum - 1)/ii;
        if tmax >= s(ii+1)
            bget = true;
            break;
        end
    end
    
    if ~bget, tmax = (tmpsum + s(n) -1)/n; 
    end
    
    w = max(w_int-tmax,0);
    
    if norm(w - w_old, "inf") <= stopping_criterion
        norm(w - w_old, "inf");
        break;     
    end
end
w = w';
end

