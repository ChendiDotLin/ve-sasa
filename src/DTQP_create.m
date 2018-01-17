%--------------------------------------------------------------------------
% DTQP_create.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/dt-qp-project
%--------------------------------------------------------------------------
function [H,f,c,A,b,Aeq,beq,lb,ub,setup,p,opts] = DTQP_create(setup,opts)
    
    % extract parameter structure
    p = setup.p;

    % potentially start the timer
    if (opts.displevel > 0) % minimal
        tic % start timer
    end

    % intialize some stuff
    DTQP_initialize
    
    % objective function (maximum quadratic terms)
    H = DTQP_createH(setup.L,setup.M,p,opts); % create Hessian
    f = DTQP_createf(setup.l,setup.m,p,opts); % create gradient
    c = DTQP_createc(setup.c.L,setup.c.M,p,opts); % determine constants

    % constraints (maximum linear terms)   
    % create defect constraints
    [Aeq1,beq1] = DTQP_defects(setup.A,setup.B,setup.G,setup.d,p,opts);
	% create linear path and boundary equality contstraints
    [Aeq2,beq2] = DTQP_create_YZ(setup.Y,p); % NOTE: doesn't need opts?
    % combine linear equality constraints
    Aeq = [Aeq1;Aeq2];
    beq = [beq1;beq2]; % Aeq*X = beq
    
	% create linear path and boundary inequality contstraints
    [A,b] = DTQP_create_YZ(setup.Z,p); % A*X <= b
    
    % create simple bounds (box bounds)
    [lb,ub] = DTQP_create_bnds(setup.LB,setup.UB,p); % NOTE: doesn't need opts?
    
    % end the timer
    if (opts.displevel > 0) % minimal
        p.QPcreatetime = toc;
    end
    
    % display to the command window
    if (opts.displevel > 1) % verbose
        disp(['QP creation time: ', num2str(p.QPcreatetime), ' s'])
    end

end