%--------------------------------------------------------------------------
% DTQP_default_opts.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/dt-qp-project
%--------------------------------------------------------------------------
function [setup,opts] = DTQP_default_opts(setup,opts)

    %----------------------------------------------------------------------
    % general options
    %----------------------------------------------------------------------
    % save the solution and plots to disk (custom plotting function)
    if ~isfield(opts,'saveflag')
        % opts.saveflag = 1; % save
        opts.saveflag = 0; % don't save
    end

    % name of the example
    if ~isfield(opts,'name')
        opts.name = mfilename; 
    end

    % path for saving
    if ~isfield(opts,'path')
        opts.path = mfoldername(mfilename('fullpath'),'_private'); 
    end

    % controls displaying diagnostics to the command window
    if ~isfield(opts,'displevel')
        opts.displevel = 2; % verbose
    %     opts.displevel = 1; % minimal
    %     opts.displevel = 0; % none
    end
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    % direct transcription specific
    %----------------------------------------------------------------------
    % defect constraint method
    if ~isfield(opts,'Defectmethod')
        % opts.Defectmethod = 'ZO'; % zero-order hold
        % opts.Defectmethod = 'EF'; % Euler forward 
        opts.Defectmethod = 'TR'; % trapezoidal
        % opts.Defectmethod = 'HS'; % Hermite-Simpson 
        % opts.Defectmethod = 'RK4'; % fourth-order Runge-Kutta 
        % opts.Defectmethod = 'PS'; % pseudospectral (both LGL and CGL)
        if (opts.displevel > 0) % minimal
            disp(['using default defect constraint method ',opts.Defectmethod])
        end
    end

    % quadrature method
    if ~isfield(opts,'Quadmethod')
        % opts.Quadmethod = 'CEF';
        opts.Quadmethod = 'CTR';
        % opts.Quadmethod = 'CQHS';
        % opts.Quadmethod = 'G';
        % opts.Quadmethod = 'CC';
        if (opts.displevel > 0) % minimal
            disp(['using default quadrature method ',opts.Quadmethod])
        end
    end

	% mesh type
    if ~isfield(opts,'NType')
        opts.NType = 'ED'; % 
        % opts.NType = 'LGL'; % 
        % opts.NType = 'CGL'; % 
        % opts.NType = 'USER'; % 
        if (opts.displevel > 0) % minimal
            disp(['using default mesh type ',opts.NType])
        end
    end
    
    %----------------------------------------------------------------------
    
    %----------------------------------------------------------------------
    % phase specific
    %----------------------------------------------------------------------
    for idx = 1:length(setup)
        % number of nodes
        if ~isfield(setup(idx).p,'nt')
            setup(idx).p.nt = 100; % 
            if (opts.displevel > 0) % minimal
                disp(['using default number of nodes ',num2str(setup(idx).p.nt),...
                    ' in phase ',num2str(idx)])
            end
        end   

    end
    %----------------------------------------------------------------------
    
    %----------------------------------------------------------------------
    % quadratic programming specific
    %----------------------------------------------------------------------
    % reordering of the optimization variables (see DTQP_reorder)
    if ~isfield(opts,'reorder')
        opts.reorder = 0;
        % opts.reorder = 1; % reorder
    end

    % solver
    if ~isfield(opts,'solver')
        opts.solver = 'built-in'; % MATLAB quadprog or linprog
        % opts.solver = 'qpip'; % 
        % opts.solver =  'ooqp'; % 
    end
    
    % display level in the optimization routine
    if ~isfield(opts,'disp')
        if opts.displevel > 1 % verbose
            opts.disp = 'Iter';
        else
            opts.disp = 'None';
        end
    end
    %----------------------------------------------------------------------
end