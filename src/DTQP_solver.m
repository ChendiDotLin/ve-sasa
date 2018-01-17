%--------------------------------------------------------------------------
% DTQP_solver.m
% run the appropriate solver and obtain the solution
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/dt-qp-project
%--------------------------------------------------------------------------
function [X,F,opts] = DTQP_solver(H,f,A,b,Aeq,beq,lb,ub,opts)

% potentially start the timer
if (opts.displevel > 0) % minimal
    tic % start timer
end

switch opts.solver
    case 'built-in' % built-in MATLAB solvers

        if isempty(H) && isempty(f) % feasibility problem
            % options
            options = optimoptions(@quadprog, 'Display',opts.disp,...
                'Algorithm','interior-point-convex','MaxIterations',200,...
                'ConstraintTolerance',10*eps,'OptimalityTolerance', 10*eps,...
                'StepTolerance',10*eps);
            warning('off','optim:quadprog:NullHessian');

            % solve the QP
            [X, F, EXITFLAG] = quadprog([],[],A,b,Aeq,beq,lb,ub,[],options);
            
            warning('on','optim:quadprog:NullHessian');
            %{
        elseif isempty(H) % linear program
            % options
            options = optimoptions(@linprog, 'Display', opts.disp,...
                'TolFun', 100000*eps, 'algorithm', 'interior-point',...
                'MaxIter', 200);

            % solve the LP
            [X, F, EXITFLAG] = linprog(f,A,b,Aeq,beq,lb,ub,[],options);
%}
        else % quadratic program
            % options
            options = optimoptions(@quadprog, 'Display',opts.disp,...
                'Algorithm','interior-point-convex','MaxIterations',200,...
                'ConstraintTolerance',1e-11,'OptimalityTolerance', 1e-11,...
                'StepTolerance',1e-11);

            % solve the QP
            [X, F, EXITFLAG] = quadprog(H,f,A,b,Aeq,beq,lb,ub,[],options);
            
        end
            
        % return Nan if bad exit flag
        if EXITFLAG < 0
            F = NaN;
        end
    %----------------------------------------------------------------------
    case 'qpip'
%         % solve the QP
%         X = qpip(full(H),full(f),full(A),full(b),full(Aeq),full(beq),full(lb),full(ub),1);
%         
%         % obtain objective function value
%         F = 0.5*X'*H*X + f'*X;
    %----------------------------------------------------------------------
    case 'ooqp'
%         % options
%         opts = optiset('display','iter','solver','OOQP','maxiter',200,....
%             'tolrfun',0,'tolafun',0,'tolint',0);
%         opts.linear_solver = 'PARDISO';
%         opts.algorithm = 'Mehrotra';
%         
%         % solve the QP
%         [X,F] = opti_ooqp(H,full(f),A,[],full(b),Aeq,full(beq),lb,ub,opts);
    %----------------------------------------------------------------------
    case 'admm'
% %         [X,F,p] = ADMMquadprog(H,f,A,b,Aeq,beq,lb,ub,p,[]);
% %         [X,F,p] = ADMMquadprog2(H,f,A,b,Aeq,beq,lb,ub,p);
%         opts = [];
%         [X,F,p] = QP_ADMM_2B(H,f,A,b,Aeq,beq,lb,ub,p,opts);
    %----------------------------------------------------------------------
    case 'admm2'
%         Iz = 1:p.nu*p.nt; % control indices
%         Ix =p.nu*p.nt+1:(p.nu+p.ns)*p.nt; % state indices
%         [X,F,p] = ADMMquadprog2(H,f,Aeq,beq,Ix,Iz,p);
end

% end the timer
if (opts.displevel > 0) % minimal
    opts.QPsolvetime = toc; % end the timer
end

% display to the command window
if (opts.displevel > 1) % verbose
    disp(['QP solving time: ', num2str(opts.QPsolvetime), ' s'])
end

end