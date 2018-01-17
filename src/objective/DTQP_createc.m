%--------------------------------------------------------------------------
% DTQP_createc.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/dt-qp-project
%--------------------------------------------------------------------------
function c =  DTQP_createc(L,M,p,opts)
    % initialize constant term
	c = 0;            
    
    l.matrix = L;
    % add constant Lagrange term using same quadrature method as QP
    if ~isempty(L)
        [~,~,V] = DTQP_L(l,p,opts);
        c = sum(V);
    end
   
    % add constant Mayer term
    if ~isempty(M)
        c = c + M;
    end
    
end