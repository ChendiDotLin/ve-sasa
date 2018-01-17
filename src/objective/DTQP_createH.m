%--------------------------------------------------------------------------
% DTQP_createH.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/dt-qp-project
%--------------------------------------------------------------------------
function H = DTQP_createH(L,M,p,opts)

	HI = []; HJ = []; HV = [];

    if ~isempty(L)
        [I,J,V] = DTQP_L(L,p,opts);
        HI = [HI,I]; HJ = [HJ,J]; HV = [HV;V(:)];
    end
    
    if ~isempty(M)
        [I,J,V] = DTQP_M(M,p,opts);
        HI = [HI,I]; HJ = [HJ,J]; HV = [HV;V(:)];
    end
    
    % sparse matrix for Hessian
    if isempty(HV)
        H = []; % no Hessian
    else
        H = sparse(HI,HJ,HV,p.nx,p.nx);
        H = (H+H'); % make symmetric, then times 2 for 1/2*x'*H*x form
    end

end