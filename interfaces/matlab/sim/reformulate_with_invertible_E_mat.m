function [ gnsf ] = reformulate_with_invertible_E_mat( gnsf, model, print_info)
%
%   This file is part of acados.
%
%   acados is free software; you can redistribute it and/or
%   modify it under the terms of the GNU Lesser General Public
%   License as published by the Free Software Foundation; either
%   version 3 of the License, or (at your option) any later version.
%
%   acados is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%   Lesser General Public License for more details.
%
%   You should have received a copy of the GNU Lesser General Public
%   License along with acados; if not, write to the Free Software Foundation,
%   Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
%
%   Author: Jonathan Frey: jonathanpaulfrey(at)gmail.com

%% Description
% this function checks that the necessary condition to apply the gnsf
% structure exploiting integrator to a model, namely that the matrices E11,
% E22 are invertible holds.
% If this is not the case, it will make these matrices invertible and add
% corresponding terms, to the term C * phi, such that the obtained model is
% still equivalent

%% import CasADi and load models

import casadi.*

% check invertibility of E11, E22; and reformulate if needed
ind_11 = 1:gnsf.nx1;
ind_22 = gnsf.nx1+1 : gnsf.nx1+gnsf.nz;

%% check if E11, E22 are invertible

if or( rank(gnsf.E( ind_11, ind_11)) ~= gnsf.nx1, ...
        rank(gnsf.E( ind_22, ind_22)) ~= gnsf.nz ) 
    
    % print warning (always)
    disp(['the rank of E11 or E22 is not full after the reformulation']);
    disp(' ');
    disp(['the script will try to reformulate the model with an invertible matrix instead']);
    disp(['NOTE: this feature is not super stable and might need more testing!!!!!!']);
    
    %% load models
    x = model.x;
    xdot = model.xdot;
    z = model.z;
    
    % % GNSF
    % get dimensions
    nx1 = gnsf.nx1;    
    x1dot = xdot(1:nx1);

    k = [x1dot; z];
    for i = [1,2]
        if i == 1
            ind = 1:gnsf.nx1;
        else
            ind = gnsf.nx1+1 : gnsf.nx1 + gnsf.nz;
        end
        mat = gnsf.E(ind, ind);
        if rank(mat) < length(ind)
            if print_info
                disp(' ');
                disp(['the rank of E',num2str(i),num2str(i),' is not full']);
                disp(['the algorithm will try to reformulate the model with an invertible matrix instead']);
                disp(['NOTE: this feature is not super stable and might need more testing!!!!!!']);
            end

            for sub_max = ind
                sub_ind = min(ind):sub_max; 
                % regard the submatrix mat(sub_ind, sub_ind);
                sub_mat = gnsf.E(sub_ind, sub_ind);
                if rank(sub_mat) < length(sub_ind)
                    % reformulate the model by adding a 1 to last diagonal
                    % element and changing rhs respectively.
                    gnsf.E(sub_max, sub_max) = gnsf.E(sub_max, sub_max) + 1;
                    % this means adding the term 1 * k(sub_max) to the sub_max
                    % row of the l.h.s
                    if isempty(find(gnsf.C(sub_max,:), 1))
                        % add new nonlinearity entry
                        gnsf.C(sub_max, gnsf.n_out + 1) = 1;
                        gnsf.phi_expr = [gnsf.phi_expr; k(sub_max)];
                        gnsf = determine_input_nonlinearity_function( gnsf );
                    else
                        ind_f = find(gnsf.C(sub_max,:));
                        % add term to corresponding nonlinearity entry
                        % note: herbey we assume that C is a selection matrix,
                        % i.e. gnsf.phi_expr(ind_f) is only entering one equation;
                        if length(find(gnsf.C(:,ind_f))) ~= 1
                            error('matrix C is not a selection matrix, reformulation with invertible E11, E22 not supported!!!');
                        else
                            gnsf.phi_expr(ind_f) = gnsf.phi_expr(ind_f) + k(sub_max) / ...
                                gnsf.C(sub_max, ind_f);

                            gnsf = determine_input_nonlinearity_function( gnsf );
                        end
                    end
                end
            end
        end
    end
    check_reformulation(model, gnsf, print_info);
    disp('successfully reformulated the model with invertible matrices E11, E22');
end



end
