%--------------------------------------------------------------------------
% DTQP_createf.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/dt-qp-project
%--------------------------------------------------------------------------
function f = DTQP_createf(l,m,p,opts)
    
	fI = []; fV = [];
    
    if ~isempty(l)
        [~,J,V] = DTQP_L(l,p,opts);
        fI = [fI,J]; fV = [fV;V(:)];
    end
    
    if ~isempty(m)
        [~,J,V] = DTQP_M(m,p,opts);
        fI = [fI,J]; fV = [fV;V(:)];
    end
    
    % sparse matrix for Hessian
    if isempty(fV)
        f = []; % no Hessian
    else
        % sparse matrix for gradient
        f = sparse(fI,1,fV,p.nx,1);
    end
    
end