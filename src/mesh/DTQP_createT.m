%--------------------------------------------------------------------------
% DTQP_createT.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/dt-qp-project
%--------------------------------------------------------------------------
function p = DTQP_createT(p,opts)

switch opts.NType
    case 'ED'
%         if ~strcmp(p.DTmethod,'TR')
%             p.DTmethod = 'TR';
%             warning('ED points requires TR method')
%         end
        p.t = linspace(p.t0,p.tf,p.nt)'; % linearly spaced node points
    case 'LGL'
        tau = DTQP_nodes_LGL(p.nt-1);
        p.t = ( tau + (p.tf+p.t0)/(p.tf-p.t0) )*(p.tf-p.t0)/2;
    case 'CGL'
        tau = DTQP_nodes_CGL(p.nt-1);
        p.t = ( tau + (p.tf+p.t0)/(p.tf-p.t0) )*(p.tf-p.t0)/2;
    case 'USER'
        if ~exists('p.t')
            error('ERROR: p.t does not exist with USER option specified')
        end
        if ~strcmp(opts.DTmethod,'ED')
            opts.DTmethod = 'TR';
            warning('User mesh requires TR method')
        end

end

end