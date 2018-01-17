%--------------------------------------------------------------------------
% CGL_nodes.m
% determines Chebyshev-Gauss-Lobatto (CGL) nodes
%--------------------------------------------------------------------------
% tau = CGL_nodes(N)
%   N: number of nodes minus 1, should be an integer greater than 0
% tau: CGL nodes
%--------------------------------------------------------------------------
% Examples:
% tau = CGL_nodes(1)
% -1     1
% tau = CGL_nodes(2)
% -1     0     1
% tau = CGL_nodes(3)
% -1  -0.5   0.5   1
%--------------------------------------------------------------------------
% Author: Daniel R. Herber, Graduate Student, University of Illinois at
% Urbana-Champaign
% Date: 06/04/2015
%--------------------------------------------------------------------------
function tau = DTQP_nodes_CGL(N)
%     % calculate node locations
%     tau = -cos(pi*(0:N)/n); % symbolically to maintain precision
%     tau = double(subs(tau,'n',N))';

    % calculate node locations
    tau = -cos(pi*(0:N)/N)';
end