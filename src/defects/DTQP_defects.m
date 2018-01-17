%--------------------------------------------------------------------------
% DTQP_defects.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/dt-qp-project
%--------------------------------------------------------------------------
% create the Aeq and beq matrices that represent the defect constraints
function [Aeq,beq] = DTQP_defects(A,B,G,d,p,opts)

    switch opts.Defectmethod
        case 'ZO' % zero-order hold
            [Aeq,beq] = DTQP_defects_ZO(A,B,G,d,p,opts);
        case 'EF' % Euler forward 
            [Aeq,beq] = DTQP_defects_EF(A,B,G,d,p,opts);
        case 'TR' % trapezoidal
            [Aeq,beq] = DTQP_defects_TR(A,B,G,d,p,opts);
        case 'HS' % Hermite-Simpson 
            [Aeq,beq] = DTQP_defects_HS(A,B,G,d,p,opts); 
        case 'RK4' % fourth-order Runge-Kutta 
            [Aeq,beq] = DTQP_defects_RK4(A,B,G,d,p,opts);   
        case 'PS' % pseudospectral (both LGL and CGL)
            [Aeq,beq] = DTQP_defects_PS(A,B,G,d,p,opts);
            
        case 'AB2' % two-step Adams-Bashforth
            [Aeq,beq] = DTQP_defects_AB2(A,B,G,d,p,opts);

        case 'ZO_old' % zero-order hold
            [Aeq,beq] = DTQP_defects_ZO_old(A,B,G,d,p,opts);
        case 'EF_old' % Euler forward 
            [Aeq,beq] = DTQP_defects_EF_old(A,B,G,d,p,opts);
        case 'TR_old' % trapezoidal
            [Aeq,beq] = DTQP_defects_TR_old(A,B,G,d,p,opts);
        case 'HS_old' % Hermite-Simpson 
            [Aeq,beq] = DTQP_defects_HS_old(A,B,G,d,p,opts); 
        case 'RK4_old' % fourth-order Runge-Kutta 
            [Aeq,beq] = DTQP_defects_RK4_old(A,B,G,d,p,opts);
        case 'PS_old' % pseudospectral (both LGL and CGL)
            [Aeq,beq] = DTQP_defects_PS_old(A,B,G,d,p,opts);
    end
    
end