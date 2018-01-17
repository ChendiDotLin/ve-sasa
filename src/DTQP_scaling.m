%--------------------------------------------------------------------------
% DTQP_scaling.m
% apply scaling to the problem
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/dt-qp-project
%--------------------------------------------------------------------------
function [H,f,A,b,Aeq,beq,lb,ub,p,s] = DTQP_scaling(H,f,A,b,Aeq,beq,lb,ub,p,s)
    
    %----------------------------------------------------------------------
    % START: simple scaling
    %----------------------------------------------------------------------
    % initialize as unity scaling
    s1 = ones(p.nu*p.nt,1); s2 = ones(p.ns*p.nt,1); s3 = ones(p.np,1);

    % scale controls
    for k = 1:length(s)
        % extract matrix
        m = s(k).matrix(:);
        
        switch s(k).right
            case 1 % controls
                if p.nu == length(m)
                    s1 = kron(m,ones(p.nt,1));
                else
                    error('wrong size')
                end
                
            case 2 % states
                if p.ns == length(m)
                    s2 = kron(m,ones(p.nt,1));
                else
                    error('wrong size')
                end
                
            case 3 % parameters
                if p.np == length(m)
                    s3 = m;
                else
                    error('wrong size')
                end

            otherwise
                error(' ')
        end
    end
    
    % combine
    s = [s1;s2;s3];
    
    % diagonal scaling matrix
    S = sparse(diag(s));    

    % scale the matrices
    % H
    if ~isempty(H)
        H = S*H*S;
    end
    
    % f
    if ~isempty(f)
        f = s.*f;
    end
    
%     % b
%     if ~isempty(b)
%     end
    
    % A
    if ~isempty(A)
        A = A*S;
    end
    
%     % beq
%     if ~isempty(beq)
%     end
    
    % Aeq
    if ~isempty(Aeq)
        Aeq = Aeq*S;
    end
    
    % lb
    if ~isempty(lb)
        lb = lb./s;
    end 
    
    % ub
    if ~isempty(ub)
        ub = ub./s;
    end 
    
    %----------------------------------------------------------------------
    % END: simple scaling
    %----------------------------------------------------------------------
    
    %----------------------------------------------------------------------
    % START: constraint row scaling
    %----------------------------------------------------------------------
%     r = max(abs(A),[],2);
%     req = max(abs(Aeq),[],2);
%     
%     b
%     if ~isempty(b)
%         b = b./r;
%     end
%     
%     A
%     if ~isempty(A)
%         A = bsxfun(@rdivide,A,r);
%     end
%     
%     beq
%     if ~isempty(beq)
%         beq = beq./req;
%     end
%     
%     Aeq
%     if ~isempty(Aeq)
%         Aeq = bsxfun(@rdivide,Aeq,req);
%     end

    %----------------------------------------------------------------------
    % END: constraint row scaling
    %----------------------------------------------------------------------
end