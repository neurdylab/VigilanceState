function [states_vec, allpred_llh, llh_vec] = detectVigilanceStateGMM(lowdim_path, num_states)

%========================================================================
% Input Args.
% lowdim_path: the path to the directory where the low-dimensional 
% fMRI data are saved. 
% num_states: the pre-defined number of states (number of clusters).
%             It must be positive integer

% Output Args.
% states_vec: the detected vigilance states based on largest LLH
% allpred_llh: intermediate results - the detected states for all dims
% llh_vec: intermediate results - the associated loglikelihood for allpred_llh

% This function depends on EmGm and natsort toolboxes
% Mo Chen (2021). EM Algorithm for Gaussian Mixture Model (EM GMM) 
% MATLAB Central File Exchange
% Stephen (2021). Natural-Order Filename Sort, MATLAB Central File Exchange

% Author: Shengchao Zhang
%         shengchao.zhang@vanderbilt.edu
%========================================================================

% Load all low-dimensional embeddings and sort them
D = dir([lowdim_path, '*.mat']);  
name_cell = getstruct_name(D);
D_name = natsortfiles(name_cell);
num_dim = length(D);

% Pre-allocate the space for saving the results
allpred_llh = cell(num_dim, 1);
llh_vec = zeros(num_dims, 1);

% Loop over each dimension
for ii = 1:num_dim
    
    fprintf('Number of neighbor is %s \n', num2str((ii+2)))
    load([lowdim_path, '\', D_name{ii}]);
    X_embed = embedding';
    
    % Temporarily record the results for current 50 iterations
    pred_temp_mat = [];  
    llh_temp_vec = zeros(50, 1);
    
    for iter = 1:50
        
        fprintf('Iteration %s/50 \n', num2str(iter))
            
        try
           [label, ~, llh] = mixGaussEm(X_embed, num_states);   
        catch    % In case EM algorithm fails
            label = zeros(1, size(X_embed, 2));
            llh = -100000;
        end

        llh_temp_vec(iter) = max(llh);

        pred_temp_mat = [pred_temp_mat; label];
        
    end
    
    % The result based on highest LLH at current dimension
    max_idx_llh = find(llh_temp_vec == max(llh_temp_vec));
    if length(max_idx_llh) ~= 1
        max_idx_llh = max_idx_llh(1);
    end
    
    allpred_llh{dim} = pred_temp_mat(max_idx_llh, :);
    llh_vec(dim) = llh_temp_vec(max_idx_llh);
    
end

% Now all dimensions have been processed, we choose the one that has the
% highest LLH for the final result
highest_idx = find(llh_vec == max(llh_vec));
if length(highest_idx) ~= 1
   highest_idx = highest_idx(1);
end

% Return the final result
states_vec = allpred_llh{highest_idx};

end