%--------------------------------------------------------------------------
% DTQP_convolution.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/dt-qp-project
%--------------------------------------------------------------------------
function Q = DTQP_convolution(A,B,p,opts)

% number of states
p.ns = size(A,1);

% initialize convolution output matrix
Q = zeros(p.ns,size(B,2),p.nt-1);

if isempty(B)
    return
elseif iscell(A)
        error('A should not be a function with the zero-hold method')
elseif iscell(B) % check if B is a cell (function)
    for i = 1:p.nt-1
        t0 = p.t(i);
        tf = p.t(i+1);
        if ~any(A(:)) % check if any elements of A are nonzero
            Q(:,:,i) = integral(@(t) eye(p.ns)*DTQP_tmatrix(B,p,t),t0,tf,...
                'ArrayValued',true,'RelTol',0,'AbsTol',1e-10);
        else % general case
            Q(:,:,i) = integral(@(t) expm(A*(tf-t))*DTQP_tmatrix(B,p,t),t0,tf,...
                'ArrayValued',true,'RelTol',0,'AbsTol',1e-10);
        end
    end
elseif abs(det(A)) < 100*eps % check if A is singular
    if strcmp(opts.NType,'ED') % equidistant points
        sysd  = c2d(ss(A,B,[],[]),p.h(1));
        Q = repmat(sysd.b,[1 1 p.nt-1]);
    else % general meshes
        for i = 1:p.nt-1
            sysd  = c2d(ss(A,B,[],[]),p.h(i));
            Q(:,:,i) = sysd.b;
        end
    end
else % solve the matrix exponential integral then multiply
    % http://math.stackexchange.com/questions/658276/integral-of-matrix-exponential
    if strcmp(opts.NType,'ED') % equidistant points
        q = A\( expm(A*(p.h(1))) - eye(p.ns) );
        q = q*B;
        Q = repmat(q,[1 1 p.nt-1]);
    else % general meshes
        for i = 1:p.nt-1
            q = A\( expm(A*(p.h(i))) - eye(p.ns) );
            Q(:,:,i) = q*B;
        end
    end
end

end