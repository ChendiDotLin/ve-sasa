%--------------------------------------------------------------------------
% DTQP_defects_EF.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/dt-qp-project
%--------------------------------------------------------------------------
function [Aeq,beq] = DTQP_defects_EF(A,B,G,d,p,opts)

    % extract some of the variables in p
    nt = p.nt; nu = p.nu; ns = p.ns; np = p.np;
    nd = p.nd; h = p.h; nx = p.nx;
    
    % matrix form of I in the formulas
    K = kron(eye(ns),ones(nt-1,1));

    %------------------------------------------------------------------
    % calculate matrices
    %------------------------------------------------------------------
    % find time dependent matrices
    At = DTQP_tmatrix(A,p);
    Bt = DTQP_tmatrix(B,p);
    Gt = DTQP_tmatrix(G,p);
    dt = DTQP_tmatrix(d,p);
    
    % permute
    At = permute(At,[1,3,2]);
    Bt = permute(Bt,[1,3,2]);
    Gt = permute(Gt,[1,3,2]);
    dt = permute(dt,[1,3,2]);
    %------------------------------------------------------------------

    % initialize sequences 
    If = []; Jf = []; Vf = [];

     % defect constraint of row continuous constraints
    for i = 1:ns
        % current defect constraint row indices
        DefectIndices = (i-1)*(nt-1)+1:i*(nt-1);
        
        %------------------------------------------------------------------
        % controls
        %------------------------------------------------------------------
        if nu > 0
            I = repmat(DefectIndices,1,nu); % current defect constraint row indices
            J = 1:nu*nt; % current optimization variable column indices
            J(nt:nt:nu*nt) = []; % remove endpoints
            % T = 1:nu*nt; T(nt:nt:nu*nt) = [];
            T = J; % time indexing vector
            H = repmat(h,nu,1); % vector of time steps
            
            Bv = reshape(Bt(i,:,:),[],1);

            % theta values
            V3 = -H.*Bv(T); % theta 3

            % remove zeros
            ZeroIndex = (V3==0);
            I(ZeroIndex) = []; J(ZeroIndex) = []; V3(ZeroIndex) = [];

            % combine with 
            If = [If,I]; Jf = [Jf,J]; Vf = [Vf;V3];
 
        end
        %------------------------------------------------------------------
        
        %------------------------------------------------------------------
        % states
        %------------------------------------------------------------------
        % if ns > 0 % always is at least one state
            I = repmat(DefectIndices,1,ns); % current defect constraint row indices
            J = nu*nt+1:(nu+ns)*nt; % current optimization variable column indices
            J(nt:nt:end) = []; % remove endpoints
            % T = 1:ns*nt; T(nt:nt:ns*nt) = [];
            T = J - nt*nu; % time indexing vector (faster than line above)
            H = repmat(h,ns,1); % vector of time steps
            
            Av = reshape(At(i,:,:),[],1);

            % theta values
            V1 = -K(:,i) - H.*Av(T); % theta 1
            V2 = K(:,i); % theta 2
            
            % combine
            Is = [I,I];
            Js = [J,J+1];
            Vs = [V1;V2];

            % remove zeros
            ZeroIndex = (Vs==0);
            Is(ZeroIndex) = []; Js(ZeroIndex) = []; Vs(ZeroIndex) = [];

            % combine 
            If = [If,Is]; Jf = [Jf,Js]; Vf = [Vf;Vs];
        % end
        %------------------------------------------------------------------
        
        %------------------------------------------------------------------
        % parameters
        %------------------------------------------------------------------
        if np > 0
            I = repmat(DefectIndices,1,np); % current defect constraint row indices
            J = kron(nt*(nu+ns)+(1:np), ones(1,nt-1)); % current optimization variable column indices
            T = 1:np*nt; T(nt:nt:np*nt) = []; % time indexing vector
            H = repmat(h,np,1); % vector of time steps
            
            Gv = reshape(Gt(i,:,:),[],1);

            % theta values
            V = -H.*Gv(T); % theta 5  

            % remove zeros
            ZeroIndex = (V==0);
            I(ZeroIndex) = []; J(ZeroIndex) = []; V(ZeroIndex) = [];
            
            % combine
            If = [If,I]; Jf = [Jf,J]; Vf = [Vf;V];
        end
        %------------------------------------------------------------------
    end

	% output sparse matrix   
    Aeq = sparse(If,Jf,Vf,ns*(nt-1),nx);
    
    %------------------------------------------------------------------
	% disturbance
    %------------------------------------------------------------------
    if nd > 0
        % initialize sequences 
        Ifb = []; Vfb = [];
        
        for i = 1:ns % defect constraint of row continuous constraints
            I = repmat(DefectIndices,1,nd); % row (continuous)
            T = 1:nd*nt; T(nt:nt:nd*nt) = []; % time indexing vector
            H = repmat(h,nd,1); % vector of time steps
            
            dv = reshape(dt(i,:,:),[],1);

            % nu values
            V = H.*dv(T); % nu

            % remove zeros
            ZeroIndex = (V==0);
            I(ZeroIndex) = []; V(ZeroIndex) = [];

            % combine with 
            Ifb = [Ifb,I]; Vfb = [Vfb;V];
            
        end

        beq = sparse(Ifb,1,Vfb,ns*(nt-1),1);   
    else
        % output sparse matrix
        beq = sparse([],[],[],ns*(nt-1),1);
    end
    %------------------------------------------------------------------
end