%--------------------------------------------------------------------------
% DTQP_reorder.m
% reorder the optimization variables and constraint rows
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/dt-qp-project
%--------------------------------------------------------------------------
function [H,f,c,A,b,Aeq,beq,lb,ub,p,X] = DTQP_reorder(H,f,c,A,b,Aeq,beq,lb,ub,p,X,flag)

if flag == 0
    %----------------------------------------------------------------------
    % START: reorder opt variables, [U,Y,p] -> [u_1,y_1,...,u_n,y_n,p]
    %----------------------------------------------------------------------
    % final index for continuous variables
    e = (p.nu+p.ns)*p.nt;
    
    % reshape to get sorting vector
    sV = reshape(reshape(1:e,[],p.nu+p.ns)',[],1);

    % add the parameters
    sV = [sV;e+1:e+p.np];
    
    % H
    if ~isempty(H)
        H = H(:,sV);
        H = H(sV,:);
    end
    
    % f
    if ~isempty(f)
        f = f(sV);
    end
    
    % A
    if ~isempty(A)
        A = A(:,sV);
    end

    % Aeq
    if ~isempty(Aeq)
        Aeq = Aeq(:,sV);
    end
    
    % lb
    if ~isempty(lb)
        lb = lb(sV);
    end

    % ub
    if ~isempty(ub)
        ub = ub(sV);
    end
    %----------------------------------------------------------------------
    % END: reorder opt variables, [U,Y,p] -> [u_1,y_1,...,u_n,y_n,p]
    %----------------------------------------------------------------------
    
    %----------------------------------------------------------------------
    % START: reorder linear constraint rows
    %----------------------------------------------------------------------
    if ~isempty(Aeq)    
        % find the first nonzero entry in each row
        I = zeros(size(Aeq,1),1);
        for idx = 1:size(Aeq,1)
            I(idx) = find(Aeq(idx,:),1);
        end

        % sort the first entries
        [~,D] = sort(I);

        % sort the matrix rows
        Aeq = Aeq(D,:);

        if ~isempty(beq)
            beq = beq(D);
        end
    end

    if ~isempty(A)    
        % find the first nonzero entry in each row
        I = zeros(size(A,1),1);
        for idx = 1:size(A,1)
            I(idx) = find(A(idx,:),1);
        end

        % sort the first entries
        [~,D] = sort(I);

        % sort the matrix rows
        A = A(D,:);

        if ~isempty(b)
            b = b(D);
        end
    end
    %----------------------------------------------------------------------
    % END: reorder linear constraint rows
    %----------------------------------------------------------------------

else
    
    % reorder, [u_1, y_1, ... , u_n, y_n, p] -> [U,Y,p]
    sV = [];
    for i = 1:(p.nu+p.ns)
        sV = [sV, i:(p.nu+p.ns):p.nx];
    end

    X = X(sV);

end

end