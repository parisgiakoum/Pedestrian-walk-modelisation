%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -- mu_weight_statDescription(GMModel, variable)
% Create a statistical description for mu (mean values) and weight (mixing
% proportions of mixture components)
% 
% Approach: Create matrixes with all mu and weights for each subject (215x5
% as they hold all values for each subject and each component for a
% specific variable) and do a column sort on mu (while also fixing index
% pairs on weights). Then a GMM is fitted for each of the 5
% components-columns (10 in total - 5 for mu and 5 for weight)
%
%%% Returns %%%
%%%
% GM_s_mu_mat: 1x5 (components)
% Cell array containing 5 GMMs to describe mu, 1 for each component (1
% variable - 3 components each)
%%%
% GM_s_weight_mat : 1x5 (components)
% Cell array containing 5 GMMs to describe the mixing proportions of
% mixture components, 1 for each component (1 variable - 3 components each)
%%%
% s_mu_mat : 215x5 (subjects x components)
% All mu values gathered by the data
%%%
% s_weight_mat : 215x5 (subjects x components)
% All mixing proportions values gathered by the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [GM_s_mu_mat, GM_s_weight_mat, s_mu_mat, s_weight_mat] = mu_weight_statDescription(GMModel, variable)

    % Create matrixes
    for i=1:length(GMModel) %1-215
        mu_mat(i,:) = GMModel{i}.mu(:,variable);
        weight_mat (i, :) = GMModel{i}.ComponentProportion;
    end

    % Sort mu_mat and fix index pairs for weight_mat
    [s_mu_mat s_mu_idx] = sort(mu_mat,2);
    % Keep same index for weights
    for i=1:size(weight_mat, 1) %1-215
        for j=1:size(weight_mat, 2) %1-5
            s_weight_mat(i,j) = weight_mat(i,s_mu_idx(i,j));
        end
    end

    % Fit GMM to mu and weight matrixes
    for i=1:size(s_mu_mat,2)    %1-5
        GM_s_mu_mat{i} = fitgmdist (s_mu_mat(:,i) , 3, 'SharedCovariance',true);
        GM_s_weight_mat{i} = fitgmdist (s_weight_mat(:,i) , 3, 'SharedCovariance',true);
    end
    
end