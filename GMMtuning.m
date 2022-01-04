function results_alldim = GMMtuning(lowdim_path, state_min, state_max)

%========================================================================
% Input Args.
% lowdim_path: the path to the directory where the low-dimensional 
% fMRI data are saved. 
% state_min, state_max: the pre-defined range for the number of states.
%                       Both of thme must be positive integers.

% Output Args.
% results_alldim: a cell that contains aic, bic, etc. for every choice 
%                 of states and for all dims 

% This function depends on natsort toolbox
% Stephen (2021). Natural-Order Filename Sort, MATLAB Central File Exchange

% Author: Shengchao Zhang
%         shengchao.zhang@vanderbilt.edu
%========================================================================

k = state_min : state_max;   % How many gaussian clusters there
nK = numel(k);
Sigma = {'diagonal','full'};
nSigma = numel(Sigma);
SharedCovariance = {true,false};
SCtext = {'true','false'};
nSC = numel(SharedCovariance);
RegularizationValue = 0.01;
options = statset('MaxIter',5000);

% Load all low-dimensional embeddings and sort them
D = dir([lowdim_path, '*.mat']);  
name_cell = getstruct_name(D);
D_name = natsortfiles(name_cell);
num_dim = length(D);

% Pre-allocate
results_alldim = cell(num_dim, 1);

for ii = 1:num_dim
    
    fprintf('Number of neighbor is %s \n', num2str((ii+2)))
    
    % Preallocation
    gm = cell(nK,nSigma,nSC);
    aic = zeros(nK,nSigma,nSC);
    bic = zeros(nK,nSigma,nSC);
    converged = false(nK,nSigma,nSC);
    
    % Load embeddings
    load([scan_dir, '\', D_name{ii}]);
    X = embedding;
    
    % Fit all models
    for m = 1:nSC
        for j = 1:nSigma
            for i = 1:nK
                gm{i,j,m} = fitgmdist(X,k(i),...
                'CovarianceType',Sigma{j},...
                'SharedCovariance',SharedCovariance{m},...
                'RegularizationValue',RegularizationValue,...
                'Options',options);
                aic(i,j,m) = gm{i,j,m}.AIC;
                bic(i,j,m) = gm{i,j,m}.BIC;
                converged(i,j,m) = gm{i,j,m}.Converged;
            end
        end
    end
    
    results_alldim{ii} = {gm, aic, bic, converged};
    
end

end